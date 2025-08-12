// To parse this JSON data, do
//
//     final meetingsList = meetingsListFromJson(jsonString);

import 'dart:convert';

List<MeetingsList> meetingsListFromJson(String str) => List<MeetingsList>.from(json.decode(str).map((x) => MeetingsList.fromJson(x)));

String meetingsListToJson(List<MeetingsList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeetingsList {
    String hook;
    String phoneNo;
    DateTime startTime;
    DateTime endTime;
    DateTime startDate;
    DateTime endDate;
    String email;
    String section;
    String meetingUrl;

    MeetingsList({
        required this.hook,
        required this.phoneNo,
        required this.startTime,
        required this.endTime,
        required this.startDate,
        required this.endDate,
        required this.email,
        required this.section,
        required this.meetingUrl,
    });

    factory MeetingsList.fromJson(Map<String, dynamic> json) => MeetingsList(
        hook: json["hook"],
        phoneNo: json["phoneNo"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        email: json["email"],
        section: json["section"],
        meetingUrl: json["meetingUrl"],
    );

    Map<String, dynamic> toJson() => {
        "hook": hook,
        "phoneNo": phoneNo,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "startDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "email": email,
        "section": section,
        "meetingUrl": meetingUrl,
    };
}
