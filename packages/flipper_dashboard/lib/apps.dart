import 'package:flutter/services.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_services/proxy.dart';
import 'widgets/dropdown.dart';
import 'customappbar.dart';
import 'widgets/mini_app_icon.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Apps extends StatefulWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final HomeViewModel model;

  String transactionPeriod = "Today";
  List<String> transactionPeriodOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year"
  ];

  String profitType = "Net Profit";
  List<String> profitTypeOptions = ["Net Profit", "Gross Profit"];
  Apps({
    Key? key,
    required final TextEditingController controller,
    required final bool isBigScreen,
    required final HomeViewModel model,
  })  : controller = controller,
        isBigScreen = isBigScreen,
        model = model,
        super(key: key);
  List<double> cashInAndOut = [1, 1];

  @override
  State<Apps> createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  final _routerService = locator<RouterService>();
  Widget _buildCustomPaintWithIcon(
      {dynamic iconData,
      required Color gradientColorOne,
      required Color gradientColorTwo,
      required String page}) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        switch (page) {
          case "keypad":
            _routerService.navigateTo(CheckOutRoute(
              isBigScreen: widget.isBigScreen,
            ));
            return;
          case "Cashbook":
            _routerService
                .navigateTo(CashbookRoute(isBigScreen: widget.isBigScreen));
            return;
          case "Settings":
            _routerService.navigateTo(SettingPageRoute());
            return;
          case "Support":
            final Uri whatsappUri = Uri.parse('https://wa.me/250788360058');
            if (await canLaunchUrl(whatsappUri)) {
              await launchUrl(whatsappUri,
                  mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $whatsappUri';
            }
            return;
          case "Connecta":
            ProxyService.box.write(key: 'defaultApp', value: 2);
            _routerService.navigateTo(SocialHomeViewRoute());
            return;
          case "Orders":
            // ProxyService.box.write(key: 'defaultApp', value: 2);
            // _routerService.navigateTo(SocialHomeViewRoute());
            return;
          case "Transactions":
            _routerService.navigateTo(TransactionsRoute());
            return;
          default:
            _routerService.navigateTo(CheckOutRoute(
              isBigScreen: widget.isBigScreen,
            ));
        }
      },
      child: Column(
        children: [
          MiniAppIcon(
              icon: iconData,
              gradientColorOne: gradientColorOne,
              page: page,
              showPageName: true,
              gradientColorTwo: gradientColorTwo),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        bottomSpacer: 48.99,
        closeButton: CLOSEBUTTON.WIDGET,
        customTrailingWidget: Container(
          child: FutureBuilder<ITenant?>(
              future: ProxyService.isar
                  .getTenantBYUserId(userId: ProxyService.box.getUserId()!),
              builder: (a, snapshoot) {
                if (snapshoot.connectionState == ConnectionState.waiting ||
                    !snapshoot.hasData) {
                  return const SizedBox.shrink();
                }
                final data = snapshoot.data;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: ProfileWidget(
                        tenant: data!,
                        size: 25,
                        showIcon: false,
                      )),
                );
              }),
        ),
        customLeadingWidget: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset(
              'assets/logo.png',
              package: 'flipper_dashboard',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 30, right: 0),
              leading: ReusableDropdown(
                options: widget.transactionPeriodOptions,
                selectedOption: widget.transactionPeriod,
                onChanged: (String? newPeriod) {
                  setState(() {
                    widget.transactionPeriod = newPeriod!;
                  });
                },
              ),
              trailing: ReusableDropdown(
                options: widget.profitTypeOptions,
                selectedOption: widget.profitType,
                onChanged: (String? newProfitType) {
                  setState(() {
                    widget.profitType = newProfitType!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: _buildGauge(context, widget.model),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: SizedBox(
                height: 340,
                width: 340,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 1,
                  padding: EdgeInsets.zero,
                  children: [
                    _buildCustomPaintWithIcon(
                        iconData: "path",
                        gradientColorOne: Color(0xFF006AFE),
                        gradientColorTwo: Colors.blue,
                        page: "POS"),
                    _buildCustomPaintWithIcon(
                        iconData: FluentIcons.wallet_20_regular,
                        gradientColorOne: Color(0xFF66AAFF),
                        gradientColorTwo: Colors.lightBlue,
                        page: "Cashbook"),
                    _buildCustomPaintWithIcon(
                        iconData: FluentIcons.arrow_swap_24_filled,
                        gradientColorOne: Color(0xFFFF0331),
                        gradientColorTwo: Colors.purpleAccent,
                        page: "Transactions"),
                    _buildCustomPaintWithIcon(
                        iconData: FluentIcons.communication_20_regular,
                        gradientColorOne: Colors.cyan,
                        gradientColorTwo: Colors.lightBlue,
                        page: "Connecta"),
                    _buildCustomPaintWithIcon(
                        iconData: FluentIcons.settings_20_regular,
                        gradientColorOne: Color(0xFFCC0F03),
                        gradientColorTwo: Colors.deepOrange,
                        page: "Settings"),
                    _buildCustomPaintWithIcon(
                        iconData: FluentIcons.call_20_regular,
                        gradientColorOne: Color(0xFF01B8E4),
                        gradientColorTwo: Colors.blue,
                        page: "Support"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGauge(BuildContext context, HomeViewModel model) {
    return StreamBuilder<List<Transaction>>(
      initialData: null,
      stream: ProxyService.isar.getCompletedTransactions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SemiCircleGauge(
            dataOnGreenSide: 0,
            dataOnRedSide: 0,
            startPadding: 0,
            profitType: widget.profitType,
          );
        } else {
          final transactions = snapshot.data!;
          DateTime oldDate;
          DateTime temporaryDate;

          if (widget.transactionPeriod == 'Today') {
            DateTime tempToday = DateTime.now();
            oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
          } else if (widget.transactionPeriod == 'This Week') {
            oldDate = DateTime.now().subtract(Duration(days: 7));
            oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
          } else if (widget.transactionPeriod == 'This Month') {
            oldDate = DateTime.now().subtract(Duration(days: 30));
            oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
          } else {
            oldDate = DateTime.now().subtract(Duration(days: 365));
            oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
          }

          List<Transaction> filteredTransactions = [];
          for (final transaction in transactions) {
            temporaryDate = DateTime.parse(transaction.createdAt);
            if (temporaryDate.isAfter(oldDate)) {
              filteredTransactions.add(transaction);
            }
          }

          double sum_cash_in = 0;
          double sum_cash_out = 0;
          for (final transaction in filteredTransactions) {
            if (transaction.transactionType == 'Cash Out') {
              sum_cash_out = transaction.subTotal + sum_cash_out;
            } else {
              sum_cash_in = transaction.subTotal + sum_cash_in;
            }
          }
          return SemiCircleGauge(
            dataOnGreenSide: sum_cash_in,
            dataOnRedSide: sum_cash_out,
            startPadding: 0,
            profitType: widget.profitType,
          );
        }
      },
    );
  }

  Widget PeriodDropDown() {
    return DropdownButton<String>(
      value: widget.transactionPeriod,
      items: widget.transactionPeriodOptions
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? newPeriod) {
        setState(() {
          widget.transactionPeriod = newPeriod!;
        });
      },
    );
  }
}
