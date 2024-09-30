import 'package:flutter/cupertino.dart';

class Cliperone extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    Path path=Path();
    path.lineTo(0,0);
    path.lineTo(0,size.height);


    path.quadraticBezierTo(size.width*.3, size.height*0.6, size.width*0.7, size.height*0.75,);
    path.quadraticBezierTo(size.width*0.8, size.height*0.79,size.width, size.height*0.6,);
    path.lineTo(size.width,0);
    path.lineTo(0,0);


    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper)=>true;



}