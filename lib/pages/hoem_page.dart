import 'package:bmi_calculator/calculator/bmi_calculator.dart';
import 'package:bmi_calculator/modules/suggetion_module.dart';
import 'package:bmi_calculator/pages/notice_page.dart';


import './/constants/string_constant.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  double _bmi = 0.0;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late ScrollController _scrollController;
  late AnimationController _animationController;
  double  _scrollOffset = 0.0;
  SuggetionModule? _seggetion;
  String? _weightSuggetion;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _scrollController = ScrollController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset =_scrollController.offset;
      });
      
    });
  }

  void _animateWidget() {
    final Animation<double> curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    final tween =
        Tween<double>(begin: _scrollController.offset, end: 0.0).animate(curve);
    tween.addListener(() {
      setState(() {
        _scrollController.jumpTo(tween.value);
      });
    });

    _animationController
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {

    _animateWidget();

    if (_weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        _bmi = bmiCalculator(
            weight: double.parse(_weightController.text),
            height: double.parse(_heightController.text));
        _seggetion = getSuggetion(_bmi);
        _weightSuggetion = getWeightSuggetion(
            weight: double.parse(_weightController.text),
            height: double.parse(_heightController.text));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstant.appName),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NoticePage()));
              }, 
              icon: const Icon(Icons.announcement_outlined)),
          )
        ],
      ),
      body: Column(
        children: [
          if(_scrollOffset == 0.0)_Field(
            controller: _weightController,
            label: StringConstant.weightLabel,
          ),
          if(_scrollOffset == 0.0)_Field(
            controller: _heightController,
            label: StringConstant.heightLabel,
          ),
          CalcalatorButton(
            onTap: _onTap,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  BoxBMI(
                    bmi: _bmi,
                  ),
                  if (_weightSuggetion != null)
                    _BoxWidget(
                        haveBorder: false,
                        child: Center(
                          child: Text(_weightSuggetion!),
                        )),
                  if (_seggetion != null) BoxSuggetion(suggetion: _seggetion!)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _BoxWidget(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: TextField(
          focusNode: FocusNode(canRequestFocus: false),
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.center,
          onChanged: (String text) {
            if (text.isNotEmpty) {
              if (text.startsWith(RegExp(r'[^1-9]'))) {
                controller.text = "";
                controller.selection =
                    const TextSelection(baseOffset: 0, extentOffset: 0);
              } else {
                String newText = text.replaceAllMapped(
                    RegExp(r'(^\d{1,3}(?:\.\d{0,2})?).*'),
                    (match) => "${match[1]}");
                controller.text = newText;
                controller.selection = TextSelection(
                    baseOffset: newText.length, extentOffset: newText.length);
              }
            }
          },
          onEditingComplete: () {
            if (controller.text.isNotEmpty) {
              controller.text =
                  double.parse(controller.text).toStringAsFixed(2);
            }
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }
}

class _BoxWidget extends StatelessWidget {
  const _BoxWidget(
      {required this.child,
      this.color = Colors.white,
      this.evalution = 2.0,
      this.haveBorder = true});

  final Widget child;
  final Color color;
  final double evalution;
  final bool haveBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Container(
        decoration: !haveBorder
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: evalution,
                        spreadRadius: 0.5,
                        blurStyle: BlurStyle.outer)
                  ]),
        child: child,
      ),
    );
  }
}

class CalcalatorButton extends StatelessWidget {
  const CalcalatorButton({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _BoxWidget(
        color: Colors.orange,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(2),
          // color: Colors.orange,
          child: InkWell(
            borderRadius: BorderRadius.circular(2),
            highlightColor: Colors.red,
            onTap: onTap,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  StringConstant.calculatorButton,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
              ),
            ),
          ),
        ));
  }
}

class BoxBMI extends StatefulWidget {
  const BoxBMI({super.key, required this.bmi});

  final double bmi;

  @override
  State<BoxBMI> createState() => _BoxBMIState();
}

class _BoxBMIState extends State<BoxBMI> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double _bmi = 0.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
  }

  @override
  void didUpdateWidget(BoxBMI oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bmi != widget.bmi) {
      animateWidget(oldWidget.bmi, widget.bmi);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void animateWidget(double oldWidget, double newWidget) {
    final Animation<double> curve =
        CurvedAnimation(parent: animationController, curve: Curves.elasticOut);
    final tween =
        Tween<double>(begin: oldWidget, end: newWidget).animate(curve);
    tween.addListener(() {
      setState(() {
        _bmi = tween.value;
      });
    });

    animationController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: _BoxWidget(
          haveBorder: false,
          evalution: 0.0,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  StringConstant.bmiLabel,
                  style: const TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _bmi.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 40),
                )
              ],
            ),
          )),
    );
  }
}

class BoxSuggetion extends StatelessWidget {
  const BoxSuggetion({super.key, required this.suggetion});

  final SuggetionModule suggetion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: _BoxWidget(
          color: Colors.grey.shade200,
          haveBorder: true,
          evalution: 1.0,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    suggetion.header,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    suggetion.body,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

