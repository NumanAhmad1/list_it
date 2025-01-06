import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class UnderReviewScreen extends StatefulWidget {
  const UnderReviewScreen({super.key});

  @override
  State<UnderReviewScreen> createState() => _UnderReviewScreenState();
}

class _UnderReviewScreenState extends State<UnderReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: H1Bold(text: Controller.getTag('under_review')),
    );
  }
}
