import 'dart:async';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/singpass_code/singpass_code_request.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:webviewx_plus/webviewx_plus.dart' as web;

class WebViewMobile extends StatefulWidget {
  final SingXUrl;
  final AppId;
  String from;

  WebViewMobile(
      {Key? key,
      required this.SingXUrl,
      required this.AppId,
      required this.from})
      : super(key: key);

  @override
  State<WebViewMobile> createState() => _WebViewMobileState();
}

class _WebViewMobileState extends State<WebViewMobile> {
  Timer? timer;
  ContactRepository contactRepository = ContactRepository();
  double progress = 0;

  var loadingPercentage = 0;

  String? _url;

  String get url => _url!;

  set url(String value) {
    _url = value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Size get screenSize => MediaQuery.of(context).size;
  late web.WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:Stack(
        children: [
          web.WebViewX(
            initialContent: widget.SingXUrl,
            initialSourceType: web.SourceType.urlBypass,
            height: screenSize.height,
            width: screenSize.width,
            onWebViewCreated: (controller) {
              webviewController = controller;
            },
            javascriptMode: web.JavascriptMode.unrestricted,
            webSpecificParams: const web.WebSpecificParams(
              printDebugInfo: true,
            ),
            mobileSpecificParams: const web.MobileSpecificParams(
              androidEnableHybridComposition: true,
            ),
            navigationDelegate: (navigation) async {
              debugPrint(navigation.content.sourceType.toString());

              final host = Uri.parse(navigation.content.source).host;
              if (widget.from == AppConstants.singpass) {
                if (host.contains('singx.co')) {
                  apiLoader(context);
                  await contactRepository
                      .apiSingPassVerify(
                          SingPassCodeRequest(
                            code: Uri.parse(navigation.content.source)
                                .queryParameters['code'],
                            state: Uri.parse(navigation.content.source)
                                .queryParameters['state'],
                          ),
                          context)
                      .then((value) async {

                    MyApp.navigatorKey.currentState!.pop();
                    if (value == true) {
                      await RegisterNotifier(context).getAuthStatus(context);
                    }
                  });
                }
              } else if (widget.from == AppConstants.jumio) {
                if (host.contains('singx.co')) {
                  apiLoader(context);

                  await contactRepository
                      .jumioCallBack(
                          Uri.parse(navigation.content.source)
                                  .queryParameters['transactionReference'] ??
                              "",
                          context)
                      .then((value) async {
                    Navigator.pop(context);
                    if (value == true) {
                      await RegisterNotifier(context).getAuthStatus(context);
                    }
                  });

                }
              }

              return web.NavigationDecision.navigate;
            },
            onPageStarted: (url) async {
              setState(() {
                loadingPercentage = 0;
              });
            },
            onPageFinished: (url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
          ),
          loadingPercentage != 100 ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }
}
