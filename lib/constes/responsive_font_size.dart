import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveFontSize {
  static double getFontSize(double phoneFontSize, double tabletFontSize, double webFontSize) {
    // Get the screen width and height
    double scaleWidth = ScreenUtil().scaleWidth;
    double scaleHeight = ScreenUtil().scaleHeight;

    // Check for device type: Phone, Tablet, or Web
    if (isWeb()) {
      // Web/Desktop
      return webFontSize.sp;
    } else if (isTablet(scaleWidth, scaleHeight)) {
      // Tablet
      return tabletFontSize.sp;
    } else {
      // Phone
      return phoneFontSize.sp;
    }
  }

  // Check if the device is a tablet
  static bool isTablet(double scaleWidth, double scaleHeight) {
    // Tablet condition (you can adjust the threshold values based on your design)
    return scaleWidth > 1.5 && scaleHeight > 1.5;
  }

  // Check if the device is a web or desktop
  static bool isWeb() {
    // Assuming width > 800 is for web or desktop
    return ScreenUtil().screenWidth > 800;
  }
}
