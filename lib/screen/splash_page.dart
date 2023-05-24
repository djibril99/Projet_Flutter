import 'package:flutter/material.dart';
import 'dart:async';

import 'package:projet_flutter2023/screen/homePage.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),(){
      Navigator.push(context,MaterialPageRoute(builder: (context){
        return const HomePage();
      })
      );
    }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white ,

      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child:Image.network(
              "assets/images/nuange.png",
              width: 80,
              height: 80,
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xff1152d2),
                const Color(0xff2d67d3),
                const Color(0xff5380d2),
                const Color(0xff88a2d9),
                Colors.deepOrangeAccent.withOpacity(0.0)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "assets/images/nuange.png",
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Meteo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
              ])
            ),


        ],
      )
    );
  }
}
