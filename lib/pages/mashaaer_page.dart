import 'package:flutter/material.dart';

import '../core/constants.dart';

class MashaaerPage extends StatelessWidget {
  const MashaaerPage({Key? key}) : super(key: key);
  static String id = 'MashaaerPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        automaticallyImplyLeading: true,
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'تفويج المشاعر',
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
