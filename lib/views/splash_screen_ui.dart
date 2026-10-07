import 'package:flutter/material.dart';
import 'package:flutter_taxi_fare_app/views/taxi_fare_ui.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    // หน่วงเวลา 3 วินาทีแล้วเปิดไปหน้า HomeUI( )
    Future.delayed(
        // ระยะเวลาที่หน่วง
        Duration(
          seconds: 3,
        ),
        //เมื่อครบแล้วให้ทำอะไร ณ ที่นี้ เปิดไปหน้า HomeUI( ) แบบย้อนกลับไม่ได้
        (){
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(
               builder: (context) => TaxiFareUi()
             ),
           );
        }      
    );
 
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 246, 248),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/taxi.png',
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 50,
            ),
            //Taxi Fare Calculator
            Text(
              'Taxi Fare Calculator',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.035,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            //
            Text(
              'คำนวณค่าโดยสารแท็กซี่',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.025,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              color: Color(0xFFFFC741),
            ),
          ],
        ),
      ),
    );
  }
}