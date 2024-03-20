import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'tt_card.dart';
import '../utils/timeTable.dart';

class Timeline extends StatefulWidget {
  const Timeline({super.key});

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<String> tt = [
    "Holiday",
    "Holiday",
    "Holiday",
    "Holiday",
    "Holiday",
    "Holiday",
    "Holiday",
  ];

  late List<Map<String, dynamic>> lectures;

  @override
  void initState() {
    setLectures();
    super.initState();
  }

  void getLectures() {
    int currentDay = DateTime.now().weekday;
    switch (currentDay) {
      case DateTime.monday:
        tt = monday;
        break;
      case DateTime.tuesday:
        tt = tuesday;
        break;
      case DateTime.wednesday:
        tt = wednesday;
        break;
      case DateTime.thursday:
        tt = thursday;
        break;
      case DateTime.friday:
        tt = friday;
        break;
      default:
        return;
    }
  }

  void setLectures() {
    getLectures();
    lectures = [
      {'name': tt[0], 'start': "8:45AM", 'end': "9:45AM"},
      {'name': tt[1], 'start': "9:45AM", 'end': "10:45AM"},
      {'name': 'Short Break', 'start': "10:45AM", 'end': "11:00AM"},
      {'name': tt[2], 'start': "11:00AM", 'end': "12:00PM"},
      {'name': tt[3], 'start': "12:00PM", 'end': "1:00PM"},
      {'name': 'Break', 'start': "1:00PM", 'end': "1:30PM"},
      {'name': tt[4], 'start': "1:30PM", 'end': "2:30PM"},
      {'name': tt[5], 'start': "2:30PM", 'end': "3:30PM"},
      {'name': tt[6], 'start': "3:30PM", 'end': "4:30PM"},
    ];
  }

  String determineStatus(int index, List<Map<String, dynamic>> lectures) {
    DateTime now = DateTime.now();

    DateTime startTime = DateTime(now.year, now.month, now.day).add(
        DateFormat("h:mma")
            .parse(lectures[index]['start'])
            .difference(DateTime(1970)));
    DateTime endTime = DateTime(now.year, now.month, now.day).add(
        DateFormat("h:mma")
            .parse(lectures[index]['end'])
            .difference(DateTime(1970)));

    // Check if the lecture is ongoing
    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return "ongoing";
    }

    if (now.isAfter(endTime)) {
      return "done";
    }

    if (index > 0) {
      DateTime prevEndTime = DateTime(now.year, now.month, now.day).add(
          DateFormat("h:mma")
              .parse(lectures[index - 1]['end'])
              .difference(DateTime(1970)));
      if (now.isAfter(prevEndTime) && now.isBefore(startTime)) {
        return "next lecture";
      }
    }

    return "upcoming";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today’s Timeline',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "${DateFormat.E().format(DateTime.now())}, ${DateFormat.yMMMd().format(DateTime.now())}",
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          SizedBox(
            height: 8.h,
            child: DateTime.now().weekday == 6 || DateTime.now().weekday == 7
                ? const Center(child: Text("No Lectures Today!!"))
                : ListView.builder(
                    itemCount: 9,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      String status = determineStatus(index, lectures);
                      return Row(
                        children: [
                          TTCard(
                              classRoom: "LH-5",
                              subject: lectures[index]["name"],
                              time:
                                  "${lectures[index]["start"]}-${lectures[index]["end"]}",
                              status: status),
                          SizedBox(
                            width: 3.5.w,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
