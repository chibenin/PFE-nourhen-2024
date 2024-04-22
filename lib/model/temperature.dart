import 'dart:ffi';

class ESP1 {
double B1 =0.0;
double H =0.0;
double T =0.0;
String CDC ="";

ESP1(this.B1, this.H, this.T, this.CDC);
ESP1.fromJson(Map<dynamic,dynamic>json){
  B1 = json["B1"];
  H = json["H"];
  T = json["T"];
  CDC = json["CDC"];
}
}
class ESP2 {
  double B2 =0.0;
  double INC =0.0;

  ESP2(this.B2, this.INC);
  ESP2.fromJson(Map<dynamic,dynamic>json){
    B2 = json["B2"];
    INC = json["H"];

  }
}
