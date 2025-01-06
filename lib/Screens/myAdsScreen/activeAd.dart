import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class ActiveAdScreen extends StatefulWidget {
  const ActiveAdScreen({super.key});

  @override
  State<ActiveAdScreen> createState() => _ActiveAdScreenState();
}

class _ActiveAdScreenState extends State<ActiveAdScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: H1Bold(text: Controller.getTag('active')),
    );
  }
}
