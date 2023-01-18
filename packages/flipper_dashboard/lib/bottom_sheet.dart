import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_ui/bottom_sheets/general_bottom_sheet.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import 'package:flipper_login/update_email.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';

Widget header({required String title, required BuildContext context}) {
  return Material(
    child: Container(
      child: ListTile(
        leading: const Icon(Icons.arrow_back_ios),
        title: Text(title),
        onTap: () {
          Navigator.maybePop(context);
        },
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
    ),
  );
}

Widget trailingWidget(bool checked) {
  return (checked)
      ? const Icon(Icons.check, color: Colors.blue)
      : const Icon(null);
}

void inviteMembers({required BuildContext context}) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        List<Widget> widgets = [];
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: Row(children: const [Text('Invite')]),
                  trailing: const Text('Send Request'),
                ),
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView.builder(
                      itemCount: widgets.length,
                      itemBuilder: (context, index) {
                        return widgets[index];
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
      });
}

void preferences(
    {required BuildContext context, required BusinessHomeViewModel model}) {
  bottomSheetBuilder(
    header: header(title: 'Preferences', context: context),
    context: context,
    body: Column(children: [
      if (ProxyService.remoteConfig.isAccessiblityFeatureAvailable())
        const ListTile(
          leading: Icon(Ionicons.search),
          title: Text('Accessibility'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ListTile(
        leading: const Icon(Ionicons.language),
        title: const Text('Language'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          bottomSheetBuilder(
            context: context,
            header: header(title: 'Language', context: context),
            body: ViewModelBuilder<SettingViewModel>.reactive(
              viewModelBuilder: () => SettingViewModel(),
              onModelReady: (model) {
                model.getSetting();
              },
              builder: (context, model, child) {
                return Column(
                  children: [
                    SettingsTile(
                      title: "English",
                      trailing: trailingWidget(model.defaultLanguage == 'en'),
                      onPressed: (BuildContext context) {
                        model.setLanguage('en');
                        model.updateSettings(map: {'defaultLanguage': 'en'});
                      },
                    ),
                    SettingsTile(
                      title: "Ikinyarwanda",
                      trailing: trailingWidget(model.defaultLanguage == 'fr'),
                      onPressed: (BuildContext context) {
                        model.setLanguage('fr');
                        model.updateSettings(map: {'defaultLanguage': 'fr'});
                      },
                    ),
                    SettingsTile(
                      title: "Swahili",
                      trailing: trailingWidget(model.defaultLanguage == 'sw'),
                      onPressed: (BuildContext context) {
                        model.setLanguage('sw');
                        model.updateSettings(map: {'defaultLanguage': 'sw'});
                      },
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Ionicons.keypad),
        title: const Text('Reports'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          bottomSheetBuilder(
            header: header(title: 'Reports', context: context),
            context: context,
            body: ViewModelBuilder<SettingViewModel>.reactive(
              viewModelBuilder: () => SettingViewModel(),
              onModelReady: (model) {
                model.getSetting();
                //start with status of the setting.
                model.kSetting.getEnableReportToggleState();
              },
              builder: (context, model, child) {
                return Column(
                  children: [
                    SettingsTile.switchTile(
                      title: 'Enable Report',
                      switchValue: model.kSetting.sendDailReport,
                      onToggle: (bool value) {
                        model.enableDailyReport((message) {
                          if (message == 1) {
                            showSimpleNotification(
                              const Text('Added email is not gmail'),
                              background: Colors.red,
                              position: NotificationPosition.bottom,
                            );
                          }
                          if (message == 2) {
                            // You need to add email first
                            bottomSheetBuilder(
                              context: context,
                              body: UpdateEmailSetting(),
                              header:
                                  header(title: 'Add Email', context: context),
                            );
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
      if (ProxyService.remoteConfig.isBackupAvailable())
        ListTile(
          leading: const Icon(Ionicons.sync),
          title: const Text('BackUps'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            bottomSheetBuilder(
              context: context,
              header: header(title: 'Add Backup', context: context),
              body: Column(
                children: [
                  ListTile(
                    leading: const Icon(Ionicons.cloud_download),
                    title: const Text('Restore Data'),
                    trailing: const Icon(Ionicons.happy),
                    onTap: () {
                      model.restoreBackUp((callback) {
                        if (callback == 1) {
                          showSimpleNotification(
                            const Text('Data restored'),
                            background: Colors.green,
                            position: NotificationPosition.bottom,
                          );
                        }
                        if (callback == 2) {
                          showSimpleNotification(
                            const Text('Error Restoring backup'),
                            background: Colors.red,
                            position: NotificationPosition.bottom,
                          );
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Ionicons.cloud_upload),
                    title: const Text('Backup now'),
                    trailing: const Icon(Ionicons.file_tray),
                    onTap: () {
                      model.backUpNow((message) {
                        if (message == 1) {
                          showSimpleNotification(
                            const Text('Backup created'),
                            background: Colors.green,
                            position: NotificationPosition.bottom,
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      if (ProxyService.remoteConfig.isAnalyticFeatureAvailable())
        ListTile(
          leading: const Icon(Ionicons.analytics),
          title: const Text('Analytics'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            GoRouter.of(context).push(Routes.analytics);
          },
        ),
      if (ProxyService.remoteConfig.isSyncAvailable())
        ListTile(
          leading: const Icon(Ionicons.sync),
          title: const Text('Sync'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            bottomSheetBuilder(
              header: header(title: 'Sync', context: context),
              context: context,
              body: ViewModelBuilder<SettingViewModel>.reactive(
                viewModelBuilder: () => SettingViewModel(),
                onModelReady: (model) {},
                builder: (context, model, child) {
                  return Column(
                    children: [
                      SettingsTile.switchTile(
                        title: 'Enable Sync',
                        switchValue: model.getIsSyncSubscribed,
                        onToggle: (bool value) {},
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ListTile(
        leading: const Icon(
          Icons.center_focus_weak,
        ),
        title: const Text('QR Code'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          bottomSheetBuilder(
            header: header(title: 'Qr Mode', context: context),
            context: context,
            body: ViewModelBuilder<SettingViewModel>.reactive(
              viewModelBuilder: () => SettingViewModel(),
              onModelReady: (model) {
                model.getBusiness();
                model.kSetting.getEnableAttendanceToggleState();
              },
              builder: (context, model, child) {
                return Column(
                  children: [
                    SettingsTile.switchTile(
                      title: 'Enable Qr Mode',
                      switchValue: model.kSetting.isAttendanceEnabled,
                      onToggle: (bool value) {
                        model.enableAttendance((message) {
                          if (message == 1) {
                            showSimpleNotification(
                              const Text('Added email is not gmail'),
                              background: Colors.red,
                              position: NotificationPosition.bottom,
                            );
                          }
                          if (message == 2) {
                            // You need to add email first
                            bottomSheetBuilder(
                              context: context,
                              body: UpdateEmailSetting(),
                              header:
                                  header(title: 'Add Email', context: context),
                            );
                          }
                        });
                      },
                    ),
                    model.kSetting.isAttendanceEnabled
                        ? QrImageView(
                            data: model.business!.name! +
                                '-' +
                                model.business!.id.toString() +
                                '-' +
                                model.business!.userId.toString(),
                            version: QrVersions.auto,
                            size: 200.0,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          );
        },
      )
    ]),
  );
}

/// load the users within default branch being focused on!
/// at the top of the list add input field for adding new users using phone number
/// at the right of the input add + button to add new users,
/// when adding the user will submit to api to add tenant to this branch
/// once success a newly added tenant will be saved also locally for offline login
/// and a list of tenants of this branch will be loaded
/// only a tenant should be added only if does not exist.
/// invite(context: context);
void addMemberBottomSheet({
  required BuildContext context,
  required List<Widget> children,
}) {
  bottomSheetBuilder(
    header:
        header(title: FLocalization.of(context).addMembers, context: context),
    context: context,
    body: ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        /// I need to know when the list is clicked get the index
        /// pass it to add tenant func
        return Column(
          children: [
            // header
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: Row(children: const [Text('Invite')]),
              trailing: const Text('Send Request'),
            ),
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return children[index];
                  },
                ),
              ),
            )
          ],
        );
      },
    ),
  );
}

void addWorkSpace({required BuildContext context}) {
  bottomSheetBuilder(
    header:
        header(title: FLocalization.of(context).addWorkSpace, context: context),
    context: context,
    body: ViewModelBuilder<SettingViewModel>.reactive(
        viewModelBuilder: () => SettingViewModel(),
        builder: (context, model, child) {
          return Column(children: [
            if (ProxyService.remoteConfig.isAccessiblityFeatureAvailable())
              ListTile(
                leading: const Icon(Ionicons.language),
                title: const Text('Language'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ListTile(
              leading: const Icon(Ionicons.keypad),
              title: const Text('Enable report'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ]);
        }),
  );
}
