class FormInfo {
  final String? group;
  final String? hotelName;
  final String? passengerNo;
  final String? gpsNo;
  // final DateTime? date;
  // final DateTime? time;
  FormInfo(
    this.group,
    this.hotelName,
    this.passengerNo,
    this.gpsNo,
    // this.date,
    // this.time,
  );
  factory FormInfo.fromJson(jsonData) {
    return FormInfo(
        jsonData['group'],
        jsonData['hotel'],
        jsonData['passenger'],
        jsonData['gps'],
        // jsonData['date'],
        // jsonData['time']
        );
  }

 
}
