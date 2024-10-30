import 'package:cbl/cbl.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class CustomConflictResolver extends ConflictResolver {
  @override
  Document resolve(Conflict conflict) {
    try {
      // Always return remote document if local is null
      if (conflict.localDocument == null) {
        return conflict.remoteDocument!;
      }
      // Always return local document if remote is null
      if (conflict.remoteDocument == null) {
        return conflict.localDocument!;
      }

      final localDoc = conflict.localDocument!;
      final remoteDoc = conflict.remoteDocument!;

      // Get timestamps with proper null handling
      final localMap = Map<String, dynamic>.from(localDoc.toPlainMap());
      final remoteMap = Map<String, dynamic>.from(remoteDoc.toPlainMap());

      final localTimestamp = localMap['lastModified'] as int? ?? 0;
      final remoteTimestamp = remoteMap['lastModified'] as int? ?? 0;

      // If one document is clearly newer, use that one
      if (localTimestamp > remoteTimestamp) {
        debugPrint('Using local document as it is newer');
        return localDoc;
      } else if (remoteTimestamp > localTimestamp) {
        debugPrint('Using remote document as it is newer');
        return remoteDoc;
      }

      // If timestamps are equal, merge the documents
      final mergedContent = _mergeDocuments(localMap, remoteMap);
      final mutableDoc = MutableDocument.withId(localDoc.id);
      mutableDoc.setData(mergedContent);
      return mutableDoc;
    } catch (e) {
      debugPrint('Error in conflict resolution: $e');
      debugPrint('Local document: ${conflict.localDocument?.toPlainMap()}');
      debugPrint('Remote document: ${conflict.remoteDocument?.toPlainMap()}');

      // Default to remote document if merge fails
      return conflict.remoteDocument ?? conflict.localDocument!;
    }
  }

  Map<String, dynamic> _mergeDocuments(
    Map<String, dynamic> localContent,
    Map<String, dynamic> remoteContent,
  ) {
    final mergedContent = Map<String, dynamic>.from(remoteContent);

    // Process all keys from both local and remote
    Set<String> allKeys = {...localContent.keys, ...remoteContent.keys};

    for (final key in allKeys) {
      final localValue = localContent[key];
      final remoteValue = remoteContent[key];

      if (remoteValue == null) {
        mergedContent[key] = localValue;
      } else if (localValue == null) {
        mergedContent[key] = remoteValue;
      } else if (localValue is List && remoteValue is List) {
        final mergedList = [...remoteValue];
        for (final item in localValue) {
          if (!mergedList.contains(item)) {
            mergedList.add(item);
          }
        }
        mergedContent[key] = mergedList;
      } else if (localValue is Map && remoteValue is Map) {
        mergedContent[key] = _mergeDocuments(
          Map<String, dynamic>.from(localValue),
          Map<String, dynamic>.from(remoteValue),
        );
      }
    }

    mergedContent['_merged'] = true;
    mergedContent['_mergeTimestamp'] = DateTime.now().millisecondsSinceEpoch;

    return mergedContent;
  }
}

class ReplicatorProvider {
  ReplicatorProvider({required this.databaseProvider});

  final DatabaseProvider databaseProvider;
  Replicator? _pullReplicator;
  Replicator? _pushPullReplicator;
  ReplicatorConfiguration? _pullConfiguration;
  ReplicatorConfiguration? _pushPullConfiguration;
  ListenerToken? statusChangedToken;
  ListenerToken? documentReplicationToken;
  bool isInitialized = false;
  bool _initialSyncComplete = false;

  ReplicatorStatus? _replicatorStatus;
  ReplicatorStatus? get replicatorStatus => _replicatorStatus;
  String get scope => "user_data";

  Future<void> init() async {
    if (isInitialized) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: already initialized');
      return;
    }

    debugPrint('${DateTime.now()} [ReplicatorProvider] info: starting init.');
    try {
      final db = databaseProvider.flipperDatabase;
      if (db == null) {
        throw Exception('Database is null');
      }

      final pem =
          await rootBundle.load('packages/flipper_services/assets/flipper.pem');

      final url = Uri(
        scheme: 'wss',
        host: AppSecrets.capelaHost,
        port: 4984,
        path: 'admin',
      );

      final counterCollection = await db.createCollection(countersTable, scope);

      final collectionConfig = CollectionConfiguration(
        conflictResolver: CustomConflictResolver(),
      );

      final basicAuthenticator = BasicAuthenticator(
        username: AppSecrets.capelaUsername,
        password: AppSecrets.capelaPassword,
      );

      final endPoint = UrlEndpoint(url);

      // Configure pull-only replicator for initial sync
      _pullConfiguration = ReplicatorConfiguration(
        target: endPoint,
        authenticator: basicAuthenticator,
        continuous: false,
        replicatorType: ReplicatorType.pull,
        heartbeat: const Duration(seconds: 30),
        pinnedServerCertificate: pem.buffer.asUint8List(),
      )
        ..addCollections([counterCollection], collectionConfig)
        ..maxAttempts = 5;

      // Configure push-pull replicator for ongoing sync
      _pushPullConfiguration = ReplicatorConfiguration(
        target: endPoint,
        authenticator: basicAuthenticator,
        continuous: true,
        replicatorType: ReplicatorType.pushAndPull,
        heartbeat: const Duration(seconds: 60),
        pinnedServerCertificate: pem.buffer.asUint8List(),
      )
        ..addCollections([counterCollection], collectionConfig)
        ..maxAttempts = 10;

      if (_pullConfiguration != null) {
        _pullReplicator = await Replicator.createAsync(_pullConfiguration!);
        await _setupReplicatorListeners(_pullReplicator!, true);
      }

      isInitialized = true;
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] info: initialization complete');
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] error during init: $e');
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _setupReplicatorListeners(
      Replicator replicator, bool isPullOnly) async {
    statusChangedToken = await replicator.addChangeListener((change) {
      _replicatorStatus = change.status;
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] status changed: ${change.status.activity}');

      if (isPullOnly &&
          change.status.activity == ReplicatorActivityLevel.stopped) {
        _handleInitialSyncComplete();
      }

      if (change.status.error != null) {
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] error: ${change.status.error}');
      }
    });

    documentReplicationToken =
        await replicator.addDocumentReplicationListener((replication) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] documents replicated: ${replication.documents.length}');
      for (var doc in replication.documents) {
        if (doc.error != null) {
          debugPrint(
              '${DateTime.now()} [ReplicatorProvider] document error: ${doc.error}');
        }
      }
    });
  }

  Future<void> _handleInitialSyncComplete() async {
    if (!_initialSyncComplete) {
      _initialSyncComplete = true;
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] Initial sync complete, switching to push-pull mode');

      // Clean up pull-only replicator
      await stopReplicator();

      // Set up and start push-pull replicator
      if (_pushPullConfiguration != null) {
        _pushPullReplicator =
            await Replicator.createAsync(_pushPullConfiguration!);
        await _setupReplicatorListeners(_pushPullReplicator!, false);
        await _pushPullReplicator!.start();
      }
    }
  }

  Future<void> startReplicator() async {
    if (!isInitialized) {
      throw Exception('ReplicatorProvider not initialized. Call init() first.');
    }

    debugPrint(
        '${DateTime.now()} [ReplicatorProvider] info: starting replicator.');

    try {
      final replicator =
          _initialSyncComplete ? _pushPullReplicator : _pullReplicator;
      if (replicator == null) {
        throw Exception('Replicator is null');
      }

      final currentStatus = await replicator.status;
      if (currentStatus.activity == ReplicatorActivityLevel.stopped) {
        await replicator.start();
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] info: started replicator.');
      } else {
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] warning: replicator already running.');
      }
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] error starting replicator: $e');
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> stopReplicator() async {
    final replicator =
        _initialSyncComplete ? _pushPullReplicator : _pullReplicator;
    if (replicator != null) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] info: stopping replicator.');

      try {
        await removeDocumentReplicationListener();
        await removeStatusChangeListener();
        await replicator.stop();

        statusChangedToken = null;
        documentReplicationToken = null;

        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] info: stopped replicator.');
      } catch (e, stackTrace) {
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] error stopping replicator: $e');
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] stackTrace: $stackTrace');
        rethrow;
      }
    } else {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: tried to stop replicator but it was null.');
    }
  }

  Future<void> removeStatusChangeListener() async {
    final replicator =
        _initialSyncComplete ? _pushPullReplicator : _pullReplicator;
    final token = statusChangedToken;
    if (replicator != null && token != null && !replicator.isClosed) {
      replicator.removeChangeListener(token);
    }
  }

  Future<void> removeDocumentReplicationListener() async {
    final replicator =
        _initialSyncComplete ? _pushPullReplicator : _pullReplicator;
    final token = documentReplicationToken;
    if (replicator != null && token != null && !replicator.isClosed) {
      replicator.removeChangeListener(token);
    }
  }
}
