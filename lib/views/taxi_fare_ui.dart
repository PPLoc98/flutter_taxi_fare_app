import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaxiFareUi extends StatefulWidget {
  const TaxiFareUi({super.key});

  @override
  State<TaxiFareUi> createState() => _TaxiFareUiState();
}

class _TaxiFareUiState extends State<TaxiFareUi> {
// สร้างตัวควบคุมสำหรับ TextField เพื่อเช็คผู้ใช้กรอกข้อมูลหรือไม่
  TextEditingController DistanceController = TextEditingController();
  TextEditingController TrafficTController = TextEditingController();

  // ฟังก์ชันคำนวณ BMI และแปลผลลัพธ์
  String Show_Fare = '0.00';
  String Show_Bath = 'บาท';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 246, 248),
      //barบน
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC741),
        title: Text(
          'Taxi Fare',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // จัดให้อยู่กึ่งกลางหน้าจอในแนวตั้ง
            children: [
              // รูปภาพ
              Image.asset(
                'assets/images/Taxi.png',
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              //คำนวณค่าโดยสารแท็กซี่
              Text(
                'คำนวณค่าโดยสารแท็กซี่',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // ช่องกรอกระยะทาง
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ระยะทาง (กิโลเมตร) 🚩',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller:
                        DistanceController, // เชื่อมต่อ TextField กับตัวควบคุม
                    keyboardType: TextInputType.number, // เปิดคีย์บอร์ดตัวเลข
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // บังคับให้พิมพ์ได้เฉพาะตัวเลข 0-9 เท่านั้น
                    ],
                    decoration: const InputDecoration(
                        hintText: 'กรุณากรอกระยะทาง',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color(0xFFFFC741),
                            width: 2,
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // ช่องกรอกเวลา
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เวลารถติด (นาที) ⌚',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller:
                        TrafficTController, // เชื่อมต่อ TextField กับตัวควบคุม
                    keyboardType: TextInputType.number, // เปิดคีย์บอร์ดตัวเลข
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // บังคับให้พิมพ์ได้เฉพาะตัวเลข 0-9 เท่านั้น
                    ],
                    decoration: InputDecoration(
                      hintText: 'กรุณากรอกเวลารถติด',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Color(0xFFFFC741),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // ปุ่มคำนวณค่าโดยสาร
              ElevatedButton(
                onPressed: () {
                  // validate input ตรวจสอบว่าผู้ใช้กรอกข้อมูลหรือไม่
                  if (DistanceController.text.isEmpty ||
                      TrafficTController.text.isEmpty == true) {
                    //ใช้ SnackBar แสดงข้อความแจ้งเตือน
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('⚠️ กรุณาป้อนข้อมูลให้ครบถ้วน!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ));
                    return; // ออกจากฟังก์ชันหากข้อมูลไม่ครบ
                  }
                  // ดึงค่าที่ผู้ใช้กรอกมาและแปลงเป็น double
                  double Distance = double.parse(DistanceController.text);
                  double Traffic = double.parse(TrafficTController.text);
                  double fare = 0.0;

                  //***โค้ดคำสั่งที่มีผลต่อการแสดงผลต้องเขียนอยู่ภายใต้คำสั่ง setState()***/
                  setState(() {
                    // คำนวณค่าโดยสารตามระยะทางแบบขั้นบันได
                    if (Distance > 0) {
                      fare += 35.0; // กิโลเมตรแรก 35 บาท
                    }
                    if (Distance > 1) {
                      // ระยะทางในช่วง กม.ที่ 2-10 (คำนวณสูงสุด 9 กม.)
                      double d = (Distance > 10 ? 10 : Distance) - 1;
                      fare += d * 6.50;
                    }
                    if (Distance > 10) {
                      // ระยะทางในช่วง กม.ที่ 10-20 (คำนวณสูงสุด 10 กม.)
                      double d = (Distance > 20 ? 20 : Distance) - 10;
                      fare += d * 7.00;
                    }
                    if (Distance > 20) {
                      // ระยะทางในช่วง กม.ที่ 20-40 (คำนวณสูงสุด 20 กม.)
                      double d = (Distance > 40 ? 40 : Distance) - 20;
                      fare += d * 8.00;
                    }
                    if (Distance > 40) {
                      // ระยะทางในช่วง กม.ที่ 40-60 (คำนวณสูงสุด 20 กม.)
                      double d = (Distance > 60 ? 60 : Distance) - 40;
                      fare += d * 8.50;
                    }
                    if (Distance > 60) {
                      // ระยะทางในช่วง กม.ที่ 60-80 (คำนวณสูงสุด 20 กม.)
                      double d = (Distance > 80 ? 80 : Distance) - 60;
                      fare += d * 9.00;
                    }
                    if (Distance > 80) {
                      // ระยะทางส่วนที่เกิน 80 กม. ขึ้นไป
                      double d = Distance - 80;
                      fare += d * 10.50;
                    }

                    // คำนวณบวกเพิ่มกรณีรถติด
                    fare += Traffic * 3.00; // นาทีละ 3.00 บาท
                    //ผล
                    Show_Fare = fare.toStringAsFixed(2);             
                  });
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 60),
                  backgroundColor: Color(0xFFFFC741),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'คำนวณค่าโดยสาร',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 15),
              // ปุ่มรีเซ็ต
              ElevatedButton(
                onPressed: () {
                  // ล้างค่าที่ผู้ใช้กรอกและรีเซ็ตผลลัพธ์
                  setState(() {
                    DistanceController.clear();
                    TrafficTController.clear();
                    Show_Fare = '0.00';
                    Show_Bath = 'บาท';
                  });
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 60),
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              //กรอบแสดงผลลัพธ์ BMI
              Container(
                width: MediaQuery.of(context).size.width,
                height:
                    150, // เพิ่มความสูงเพื่อให้มีพื้นที่พอสำหรับข้อความ 3 บรรทัด
                decoration: BoxDecoration(
                  color: Color(0xFFFFCEDBE), // พื้นหลังเหลือง
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // จัดให้อยู่กึ่งกลางแนวตั้ง
                    children: [
                      Text(
                        'ค่าโดยสารแท็กซี่',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        Show_Fare, // แสดงค่าโดยสาร
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5252), // สีแดงอมส้มสำหรับตัวเลข
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        Show_Bath, // แสดงผลลัพธ์บาท
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
