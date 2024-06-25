import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class card_loading_CPN extends StatelessWidget {
  final Widget chid;
  final bool loading;
  const card_loading_CPN(
      {super.key, required this.chid, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: PulseEffect(from: Colors.grey.shade400, to: Colors.grey.shade200),
      ignoreContainers: true,
      enableSwitchAnimation: true,
      enabled: loading,
      child: chid,
    );
  }
}
