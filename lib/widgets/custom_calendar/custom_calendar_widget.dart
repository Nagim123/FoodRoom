import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_ai/widgets/custom_calendar/calendar_dropdown_widget.dart';
import 'package:intl/intl.dart';

class CustomCalendarController {
  late DateTime savedDateTime;
}

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key, required this.controller});
  final CustomCalendarController controller;

  @override
  State<CustomCalendar> createState() => _CustomCalendar();
}

class _CustomCalendar extends State<CustomCalendar> {
  DateTime savedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  bool isOpen = false; //Was calendar opened
  List<String> monthNames = [
    "Янв",
    "Фев",
    "Мар",
    "Апр",
    "Май",
    "Июн",
    "Июл",
    "Авг",
    "Сен",
    "Окт",
    "Ноя",
    "Дек"
  ];
  List<String> availableYears = [];

  int getDaysInMonth(DateTime dateTime) {
    return DateTimeRange(
            start: DateTime(dateTime.year, dateTime.month),
            end: DateTime(dateTime.year, dateTime.month + 1))
        .duration
        .inDays;
  }

  Widget calendarInputBox(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 7, bottom: 7, left: 12, right: 9),
          decoration: BoxDecoration(
              color: isOpen ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isOpen ? Colors.white : Colors.transparent, width: 2)),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat("dd/MM/yyyy").format(selectedDate),
                    style: TextStyle(
                        color: isOpen ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontFamily: 'Saira',
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 5),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: isOpen
                            ? Colors.white
                            : const Color.fromARGB(255, 97, 78, 110),
                      ),
                    ),
                    onTap: () {
                      isOpen = !isOpen;
                      widget.controller.savedDateTime = selectedDate;
                      setState(() {});
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, top: 2),
          margin: const EdgeInsets.only(bottom: 5),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "ДД/ММ/ГГГГ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget calendarMainBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CalendarDropDown(
                    initialValue: monthNames[selectedDate.month - 1],
                    list: monthNames,
                    onChanged: (value) {
                      int newDay = selectedDate.day;
                      int newMonth = monthNames.indexOf(value) + 1;
                      int maxDays =
                          getDaysInMonth(DateTime(selectedDate.year, newMonth));
                      newDay = min(newDay, maxDays);
                      selectedDate =
                          DateTime(selectedDate.year, newMonth, newDay);
                      widget.controller.savedDateTime = selectedDate;
                      setState(() {});
                    }),
              ),
              Expanded(
                child: CalendarDropDown(
                    initialValue: availableYears[
                        availableYears.indexOf(selectedDate.year.toString())],
                    list: availableYears,
                    onChanged: (value) {
                      int newDay = selectedDate.day;
                      int newYear = int.parse(value);
                      int maxDays =
                          getDaysInMonth(DateTime(newYear, selectedDate.month));
                      newDay = min(newDay, maxDays);
                      selectedDate = DateTime(
                          newYear, selectedDate.month, selectedDate.day);
                      widget.controller.savedDateTime = selectedDate;
                      setState(() {});
                    }),
              ),
            ],
          ),
          getNumberTable(
              getDaysInMonth(selectedDate),
              getDaysInMonth(
                  DateTime(selectedDate.year, selectedDate.month - 1)),
              DateTime(selectedDate.year, selectedDate.month).weekday - 1),
          Container(
            margin: const EdgeInsets.only(left: 3, right: 3, bottom: 4, top: 3),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                        padding: EdgeInsets.all(8),
                        child: const Text(
                          "Отмена",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 97, 78, 110),
                          ),
                        )),
                    onTap: () {
                      isOpen = false;
                      selectedDate = savedDate;
                      widget.controller.savedDateTime = savedDate;
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: const Text(
                          "ОК",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 97, 78, 110),
                          ),
                        )),
                    onTap: () {
                      savedDate = selectedDate;
                      widget.controller.savedDateTime = selectedDate;
                      isOpen = false;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// getNumberTable - generate widget that contains calendar table with
  /// numbers for month.
  ///
  /// maxDay - maximum day in month
  ///
  /// maxDayPrev - maximum day in previous month
  ///
  /// beginDay - {0,1,2,3,4,5,6}. 0 - Monday, 6 - Sunday
  Widget getNumberTable(int maxDay, int maxDayPrev, int beginDay) {
    List<Widget> rows = [];
    int beginOldDays = maxDayPrev - (beginDay - 1);

    List<String> prefixes = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"];
    List<Widget> prefixesWidgets = [];
    for (int i = 0; i < prefixes.length; i++) {
      prefixesWidgets.add(
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            child: Center(
              child: Text(
                prefixes[i],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      );
    }

    Widget headerRow = Row(children: prefixesWidgets);

    rows.add(headerRow);
    List<Widget> numbers = [];
    for (int i = 0; i < 42; i++) {
      String numStr = (i >= beginDay)
          ? "${(i - beginDay) % (maxDay) + 1}"
          : "${beginOldDays + i}";
      numbers.add(
        Expanded(
          child: Container(
            //margin: const EdgeInsets.all(2),
            padding:
                const EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: selectedDate.day == (i - beginDay + 1)
                  ? const Color.fromARGB(255, 97, 78, 110)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: (i >= beginDay && i < beginDay + maxDay)
                  ? InkWell(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          numStr,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Saira",
                            fontWeight: FontWeight.w900,
                            color: selectedDate.day == (i - beginDay + 1)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      onTap: () {
                        selectedDate = DateTime(selectedDate.year,
                            selectedDate.month, int.parse(numStr));
                        widget.controller.savedDateTime = selectedDate;
                        setState(() {});
                      },
                    )
                  : Text(
                      numStr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        ),
      );
      if ((i + 1) % 7 == 0) {
        rows.add(Row(
          children: numbers,
        ));
        numbers = [];
      }
    }
    return Column(
      children: rows,
    );
  }

  List<Widget> generateCalendar(BuildContext context) {
    List<Widget> calendarComponents = [];
    calendarComponents.add(calendarInputBox(context));
    if (isOpen) {
      calendarComponents.add(calendarMainBox(context));
    }

    return calendarComponents;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.savedDateTime = savedDate;
    DateTime currentTime = DateTime.now();
    availableYears.add(currentTime.year.toString());
    availableYears.add((currentTime.year - 1).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: generateCalendar(context),
    );
  }
}
