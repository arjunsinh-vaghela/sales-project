import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import 'responsive_font_size.dart';

class UiHelper{

  static CustomeText(
  {
    required String text,
    FontWeight? fontwight = FontWeight.normal,
    double? fontsize,
    Color? color,
    String? fontfamily,
  })
  {
   return Text(
     text,
     style: TextStyle(
         color: color,
         fontWeight: fontwight,
         fontSize: fontsize,
         fontFamily: fontfamily ?? 'regular_poppins'
     ),
   );
  }

  static CustomeElevetedButton({
    required String text,
    required VoidCallback onPressed, // Callback passed from caller
    FontWeight? fontWeight = FontWeight.normal,
    double? fontSize,
    Color? textColor = Colors.white,
    String? fontFamily,
    Color? buttonColor = Colors.cyan, // Default button color
  }) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 11.r, horizontal: 50.r)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        )),
      ),
      onPressed: onPressed, // Use the onPressed passed by the caller
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize ?? ResponsiveFontSize.getFontSize(16, 9, 5),// 16 for phone, 9 for tablet, 7 for web,
          fontFamily: fontFamily ?? 'regular_poppins',
        ),
      ),
    );
  }

  static  CustomTextField({
    required TextEditingController controller,
    required String text,
    Widget? prefixIcon, // Nullable prefix icon
    Widget? suffixIcon, // Nullable suffix icon
  }) {
    return Container(
      height: 47.h,
      width: 346.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        // color: Colors.grey,
        border: Border.all(
          color: Colors.grey,
          width: 2.r,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            // Adjust the content padding to ensure vertical centering
            contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
          ),
        ),
      ),
    );
  }

  static CustomTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator, // Function for validation
    VoidCallback? onSuffixIconPressed, // Callback for suffix icon tap
    Widget? prefixIcon, // Nullable prefix icon
    Widget? suffixIcon, // Nullable suffix icon
    bool? isPassword = false, // If text field is password
    bool? isHide = false,
  }) {
    return ConstrainedBox(
       constraints: BoxConstraints(
             maxWidth: 600, // Set a max width (adjust based on design)
       ),
      child: TextFormField(
        controller: controller,
        validator: validator,// Add validation logic
        obscureText: isPassword! ? isHide ?? false : false,
        maxLength: 51,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 2.w,
              color: Colors.grey,
            ),
          ),
          // hintText: hintText,
          label: Text('${hintText}'),
          prefixIcon: prefixIcon,
          suffixIcon: InkWell(
            child: suffixIcon,
            onTap: onSuffixIconPressed,// Toggle obscureText state
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        ),
      ),
    );
  }

}