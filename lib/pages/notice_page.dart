import 'package:bmi_calculator/modules/notice_module.dart';
import 'package:bmi_calculator/notice_init/notice_init.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<NoticeModule> listNotice = noticeInit();
    return Scaffold(
      appBar: AppBar(

      ),body:  ListView.builder(
        cacheExtent: 3000,
        itemCount: listNotice.length,
        itemBuilder: (context, index) {
          return NoticeCard(header: listNotice[index].header, body: listNotice[index].body);
        },),
    );
  }
}

class NoticeCard extends StatefulWidget {
  const NoticeCard({
    super.key,
    required this.header,
    required this.body
});

  final String header;
  final String body;

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  bool _isExpand = false;

  void _onTap(){
    setState(() {
      _isExpand = !_isExpand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _BoxWidget(child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: _onTap,
            child: Row(
              children: [
                 Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.header,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _RotateIcon(isRotate: _isExpand,),
                ),
              ],
            ),
          ),
        ),
        if(_isExpand)  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.body),
        )
      ],
    ));
  }
}

class _RotateIcon extends StatefulWidget {
  const _RotateIcon({required this.isRotate});
  final bool isRotate;

  @override
  State<_RotateIcon> createState() => _RotateIconState();
}

class _RotateIconState extends State<_RotateIcon> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late double _rolate;
  


  @override
  void initState() {
    super.initState();
    double begin = widget.isRotate?math.pi:0;
    _rolate = begin;
    _animationController = AnimationController(vsync: this,
    duration: const Duration(milliseconds: 250));
    
  }

  @override
  void didUpdateWidget(_RotateIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.isRotate != widget.isRotate){
      animation();
    }
  }

  void animation(){
    double begin = !widget.isRotate?math.pi:0;
    double end = !widget.isRotate?0:math.pi;
    final tween = Tween<double>(begin: begin,end:end).animate(_animationController);
    tween.addListener(() {
      setState(() {
        _rolate = tween.value;
      });
     });
    _animationController..reset()..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle:_rolate,
      child: const Icon(Icons.expand_circle_down_outlined));
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