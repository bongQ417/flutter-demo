import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import 'dart:math' as math;

typedef PanelBuilder = Widget Function(BuildContext context, String number);

enum FlipClockMode { second, minute, hour }

class FlipSinglePanel extends StatefulWidget {
  final PanelBuilder panelBuilder;

  final FlipClockMode flipClockMode;

  final bool twentyFourHours;

  const FlipSinglePanel(
      {Key key,
      @required this.panelBuilder,
      @required this.flipClockMode,
      this.twentyFourHours = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FlipSinglePanelState();
  }
}

class _FlipSinglePanelState extends State<FlipSinglePanel>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation _animation;

  bool _running, _reverse;

  Timer _timer;

  DateTime _dateTime, _nextTime;

  String _currentValue, _nextValue;

  Widget _child1, _child2;
  Widget _upperChild1, _upperChild2;
  Widget _lowerChild1, _lowerChild2;

  @override
  void initState() {
    super.initState();
    // 初始化参数
    _reverse = false;
    _running = true;
    _dateTime = DateTime.now();
    _nextTime = _dateTime.add(Duration(seconds: 1));
    _currentValue = getPanelNumber(false);
    _nextValue = getPanelNumber(true);

    // 定义动画控制器
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    // 90度翻转
    _animation = Tween(begin: 0.0, end: math.pi / 2).animate(_controller)
      ..addStatusListener((status) {
        // 反转动画
        if (status == AnimationStatus.completed) {
          _reverse = true;
          _controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          _reverse = false;
        }
      })
      ..addListener(() {
        setState(() {});
      });

    // 定时1s刷新时间
    Duration updateDuration = Duration(seconds: 1);
    _timer = Timer.periodic(updateDuration, updateTime);
  }

  updateTime(Timer timer) {
    if (mounted) {
      _dateTime = DateTime.now();
      _nextTime = _dateTime.add(const Duration(seconds: 1));
      _currentValue = _nextValue == null ? getPanelNumber(false) : _nextValue;
      var nextValue = getPanelNumber(true);
      if ((int.parse(_currentValue)) > int.parse(nextValue)) {
        _child2 = null;
      }
      _nextValue = nextValue;
      _child1 = null;
      if (_currentValue != _nextValue) {
        _controller.forward(from: 0.0);
        setState(() {});
      }
    }
  }

  getPanelNumber(bool nextSecond) {
    FlipClockMode mode = widget.flipClockMode;
    DateTime dateTime = nextSecond ? _nextTime : _dateTime;
    if (FlipClockMode.minute == mode) {
      return formatDate(dateTime, [nn]);
    } else if (FlipClockMode.hour == mode) {
      return formatDate(dateTime, [HH]);
    }
    return formatDate(dateTime, [ss]);
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

//  @override
//  void deactivate(){
//    _controller.dispose();
//    super.deactivate();
//  }

  @override
  Widget build(BuildContext context) {
    buildChildWidgets(context);
    return buildPanel();
  }

  // 裁剪widget
  Widget makeClip(Widget widget, bool upper) {
    return ClipRect(
      child: Align(
        alignment: upper ? Alignment.topCenter : Alignment.bottomCenter,
        heightFactor: 0.5,
        child: widget,
      ),
    );
  }

  // 初始化widget
  void buildChildWidgets(BuildContext context) {
    if (_child1 == null) {
      _child1 = _child2 != null
          ? _child2
          : widget.panelBuilder(context, _currentValue);
      _child2 = null;
      _upperChild1 =
          _upperChild2 != null ? _upperChild2 : makeClip(_child1, true);
      _lowerChild1 =
          _lowerChild2 != null ? _lowerChild2 : makeClip(_child1, false);
    }
    if (_child2 == null) {
      _child2 = widget.panelBuilder(context, _nextValue);
      _upperChild2 = makeClip(_child2, true);
      _lowerChild2 = makeClip(_child2, false);
    }
  }

  // 上半部分
  Widget buildUpperFlipPanel() {
    return Stack(
      children: [
        Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.rotationX(0),
          child: _upperChild2,
        ),
        Transform(
          alignment: Alignment.bottomCenter,
          transform:
              Matrix4.rotationX(_reverse ? math.pi / 2 : _animation.value),
          child: _upperChild1,
        ),
      ],
    );
  }

  // 下半部分
  Widget buildLowerFlipPanel() {
    return Stack(
      children: [
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.rotationX(0),
          child: _lowerChild1,
        ),
        Transform(
          alignment: Alignment.topCenter,
          transform:
              Matrix4.rotationX(_reverse ? -_animation.value : math.pi / 2),
          child: _lowerChild2,
        )
      ],
    );
  }

  Widget buildPanel() {
    return _running
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildUpperFlipPanel(),
              Padding(
                padding: EdgeInsets.only(top: 2.0),
              ),
              buildLowerFlipPanel(),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.rotationX(0),
                child: _upperChild2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0),
              ),
              Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.rotationX(0),
                child: _lowerChild2,
              )
            ],
          );
  }
}
