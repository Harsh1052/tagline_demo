class DummyUser1 {
  int totalPassengers;
  int totalPages;
  List<Data> data;

  DummyUser1({this.totalPassengers, this.totalPages, this.data});

  DummyUser1.fromJson(Map<String, dynamic> json) {
    totalPassengers = json['totalPassengers'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  String sId;
  String name;
  int trips;
  int iV;

  Data({this.sId, this.name, this.trips, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    trips = json['trips'];
    iV = json['__v'];
  }
}
