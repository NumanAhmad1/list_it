import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/TermsAndConditions.dart';
import 'package:lisit_mobile_app/const/constColors.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Termandcondition extends StatefulWidget {
  const Termandcondition({super.key});

  @override
  State<Termandcondition> createState() => _TermandconditionState();
}

class _TermandconditionState extends State<Termandcondition> {
  // WebViewController controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setBackgroundColor(const Color(0x00000000))
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (int progress) {
  //         // Update loading bar.
  //       },
  //       onPageStarted: (String url) {},
  //       onPageFinished: (String url) {},
  //       onWebResourceError: (error) {},
  //       onNavigationRequest: (NavigationRequest request) {
  //         if (request.url.startsWith('https://www.youtube.com/')) {
  //           return NavigationDecision.prevent;
  //         }
  //         return NavigationDecision.navigate;
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse('https://www.listit.ae/term-of-use/'));

  bool loading = false;
  late InAppWebViewController inAppWebViewController;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TermsAndConditions>().getTermsAndConditions(context,"Terms of Use");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Consumer<TermsAndConditions>(
            builder: (context, value, child) {
              return value.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                children: [
                  // WebViewWidget(controller: controller),

                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: value.webContent.contains("error:")
                        ? Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 279.h,
                          width: 189.w,
                          child: Image.asset('assets/noResultFound.png'),
                        ),
                        SizedBox(
                          height: 22.h,
                        ),
                        H2semi(text: value.webContent),
                      ],
                    ),)
                        : InAppWebView(
                      initialSettings: InAppWebViewSettings(
                        disallowOverScroll: true,
                        useShouldOverrideUrlLoading: Platform.isAndroid,
                        javaScriptEnabled: true,

                      ),
                      initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.parse(Uri.dataFromString("${Controller.languageChange(english: "", arabic: "<html dir=\"rtl\" lang=\"ar\">")} <meta name=\"viewport\" content=\"width=device-width, user-scalable=no, initial-scale=1, maximum-scale=2.0\"> <br> ${value.webContent}",
                            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                            .toString())),
                        // initialUrlRequest: URLRequest(url: Uri.parse(widget.uri)),
                      ),
                      shouldOverrideUrlLoading: (controller, navigation) async {
                        log("${navigation.request.url}");
                        // if(navigation.request.url.toString().contains("google")) {
                        //   return NavigationActionPolicy.CANCEL;
                        // }
                        // else{
                        if (navigation.request.url.toString().contains(".pdf")) {
                          if (!await launchUrl(
                              Uri.parse("${navigation.request.url}"),
                              mode: LaunchMode.inAppBrowserView)) {
                            throw Exception(
                                'Could not launch ${navigation.request.url}');
                          }
                        }
                          return NavigationActionPolicy.ALLOW;
                        // }
                      },
                      onLoadStart: (controller, url) => setState(() {
                        loading = true;
                      }),
                      onLoadStop: (controller, url) => setState(() {
                        loading = false;
                      }),
                      onReceivedHttpError: (controller, request, response){
                        log("request from view : ${request}");
                        log("response from view : ${response}");
                      },
                    ),
                  ),

                  Positioned(
                    bottom: 0.h,
                    right: 0.w,
                    left: 0.w,
                    child: Container(
                      height: 55.h,
                      color: kbackgrounColor,
                    ),
                  ),
                  Center(
                      child: loading
                          ? const CircularProgressIndicator()
                          : const SizedBox.shrink()),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 57.h,
                      width: 57.w,
                      color: Colors.transparent,
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

// import 'package:lisit_mobile_app/const/lib_all.dart';

// class Termandcondition extends StatelessWidget {
//   const Termandcondition({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Scrollbar(
//           thickness: 5,
//           thumbVisibility: true,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 9.h,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Container(
//                     height: 50.h,
//                     width: 1.sw,
//                     decoration: const BoxDecoration(),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: SizedBox(
//                                 height: 24.h,
//                                 child: const Icon(Icons.arrow_back_ios)),
//                           ),
//                           SizedBox(
//                               height: 24.h,
//                               child: H2Bold(
//                                 text: 'Terms of Use',
//                               )),
//                           const SizedBox(),
//                         ]),
//                   ),
//                 ),
//                 const Divider(),
//                 H2semi(
//                   text:
//                       'PLEASE READ THIS IMPORTANT LEGAL INFORMATION THAT GOVERNS YOUR USE OF THE LISTIT.AE WEBSITE AND THE SERVICES.',
//                   maxLines: 4,
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 18.0, right: 18.0, bottom: 10),
//                   child: H2Regular(
//                     maxLines: 50,
//                     text:
//                         'Accumsan urna, posuere non viverra varius fringilla urna enim. Etiam congue faucibus arcu mauris risus massa nisi. Amet, imperdiet risus adipiscing est ullamcorper sit amet, vitae arcu. Quis consectetur ut urna, at sem rhoncus, scelerisque vitae. Semper amet neque enim diam. Risus sed nisl tincidunt morbi commodo ut tortor ornare integer. Arcu dolor, eget tellus, quis arcu tellus risus molestie. Felis ornare turpis ut nullam. Fames ac urna, ac felis. Vel eget dui arcu, netus ullamcorper massa massa non. Scelerisque posuere eget sit placerat sed libero non feugiat felis.Accumsan urna, posuere non viverra varius fringilla urna enim. Etiam congue faucibus arcu mauris risus massa nisi. Amet, imperdiet risus adipiscing est ullamcorper sit amet, vitae arcu. Quis consectetur ut urna, at sem rhoncus, scelerisque vitae. Semper amet neque enim diam. Risus sed nisl tincidunt morbi commodo ut tortor ornare integer. Arcu dolor, eget tellus, quis arcu tellus risus molestie. Felis ornare turpis ut nullam. Fames ac urna, ac felis. Vel eget dui arcu, netus ullamcorper massa massa non. Scelerisque posuere eget sit placerat sed libero non feugiat felis.',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
