import 'package:flutter/material.dart';

class detaySayfa extends StatefulWidget {

  String ingilizce;
  String turkce;


  detaySayfa({required this.ingilizce,required this.turkce });

  @override
  State<detaySayfa> createState() => _detaySayfaState();
}

class _detaySayfaState extends State<detaySayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detay Sayfa"),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(widget.ingilizce, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
            Text(widget.turkce, style: TextStyle(color: Colors.pink, fontSize: 40)),
          ],
        ),
      ),

    );
  }
}