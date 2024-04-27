import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry_calculator/widget/group_widget.dart';
import 'package:hungry_calculator/widget/phone_widget.dart';
import 'package:hungry_calculator/widget/receipt_widget.dart';

import '../widget/confirm_receipts_widget.dart';
import '../widget/split_widget.dart';

class StepperPage extends StatefulWidget {
  final String event;
  const StepperPage({Key? key, required this.event}) : super(key: key);

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  List<String> groups = [];
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> items_cop = [];
  Map<String, List<Map<String, dynamic>>> receipts = {};

  int activeStep = 0;
  int reachedStep = 0;
  int upperBound = 4;
  Set<int> reachedSteps = <int>{0, 1, 2, 3, 4};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              steps(),
              const SizedBox(height: 40),
              content(),
            ],
          ),
        ),
      ),
    );
  }

  Widget steps() {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 1, child: _previousStep(StepEnabling.sequential)),
          Expanded(
            flex: 15,
            child: EasyStepper(
              activeStep: activeStep,
              maxReachedStep: reachedStep,
              lineStyle: LineStyle(
                lineLength: 100,
                lineSpace: 4,
                lineType: LineType.normal,
                unreachedLineColor: Colors.grey.withOpacity(0.5),
                finishedLineColor: const Color.fromRGBO(46, 46, 229, 100),
                activeLineColor: Colors.grey.withOpacity(0.5),
              ),
              activeStepBorderColor: const Color.fromRGBO(46, 46, 229, 100),
              activeStepIconColor: const Color.fromRGBO(46, 46, 229, 100),
              activeStepTextColor: const Color.fromRGBO(46, 46, 229, 100),
              activeStepBackgroundColor: Colors.white,
              unreachedStepBackgroundColor: Colors.grey.withOpacity(0.5),
              unreachedStepBorderColor: Colors.grey.withOpacity(0.5),
              unreachedStepIconColor: Colors.grey,
              unreachedStepTextColor: Colors.grey.withOpacity(0.5),
              finishedStepBackgroundColor:
              const Color.fromRGBO(46, 46, 229, 100),
              finishedStepBorderColor: Colors.grey.withOpacity(0.5),
              finishedStepIconColor: Colors.white,
              finishedStepTextColor: const Color.fromRGBO(46, 46, 229, 100),
              borderThickness: 10,
              internalPadding: 15,
              showLoadingAnimation: false,
              steps: [
                EasyStep(
                  icon: const Icon(CupertinoIcons.group),
                  title: 'Группа',
                  lineText: 'Создание группы',
                  enabled: _allowTabStepping(0, StepEnabling.sequential),
                ),
                EasyStep(
                  icon: const Icon(Icons.document_scanner),
                  title: 'Чек',
                  lineText: 'Заполнение позиций',
                  enabled: _allowTabStepping(1, StepEnabling.sequential),
                ),
                EasyStep(
                  icon:
                  const Icon(CupertinoIcons.arrow_down_right_arrow_up_left),
                  title: 'Счёт',
                  lineText: 'Разделение счёта',
                  enabled: _allowTabStepping(2, StepEnabling.sequential),
                ),
                EasyStep(
                  icon: const Icon(CupertinoIcons.money_rubl),
                  title: 'К оплате',
                  lineText: 'Калькулятор чеков',
                  enabled: _allowTabStepping(3, StepEnabling.sequential),
                ),
                EasyStep(
                  icon: const Icon(CupertinoIcons.bag_fill),
                  title: 'Создание группы',
                  enabled: _allowTabStepping(4, StepEnabling.sequential),
                ),
              ],
              onStepReached: (index) =>
                  setState(() {
                    activeStep = index;
                  }),
            ),
          ),
          Expanded(flex: 1, child: _nextStep(StepEnabling.sequential)),
        ],
      ),
    );
  }

  bool _allowTabStepping(int index, StepEnabling enabling) {
    return enabling == StepEnabling.sequential
        ? index <= reachedStep
        : reachedSteps.contains(index);
  }

  Widget _nextStep(StepEnabling enabling) {
    return IconButton(
      onPressed: () {
        if (activeStep < upperBound) {
          setState(() {
            if (enabling == StepEnabling.sequential) {
              ++activeStep;
              if (reachedStep < activeStep) {
                reachedStep = activeStep;
              }
            } else {
              activeStep =
                  reachedSteps.firstWhere((element) => element > activeStep);
            }
          });
        }
      },
      icon: const Icon(Icons.arrow_forward_ios),
    );
  }

  /// Returns the previous button.
  Widget _previousStep(StepEnabling enabling) {
    return IconButton(
      onPressed: () {
        if (activeStep > 0) {
          setState(() =>
          enabling == StepEnabling.sequential
              ? --activeStep
              : activeStep =
              reachedSteps.lastWhere((element) => element < activeStep));
        }
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  Widget content() {
    if (activeStep == 0) {
      return group();
    }

    if (activeStep == 1) {
      return receipt();
    }

    if (activeStep == 2) {
      return splitReceipt();
    }

    if (activeStep == 3) {
      return guestReceipts();
    }

    if (activeStep == 4) {
      return phoneAndSend();
    }

    return Container();
  }

  Widget group() {
    return SizedBox(width: 400, height: 500, child: GroupWidget(groups: groups));
  }

  Widget receipt() {
    return SizedBox(width: 400, height: 500, child: ReceiptScannerWidget(items: items, cop: items_cop));
  }

  Widget splitReceipt() {
    return SizedBox(width: 400, height: 500, child: GuestSelectionWidget(items: items, groups: groups, receipts: receipts,));
  }

  Widget guestReceipts() {
    return SizedBox(width: 400, height: 500, child: GuestSummaryWidget(receipts: receipts));
  }

  Widget phoneAndSend(){
    return SizedBox(width: 400, height: 500, child: PhoneWidget(receipts: receipts, items: items_cop, event: widget.event));
  }
}

enum StepEnabling { sequential }