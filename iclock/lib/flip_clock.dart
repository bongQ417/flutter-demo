import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'flip_single_panel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const List<String> dayLong = const ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

class FlipClock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FlipClockState();
  }
}

class _FlipClockState extends State<FlipClock> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context));
    Orientation orientation = MediaQuery.of(context).orientation;
    bool portrait = orientation == Orientation.portrait;
    if (portrait) {
      ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    } else {
      ScreenUtil.instance = ScreenUtil(width: 667, height: 375)..init(context);
    }

    return new Center(child: buildFlipPanel(portrait));
  }

  getChineseWeekDay(DateTime dateTime) {
    return dayLong[dateTime.weekday - 1];
  }

  Widget buildFlipPanel(bool portrait) {
    double base = 1.0;
    Widget panelBuilder(context, number) => Container(
          alignment: Alignment.center,
          width: ScreenUtil.getInstance().setSp(128.0 * base),
          height: ScreenUtil.getInstance().setSp(128.0 * base),
          decoration: BoxDecoration(
            color: const Color(0xFF0c0c0c),
            borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.getInstance().setSp(10.0 * base))),
          ),
          child: Text(
            '$number',
            style: TextStyle(
                fontFamily: "gluqlo",
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil.getInstance().setSp(100.0 * base),
                color: const Color(0xFFb0b0b0)),
          ),
        );
    var now = DateTime.now();
    var weekDay = getChineseWeekDay(now);
    var yearOfDay = formatDate(now, [yyyy, '年', mm, '日', dd]);
    print(ScreenUtil.getInstance().setSp(20.0));
    return portrait
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlipSinglePanel(
                panelBuilder: panelBuilder,
                flipClockMode: FlipClockMode.hour,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setSp(20.0 * base)),
              ),
              FlipSinglePanel(
                panelBuilder: panelBuilder,
                flipClockMode: FlipClockMode.minute,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setSp(20.0 * base)),
              ),
              FlipSinglePanel(
                panelBuilder: panelBuilder,
                flipClockMode: FlipClockMode.second,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$yearOfDay',
                      style: TextStyle(
                          fontFamily: "gluqlo",
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.getInstance().setSp(16.0 * base),
                          color: const Color(0xFFb0b0b0)),
                    ),
                    FlipSinglePanel(
                      panelBuilder: panelBuilder,
                      flipClockMode: FlipClockMode.hour,
                    ),
                  ]),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil.getInstance().setSp(20.0 * base)),
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 站位文字
                    Text(
                      'y',
                      style: TextStyle(
                          fontFamily: "gluqlo",
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.getInstance().setSp(16.0 * base),
                          color: Colors.black),
                    ),
                    FlipSinglePanel(
                      panelBuilder: panelBuilder,
                      flipClockMode: FlipClockMode.minute,
                    ),
                  ]),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil.getInstance().setSp(20.0 * base)),
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$weekDay',
                      style: TextStyle(
                          fontFamily: "gluqlo",
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.getInstance().setSp(16.0 * base),
                          color: const Color(0xFFb0b0b0)),
                    ),
                    FlipSinglePanel(
                      panelBuilder: panelBuilder,
                      flipClockMode: FlipClockMode.second,
                    ),
                  ]),
            ],
          );
  }
}
