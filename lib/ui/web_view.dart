import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  bool isLoading  = true;
  String url = Get.arguments;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          if(await controller.canGoBack()){
            controller.goBack();
            return false;
          }else{
            return true;
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              // WebView(
              //   javascriptMode: JavascriptMode.unrestricted,
              //   initialUrl: url,
              //   onPageStarted: (String value){
              //     setState(() {
              //       isLoading = false;
              //     });
              //   },
              //   gestureNavigationEnabled: true,
              //   onWebViewCreated: ( webViewController) {
              //     controller=webViewController;
              //   },
              // ),
              if(isLoading)
                const Align(
                  alignment: Alignment.center,
                  child:CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}