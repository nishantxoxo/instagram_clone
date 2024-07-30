import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget webscreenlayout;
  final Widget mobilescreenlayout;
   ResponsiveLayoutScreen({ required this.mobilescreenlayout, required this.webscreenlayout});

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adddata();
  }
  adddata() async{
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  } 


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth>webscreemsize){
        return widget.webscreenlayout;
      }
      return widget.mobilescreenlayout;
    },);
  }
}