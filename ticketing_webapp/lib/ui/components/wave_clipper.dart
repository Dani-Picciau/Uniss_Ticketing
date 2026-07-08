// Questa classe "ritaglia" un widget rettangolare dandogli la forma di un'onda in basso
import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    
    // 1. Partiamo in alto a sinistra e scendiamo giù
    path.lineTo(0, size.height - 40); 
    
    // 2. Disegniamo la prima curva dolce (scende verso il basso)
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, 
        firstEndPoint.dx, firstEndPoint.dy);
        
    // 3. Disegniamo la seconda curva (risale leggermente)
    var secondControlPoint = Offset(size.width * 0.75, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, 
        secondEndPoint.dx, secondEndPoint.dy);
        
    // 4. Andiamo all'angolo in alto a destra e chiudiamo la forma
    path.lineTo(size.width, 0); 
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}