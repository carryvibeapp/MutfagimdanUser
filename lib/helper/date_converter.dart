import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateConverter {
  static String formatDate(DateTime dateTime, BuildContext context, {bool isSecond = true}) {
    return isSecond
        ?  DateFormat('yyyy-MM-dd ${_timeFormatter(context)}:ss').format(dateTime) :
    DateFormat('yyyy-MM-dd ${_timeFormatter(context)}').format(dateTime);
  }

  static String dateToTimeOnly(DateTime dateTime, BuildContext context) {
    return DateFormat(_timeFormatter(context)).format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }
  static String localDateToIsoStringAMPM(DateTime dateTime, BuildContext context) {
    return DateFormat('yyyy-MM-dd ${_timeFormatter(context)}').format(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time, BuildContext context) {
    return DateFormat(_timeFormatter(context)).format(DateFormat('HH:mm').parse(time));
  }

  static bool isAvailable(String start, String end, BuildContext context, {DateTime time}) {
    DateTime _currentTime;
    if(time != null) {
      _currentTime = time;
    }else {
      _currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
    }
    DateTime _start = DateFormat('hh:mm:ss').parse(start);
    DateTime _end = DateFormat('hh:mm:ss').parse(end);
    DateTime _startTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _start.hour, _start.minute, _start.second);
    DateTime _endTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _end.hour, _end.minute, _end.second);
    if(_endTime.isBefore(_startTime)) {
      _endTime = _endTime.add(Duration(days: 1));
    }
    return _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);
  }

  static String convertTimeRange(String start, String end) {
    DateTime _startTime = DateFormat('HH:mm:ss').parse(start);
    DateTime _endTime = DateFormat('HH:mm:ss').parse(end);
    return '${DateFormat('hh:mm aa').format(_startTime)} - ${DateFormat('hh:mm aa').format(_endTime)}';
  }

  static DateTime stringTimeToDateTime(String time) {
    return DateFormat('HH:mm:ss').parse(time);
  }

  static String deliveryDateAndTimeToDate(String deliveryDate, String deliveryTime, BuildContext context) {
    DateTime _date = DateFormat('yyyy-MM-dd').parse(deliveryDate);
    DateTime _time = DateFormat('HH:mm').parse(deliveryTime);
    return '${DateFormat('dd-MMM-yyyy').format(_date)} ${DateFormat(_timeFormatter(context)).format(_time)}';
  }

  static DateTime convertStringTimeToDate(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  static String convertToWeekNameAndTime(DateTime date) {
    return DateFormat('EEEE  hh:mm aa').format(date);
  }

  static String _timeFormatter(BuildContext context) {
    return Provider.of<SplashProvider>(context, listen: false).configModel.timeFormat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static String getWeekName(String index) {
    String _weekName;
    switch (index) {
      case '0': _weekName = 'Sunday';
      break;
      case '1': _weekName = 'Monday';
      break;
      case '2': _weekName = 'Tuesday';
      break;
      case '3': _weekName = 'Wednesday';
      break;
      case '4': _weekName = 'Thursday';
      break;
      case '5': _weekName = 'Friday';
      break;
      case '6': _weekName = 'Saturday';
      break;
    }
    return _weekName;
}


}
