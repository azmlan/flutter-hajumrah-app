import 'package:flutter/material.dart';

const kWhiteColor = Color(0xffeff3f7);
const kBlueColor = Color(0xff40A2E3);
const kGreenColor = Color(0xff4CAF50);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
    hintTextDirection: TextDirection.rtl,
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: 'اكتب سؤالك هنا ...',
    border: UnderlineInputBorder());

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
