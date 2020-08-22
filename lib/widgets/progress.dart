import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Color(0xFFFF512F),
      ),
    ),
  );
}*/

Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: SpinKitDoubleBounce(
      color: Color(0xFFC850C0),
      size: 100.0,
    ),
  );
}

Container circularProgress2() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: SpinKitThreeBounce(
      color: Color(0xFFC850C0),
      size: 30.0,
    ),
  );
}

Container circularProgress3() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: SpinKitWanderingCubes(
      color: Color(0xFF80D0C7),
      size: 100.0,
    ),
  );
}

linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Color(0xFFC850C0),
      ),
    ),
  );
}
