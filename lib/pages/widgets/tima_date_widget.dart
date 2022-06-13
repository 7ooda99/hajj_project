import 'package:flutter/material.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({Key? key, this.time}) : super(key: key);
  final String? time;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text('3',
        // style: TextStyle(fontWeight: FontWeight.w100),
        // ),
        // Text(' : ',
        // style: TextStyle(fontWeight: FontWeight.w100),
        // ),
        // Text('47 am',
        // style: TextStyle(fontWeight: FontWeight.w100),
        // ),
        Text ('$time'),
      ],
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text('2022',style: TextStyle(fontWeight: FontWeight.w100),),
        Text('/',style: TextStyle(fontWeight: FontWeight.w100),),
        Text('5',style: TextStyle(fontWeight: FontWeight.w100),),
        Text('/',style: TextStyle(fontWeight: FontWeight.w100),),
        Text('20',style: TextStyle(fontWeight: FontWeight.w100),),
      ],
    );
  }
}
