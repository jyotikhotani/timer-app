import 'dart:convert';

TimerModel userDataModelFromJson(String str) =>
    TimerModel.fromJson(json.decode(str));

String userDataModelToJson(TimerModel data) => json.encode(data.toJson());

class TimerModel {
  String? id;
  int? minutes;
  int? seconds;

  TimerModel({
    this.id,
    this.minutes,
    this.seconds,
  });

  factory TimerModel.fromJson(Map<String, dynamic> json) => TimerModel(
        id: json["id"],
        minutes: json["minutes"],
        seconds: json["seconds"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "minutes": minutes,
        "seconds": seconds,
      };
}
