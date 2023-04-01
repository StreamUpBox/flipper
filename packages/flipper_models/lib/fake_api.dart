import 'dart:convert';

import 'package:flipper_services/proxy.dart';

import 'data.loads/jcounter.dart';
import 'isar_api.dart';
import 'isar_models.dart';
import 'package:http/http.dart' as http;

class FakeApi extends IsarAPI implements IsarApiInterface {
  @override
  Future<List<JTenant>> signup({required Map business}) async {
    // Simulating a successful API response
    final http.Response response = http.Response(
        '[{"id": 1, "name": "Tenant 1", "businessId": 1642645, "nfcEnabled": true, "email": "tenant1@example.com", "phoneNumber": "${business['phoneNumber']}", "permissions":[{"id": 205, "name":"admin"}], "branches":[{"id": 232,"active": true,"channels": null,"description": "desc","name": "Test001","businessId": 1642645,"longitude": "0","latitude": "0","table": "branches","createdAt": "2/22/2021","updatedAt": null,"isDefault": true,"tenants": [],"default": true}], "businesses":[{"id": 1642645,"name": "Test001","currency": null,"categoryId": null,"latitude": "293.98","longitude": "-344.49","userId": "1651165831880765","typeId": null,"timeZone": null,"channels": null,"table": null,"country": "Rwanda","businessUrl": null,"hexColor": null,"imageUrl": null,"type": "business","referredBy": "Richie","createdAt": "2/22/2021","updatedAt": null,"metadata": null,"role": null,"lastSeen": 0,"firstName": null,"lastName": null,"reported": null,"phoneNumber": "+250783054873","deviceToken": null,"chatUid": null,"backUpEnabled": false,"subscriptionPlan": null,"nextBillingDate": null,"previousBillingDate": null,"isLastSubscriptionPaymentSucceeded": false,"backupFileId": null,"email": null,"lastDbBackup": null,"fullName": "Richie","referralCode": null,"authId": null,"tinNumber": 12222,"dvcSrlNo": "warvsdcoriongatetest","bhfId": "00","adrs": null,"taxEnabled": false,"isDefault": true,"default": true,"lastSubscriptionPaymentSucceeded": false}]}]',
        200);

    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        // Simulating a successful write transaction to a local database
        await isar.writeTxn(() async {
          return isar.business.putAll(jTenant.businesses);
        });
        await isar.writeTxn(() async {
          return await isar.branchs.putAll(jTenant.branches);
        });
        await isar.writeTxn(() async {
          return isar.permissions.putAll(jTenant.permissions);
        });
        await isar.writeTxn(() async {
          return isar.iTenants.put(iTenant);
        });
      }
      return jListTenantFromJson(response.body);
    } else {
      // Simulating an internal server error
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<Business> getOnlineBusiness({required String userId}) async {
    // Fake response with the provided data
    final response = http.Response(
      '{ "id": 1642645, "name": "Test001", "currency": null, "categoryId": null, "latitude": "293.98", "longitude": "-344.49", "userId": "1651165831880765", "typeId": null, "timeZone": null, "channels": null, "table": null, "country": "Rwanda", "businessUrl": null, "hexColor": null, "imageUrl": null, "type": "business", "referredBy": "Richie", "createdAt": "2/22/2021", "updatedAt": null, "metadata": null, "role": null, "lastSeen": 0, "firstName": null, "lastName": null, "reported": "true", "phoneNumber": "+250783054873", "deviceToken": null, "chatUid": null, "backUpEnabled": false, "subscriptionPlan": null, "nextBillingDate": null, "previousBillingDate": null, "isLastSubscriptionPaymentSucceeded": false, "backupFileId": null, "email": null, "lastDbBackup": null, "fullName": "Richie", "referralCode": null, "authId": null, "tinNumber": 12222, "dvcSrlNo": "warvsdcoriongatetest", "bhfId": "00", "adrs": null, "taxEnabled": false, "isDefault": true, "default": true, "lastSubscriptionPaymentSucceeded": false }',
      200,
    );

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw NotFoundException(term: "Business not found");
    }

    // Parse the response body and create a Business object
    final business = fromJson(response.body);

    await isar.writeTxn(() async {
      // Put the business object in the database
      return isar.business.put(business);
    });

    // Get the business object from the database
    final savedBusiness = await isar.writeTxn(() {
      return isar.business.filter().userIdEqualTo(userId).findFirst();
    });

    ProxyService.box.write(key: 'businessId', value: savedBusiness!.id);

    return savedBusiness;
  }

  @override
  Future<SyncF> login({required String userPhone}) async {
    final jsonResponse = {
      "id": 1651165831880765,
      "phoneNumber": "+250783054874",
      "token": "Bearer ",
      "tenants": [
        {
          "id": 49,
          "name": "Richard",
          "phoneNumber": "+250783054874",
          "email": "nyiringabohubert@gmail.com",
          "permissions": [
            {"id": 49, "name": "admin"}
          ],
          "branches": [
            {
              "id": 76,
              "active": true,
              "channels": null,
              "description": "desc",
              "name": "Richard",
              "businessId": 68,
              "longitude": "0",
              "latitude": "0",
              "table": "branches",
              "createdAt": "2021-10-05T19:28:08.612022",
              "updatedAt": null,
              "isDefault": false,
              "tenants": [],
              "default": false
            }
          ],
          "businesses": [
            {
              "id": 1642645,
              "name": "FakeBusiness",
              "currency": "USD",
              "categoryId": null,
              "latitude": "1",
              "longitude": "1",
              "userId": "1651165831880765",
              "typeId": null,
              "timeZone": null,
              "channels": null,
              "table": null,
              "country": "United States",
              "businessUrl": null,
              "hexColor": null,
              "imageUrl": null,
              "type": "Business",
              "referredBy": "Organic",
              "createdAt": "2022-03-30T00:00:00.000Z",
              "updatedAt": null,
              "metadata": null,
              "role": null,
              "lastSeen": 0,
              "firstName": null,
              "lastName": null,
              "reported": "true",
              "phoneNumber": "+1234567890",
              "deviceToken": null,
              "chatUid": null,
              "backUpEnabled": false,
              "subscriptionPlan": null,
              "nextBillingDate": null,
              "previousBillingDate": null,
              "isLastSubscriptionPaymentSucceeded": false,
              "backupFileId": null,
              "email": "fake@business.com",
              "lastDbBackup": null,
              "fullName": "Fake Business",
              "referralCode": null,
              "authId": null,
              "tinNumber": 123456,
              "dvcSrlNo": null,
              "bhfId": null,
              "adrs": null,
              "taxEnabled": false,
              "isDefault": true,
              "default": true,
              "lastSubscriptionPaymentSucceeded": false
            }
          ],
          "businessId": 0,
          "nfcEnabled": false
        }
      ],
      "channels": ["1651165831880765"],
      "points": 0,
      "editId": false,
      "newId": 0
    };
    final response = http.Response(jsonEncode(jsonResponse), 200);
    if (response.statusCode == 200) {
      await ProxyService.box.write(
        key: 'bearerToken',
        value: syncFFromJson(response.body).token,
      );
      await ProxyService.box.write(
        key: 'userId',
        value: syncFFromJson(response.body).id.toString(),
      );
      await ProxyService.box.write(
        key: 'userPhone',
        value: "+250783054874",
      );
      if (syncFFromJson(response.body).tenants.isEmpty) {
        throw NotFoundException(term: "Not found");
      }
      await isar.writeTxn(() async {
        return isar.business
            .putAll(syncFFromJson(response.body).tenants.first.businesses);
      });
      await isar.writeTxn(() async {
        return isar.branchs
            .putAll(syncFFromJson(response.body).tenants.first.branches);
      });

      return syncFFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      throw Exception('403 Error');
    }
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    // Create a fake response JSON
    final responseJson = [
      {
        "id": 1,
        "name": "FakeTenant",
        "phoneNumber": "+1234567890",
        "email": "fake@tenant.com",
        "permissions": [
          {"id": 1, "name": "admin"}
        ],
        "branches": [
          {
            "id": 232,
            "active": true,
            "channels": null,
            "description": "Fake branch",
            "name": "FakeBranch",
            "businessId": 1642645,
            "longitude": "0",
            "latitude": "0",
            "table": "branches",
            "createdAt": "2022-03-30T00:00:00.000Z",
            "updatedAt": null,
            "isDefault": true,
            "tenants": [],
            "default": true
          }
        ],
        "businesses": [
          {
            "id": 1642645,
            "name": "FakeBusiness",
            "currency": "USD",
            "categoryId": null,
            "latitude": "1",
            "longitude": "1",
            "userId": "1651165831880765",
            "typeId": null,
            "timeZone": null,
            "channels": null,
            "table": null,
            "country": "United States",
            "businessUrl": null,
            "hexColor": null,
            "imageUrl": null,
            "type": "Business",
            "referredBy": "Organic",
            "createdAt": "2022-03-30T00:00:00.000Z",
            "updatedAt": null,
            "metadata": null,
            "role": null,
            "lastSeen": 0,
            "firstName": null,
            "lastName": null,
            "reported": "true",
            "phoneNumber": "+1234567890",
            "deviceToken": null,
            "chatUid": null,
            "backUpEnabled": false,
            "subscriptionPlan": null,
            "nextBillingDate": null,
            "previousBillingDate": null,
            "isLastSubscriptionPaymentSucceeded": false,
            "backupFileId": null,
            "email": "fake@business.com",
            "lastDbBackup": null,
            "fullName": "Fake Business",
            "referralCode": null,
            "authId": null,
            "tinNumber": 123456,
            "dvcSrlNo": null,
            "bhfId": null,
            "adrs": null,
            "taxEnabled": false,
            "isDefault": true,
            "default": true,
            "lastSubscriptionPaymentSucceeded": false
          }
        ],
        "businessId": 1,
        "nfcEnabled": false
      }
    ];
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        isar.writeTxn(() async {
          await isar.business.putAll(jTenant.businesses);
          await isar.branchs.putAll(jTenant.branches);
          await isar.permissions.putAll(jTenant.permissions);
        });
        isar.writeTxn(() async {
          await isar.iTenants.put(iTenant);
        });
      }
      return await isar.iTenants
          .filter()
          .businessIdEqualTo(businessId)
          .findAll();
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<void> loadCounterFromOnline({required int businessId}) async {
    final responseJson = [
      {
        "id": 11,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "NS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "id": 12,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "TS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "id": 13,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "NR",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "id": 14,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "CS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "id": 15,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "PS",
        "totRcptNo": 0,
        "curRcptNo": 0
      }
    ];
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      List<JCounter> counters = jCounterFromJson(response.body);
      for (JCounter jCounter in counters) {
        await isar.writeTxn(() async {
          return isar.counters.put(Counter()
            ..branchId = jCounter.branchId
            ..businessId = jCounter.businessId
            ..receiptType = jCounter.receiptType
            ..id = jCounter.id
            ..backed = true
            ..totRcptNo = jCounter.totRcptNo
            ..curRcptNo = jCounter.curRcptNo);
        });
      }
    } else {
      throw InternalServerError(term: "Error loading the counters");
    }
  }

  @override
  Future<T?> update<T>({required T data}) async {
    // int branchId = ProxyService.box.getBranchId()!;
    if (data is Product) {
      Product product = data;

      await isar.writeTxn(() async {
        return await isar.products.put(product);
      });
    }
    if (data is Variant) {
      Variant variant = data;
      await isar.writeTxn(() async {
        return await isar.variants.put(variant);
      });
    }
    if (data is Stock) {
      Stock stock = data;
      await isar.writeTxn(() async {
        return await isar.stocks.put(stock);
      });
    }
    if (data is Order) {
      final order = data;
      await isar.writeTxn(() async {
        return await isar.orders.put(order);
      });
    }
    if (data is Category) {
      final order = data;
      await isar.writeTxn(() async {
        return await isar.categorys.put(order);
      });
    }
    if (data is IUnit) {
      final unit = data;
      await isar.writeTxn(() async {
        return await isar.iUnits.put(unit);
      });
    }
    if (data is PColor) {
      final color = data;
      await isar.writeTxn(() async {
        return await isar.pColors.put(color);
      });
    }
    if (data is OrderItem) {
      await isar.writeTxn(() async {
        return await isar.orderItems.put(data);
      });
    }
    if (data is Ebm) {
      final ebm = data;
      await isar.writeTxn(() async {
        ProxyService.box.write(key: "serverUrl", value: ebm.taxServerUrl);
        Business? business =
            await isar.business.where().userIdEqualTo(ebm.userId).findFirst();
        business
          ?..dvcSrlNo = ebm.dvcSrlNo
          ..tinNumber = ebm.tinNumber
          ..bhfId = ebm.bhfId
          ..taxServerUrl = ebm.taxServerUrl
          ..taxEnabled = true;
        return await isar.business.put(business!);
      });
    }
    if (data is Token) {
      final token = data;
      await isar.writeTxn(() async {
        Token? ttoken =
            await isar.tokens.where().userIdEqualTo(token.userId).findFirst();
        if (ttoken == null) {
          ttoken = Token()
            ..token = token.token
            ..userId = token.userId
            ..type = token.type;
          return await isar.tokens.put(ttoken);
        } else {
          ttoken
            ..token = token.token
            ..userId = token.userId
            ..type = token.type;
          return await isar.tokens.put(ttoken);
        }
      });
    }
    if (data is Business) {
      final business = data;
      await isar.writeTxn(() async {
        return await isar.business.put(business);
      });
    }
    if (data is Branch) {
      isar.writeTxn(() async {
        return await isar.branchs.put(data);
      });
    }
    if (data is Counter) {
      await isar.writeTxn(() async {
        return isar.counters.put(data..backed = false);
      });
    }
    if (data is Branch) {
      isar.writeTxn(() async {
        return await isar.branchs.put(data);
      });
    }
    if (data is Drawers) {
      final drawer = data;
      await isar.writeTxn(() async {
        return await isar.drawers.put(drawer);
      });
    }
    if (data is ITenant) {
      return null;
    }
    return null;
  }

  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": 1, "typeName": "Customer Support"},
      {"id": 2, "typeName": "Supplier"},
      {"id": 3, "typeName": "Retailer"},
      {"id": 4, "typeName": "Agent"}
    ];
    Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }
}
