import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/model/timer_model.dart';
import 'package:timer_app/utils/colors.dart';
import 'common_widget/screen_util_wrapper.dart';
import 'common_widget/text_feilds.dart';
import 'service/timer_provider.dart';
import 'utils/constants.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TextEditingController minuteController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  bool autovalidation = false;
  final formGlobalKey = GlobalKey<FormState>();
  bool _isAddButtonEnabled = false;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _minutefocusNode = FocusNode();
  Color? fillTextFieldColor;
  bool isReadOnlyField = false;

  bool _isTimerRunning = false;
  Timer? _timer;

  void startStopTimer(int minutes, int seconds) {
    if (_isTimerRunning) {
      _timer?.cancel();
      _isTimerRunning = false;
      _isAddButtonEnabled = false;
      fillTextFieldColor = yellowColor;
      _timer = null;
      setState(() {});
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (minutes == 0 && seconds == 0) {
            fillTextFieldColor = white;
            _isAddButtonEnabled = false;
            _isTimerRunning = false;
            timer.cancel();
            // minuteController.text = "00";
            // secondController.text = "00";
            minuteController.clear();
            secondController.clear();
            isReadOnlyField = false;
            _timer = null;
            Provider.of<TimerProvider>(context, listen: false)
                .removeAllTimerItems();
          } else if (seconds == 0) {
            minutes--;
            minuteController.text = minutes.toString();
            setState(() {});
            seconds = 59;
          } else {
            seconds--;
            secondController.text = seconds.toString();
            if (minutes == 0 && seconds < 30) {
              fillTextFieldColor = redColor;
            } else {
              fillTextFieldColor = greenColor;
            }

            setState(() {});
          }
        });
      });
      setState(() {
        _isTimerRunning = true;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      minuteController.text = "00";
      secondController.text = "00";
      Provider.of<TimerProvider>(context, listen: false).removeAllTimerItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Timer App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtilWrapper.setResponsiveSize(20),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: BorderTextFeild(
                        controller: minuteController,
                        focusNode: _minutefocusNode,
                        readonly: isReadOnlyField,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return StringConst.plsEnterMinutes;
                          } else if (int.parse(value) > 59) {
                            return StringConst.validMinutes;
                          } else {
                            return null;
                          }
                        },
                        fillColor: fillTextFieldColor,
                        labelText: StringConst.minutes,
                        autovalidateMode: autovalidation
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          LengthLimitingTextInputFormatter(2),
                        ]),
                  ),
                  SizedBox(
                    width: ScreenUtilWrapper.setResponsiveSize(30),
                  ),
                  Expanded(
                    flex: 1,
                    child: BorderTextFeild(
                      controller: secondController,
                      focusNode: _focusNode,
                      fillColor: fillTextFieldColor,
                      readonly: isReadOnlyField,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return StringConst.plsEnterSeconds;
                        } else if (int.parse(value) > 59) {
                          return StringConst.validSeconds;
                        } else {
                          return null;
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        LengthLimitingTextInputFormatter(2),
                      ],
                      labelText: StringConst.seconds,
                      autovalidateMode: autovalidation
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtilWrapper.setResponsiveSize(40),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.blue,
                          ),
                        ),
                        onPressed: _isAddButtonEnabled
                            ? () {
                                if (formGlobalKey.currentState!.validate()) {
                                  autovalidation = true;
                                  _focusNode.unfocus();
                                  _minutefocusNode.unfocus();
                                  TimerModel timerModel = TimerModel(
                                      id: DateTime.now().toString(),
                                      minutes: int.parse(minuteController.text),
                                      seconds: int.parse(
                                          secondController.text.toString()));
                                  Provider.of<TimerProvider>(context,
                                          listen: false)
                                      .addTimerItems(timerModel);
                                }
                              }
                            : null,
                        child: const Text(
                          StringConst.add,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtilWrapper.setResponsiveSize(15),
              ),
              Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      if (formGlobalKey.currentState!.validate()) {
                        autovalidation = true;
                        _isAddButtonEnabled = true;
                        isReadOnlyField = true;
                        _focusNode.unfocus();

                        setState(() {});
                        startStopTimer(int.parse(minuteController.text),
                            int.parse(secondController.text));
                      }
                    },
                    child: Text(
                      _isAddButtonEnabled
                          ? StringConst.stop
                          : StringConst.start,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )),
              ),
              SizedBox(
                height: ScreenUtilWrapper.setResponsiveSize(20),
              ),
              Expanded(
                child: Consumer<TimerProvider>(
                    builder: (context, provider, child) {
                  if (provider.timerList.isEmpty) {
                    return Container();
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.timerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                'Minutes :${provider.timerList[index].minutes.toString()}  Seconds :${provider.timerList[index].seconds.toString()}'),
                          );
                        });
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
