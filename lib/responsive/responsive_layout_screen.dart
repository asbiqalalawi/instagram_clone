import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  });

  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        if (p1.maxWidth > webScreenSize) {
          return webScreenLayout;
        }
        return mobileScreenLayout; 
      },
    );
  }
}
