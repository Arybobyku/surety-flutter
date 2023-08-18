import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDetailPage extends StatefulWidget {
  const AdminDetailPage({Key? key}) : super(key: key);

  @override
  _AdminDetailPageState createState() => _AdminDetailPageState();
}

class _AdminDetailPageState extends State<AdminDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AdminProvider>(builder: (context, valueAdmin, _) {
        return Scaffold(
          backgroundColor: ColorPalette.generalBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
