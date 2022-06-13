import 'package:flutter/material.dart';

import '../core/constants.dart';

class HotelPage extends StatelessWidget {
  const HotelPage({Key? key}) : super(key: key);
  static String id = 'HotelPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, 
        ),
        automaticallyImplyLeading: true,
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'تفويج الفنادق',
          style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
        ),
      ),
      body: const Center(
        child: Text('...قريبا',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
