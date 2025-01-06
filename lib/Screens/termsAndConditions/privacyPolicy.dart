import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../../Controller/Providers/data/TermsAndConditions.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TermsAndConditions>().getTermsAndConditions(context,"Privacy Policy");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kbackgrounColor,
      child: SafeArea(
        child: Scaffold(
          body: Consumer<TermsAndConditions>(
            builder: (context, value, child) {
              return value.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.parse(Uri.dataFromString("${Controller.languageChange(english: "", arabic: "<html dir=\"rtl\" lang=\"ar\">")}<meta name=\"viewport\" content=\"width=device-width, user-scalable=no, initial-scale=1, maximum-scale=2.0\"> <br> ${value.webContent}",
                            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                            .toString())),
                        // initialUrlRequest: URLRequest(url: Uri.parse(widget.uri)),
                      ),
                      onLoadStart: (controller, url) => setState(() {
                        loading = true;
                      }),
                      onLoadStop: (controller, url) => setState(() {
                        loading = false;
                      }),
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
                    onTap: () {
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
