import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/tax_type_provider.dart';
import '../constes/responsive_font_size.dart';

class AddSalesBottomSheet extends StatelessWidget {
  final TextEditingController? priceController;
  final TextEditingController? nameController;
  final TextEditingController? mobileController;
  final TextEditingController? amountController;
  final TextEditingController? itemNameController;
  final TextEditingController? itemQuantityController;
  final TextEditingController? taxController;
  final GlobalKey<FormState>? formKey;
  // String selectedUnit = 'kg';

  final Function(Map<String, dynamic>) onAdd;
  final bool isEditing;
  final bool? isPurchase;
  final bool? isProfile;

  const AddSalesBottomSheet({
    this.priceController,
    this.nameController,
    this.mobileController,
    this.amountController,
    this.itemNameController,
    this.formKey,
    required this.onAdd,
    this.isEditing = false,
    this.isPurchase,
    this.isProfile,
    this.itemQuantityController,
    this.taxController,
  });

  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(currentDateTime);

    // Access the TaxTypeProvider
    final taxTypeProvider = Provider.of<TaxTypeProvider>(context);

    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              top: 10.r,
              left: 10.r,
              right: 10.r,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isPurchase!
                    ? (isProfile ?? false
                        ? (isEditing ? 'Edit Stock Data' : 'Add Stock Data')
                        : (isEditing
                            ? 'Edit Purchase Data'
                            : 'Add Purchase Data'))
                    : isEditing
                        ? 'Edit Sales Data'
                        : 'Add Sales Data',
                style: TextStyle(
                    fontSize: ResponsiveFontSize.getFontSize(20, 11, 10),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15.h),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    if (isPurchase! != true) ...[
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name of customer';
                          }
                          return null;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          label: Text('Customer Name*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter mobile number of customer';
                          } else if (value.length != 10) {
                            return 'Contact Number must be 10 digits';
                          }
                          return null;
                        },
                        maxLength: 10,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.phone),
                          label: Text('Customer Mobile Number*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: itemNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name of item';
                          }
                          return null;
                        },
                        maxLength: 25,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.shopping_bag_outlined),
                          label: Text('Item Name*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return isProfile ?? false
                                ? 'Please enter stock of item'
                                : 'Please enter amount of item';
                          } else if (!(int.parse(value!) >= 0)) {
                            return 'item must be positive number';
                          }
                          return null;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.currency_rupee),
                          label: Text(isProfile ?? false
                              ? "Item Stock*"
                              : 'Item Price*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: itemQuantityController,
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter item quantity';
                        //   } else if (!(int.parse(value!) >= 1)) {
                        //     return 'item quantity must be at least 1';
                        //   }
                        //   return null;
                        // },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter item quantity';
                          }

                          // Try to parse the value as an integer
                          final intValue = int.tryParse(value);

                          // Check if the parsed value is null or less than 1
                          if (intValue == null) {
                            return 'Quantity should be an integer';
                          } else if (intValue < 1) {
                            return 'Item quantity must be at least 1';
                          }

                          return null; // Return null if validation passes
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                          suffixIcon: SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              value: taxTypeProvider.selectedItemType,
                              items: [
                                DropdownMenuItem(
                                  value: 'COUNT',
                                  child: Text('COUNT'),
                                ),
                                DropdownMenuItem(
                                  value: 'K.G.',
                                  child: Text('K.G.'),
                                ),
                                DropdownMenuItem(
                                  value: 'LITERS',
                                  child: Text('LITERS'),
                                ),
                                DropdownMenuItem(
                                  value: 'METER',
                                  child: Text('METER'),
                                ),
                                DropdownMenuItem(
                                  value: 'FOOT',
                                  child: Text('FOOT'),
                                ),
                                DropdownMenuItem(
                                  value: 'S',
                                  child: Text('S'),
                                ),
                                DropdownMenuItem(
                                  value: 'L',
                                  child: Text('L'),
                                ),
                                DropdownMenuItem(
                                  value: 'M',
                                  child: Text('M'),
                                ),
                                DropdownMenuItem(
                                  value: 'XL',
                                  child: Text('XL'),
                                ),
                                DropdownMenuItem(
                                  value: 'XXL',
                                  child: Text('XXL'),
                                ),
                                DropdownMenuItem(
                                  value: 'XXXL',
                                  child: Text('XXXL'),
                                ),
                              ],
                              onChanged: (value) {
                                // if (value != null) {
                                  taxTypeProvider.setSelectedItemType(value!);
                                // }
                              },
                              decoration: InputDecoration(
                                // label: Text('Tax Type*'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 2.w,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          label: Text('Item Quantity*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: taxController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          double? percentage = double.tryParse(value!);
                          if (value!.isEmpty) {
                            return 'Please enter tax';
                          }
                          if (taxTypeProvider.selectedTaxType == 'Percentage') {
                            // double? percentage = double.tryParse(value);
                            if (percentage == null ||
                                percentage < 0 ||
                                percentage > 70) {
                              return 'Tax percentage must be between 0 and 70%';
                            }
                          }
                          if(percentage == null){
                            return 'Tax must be interger or double value';
                          }
                          return null;
                        },
                        maxLength: 10,
                        decoration: InputDecoration(
                          // suffixIcon: taxTypeProvider.selectedTaxType == 'Percentage'
                          //     ? Text('%')
                          //     : Icon(Icons.currency_rupee),
                          suffixIcon: SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              value: taxTypeProvider.selectedTaxType,
                              items: [
                                DropdownMenuItem(
                                  value: 'Amount',
                                  child: Row(
                                    children: [
                                      Icon(Icons.attach_money,
                                          color: Colors.blue),
                                      // Icon for Amount
                                      SizedBox(width: 8),
                                      // Space between icon and text
                                      Text('Amount'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Percentage',
                                  child: Row(
                                    children: [
                                      Icon(Icons.percent, color: Colors.green),
                                      // Icon for Percentage
                                      SizedBox(width: 8),
                                      // Space between icon and text
                                      Text('Percentage'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  taxTypeProvider.setSelectedTaxType(value);
                                }
                              },
                              decoration: InputDecoration(
                                // label: Text('Tax Type*'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 2.w,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          label: Text('Tax Amount*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],

                    if (isPurchase!) ...[
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name of supplier';
                          }
                          return null;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          label: Text('Supplier Name*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter mobile number of supplier';
                          } else if (value.length != 10) {
                            return 'Contact Number must be 10 digits';
                          }
                          return null;
                        },
                        maxLength: 10,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.phone),
                          label: Text('Supplier Mobile Number*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: itemNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name of item';
                          }
                          return null;
                        },
                        maxLength: 25,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.shopping_bag_outlined),
                          label: Text('Item Name*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter price';
                          } else if (!(int.parse(value!) >= 0)) {
                            return 'item must be positive number';
                          }
                          return null;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.currency_rupee),
                          label: Text('Item Price*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: itemQuantityController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return isProfile ?? false
                                ? 'Please enter stock of item'
                                : 'Please enter amount of item';
                          } else if (!(int.parse(value!) >= 1)) {
                            return 'item quantity must be at least 1';
                          }
                          return null;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                          suffixIcon: SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              value: taxTypeProvider.selectedItemType,
                              items: [
                                DropdownMenuItem(
                                  value: 'COUNT',
                                  child: Text('COUNT'),
                                ),
                                DropdownMenuItem(
                                  value: 'K.G.',
                                  child: Text('K.G.'),
                                ),
                                DropdownMenuItem(
                                  value: 'LITERS',
                                  child: Text('LITERS'),
                                ),
                                DropdownMenuItem(
                                  value: 'METER',
                                  child: Text('METER'),
                                ),
                                DropdownMenuItem(
                                  value: 'FOOT',
                                  child: Text('FOOT'),
                                ),
                                DropdownMenuItem(
                                  value: 'S',
                                  child: Text('S'),
                                ),
                                DropdownMenuItem(
                                  value: 'L',
                                  child: Text('L'),
                                ),
                                DropdownMenuItem(
                                  value: 'M',
                                  child: Text('M'),
                                ),
                                DropdownMenuItem(
                                  value: 'XL',
                                  child: Text('XL'),
                                ),
                                DropdownMenuItem(
                                  value: 'XXL',
                                  child: Text('XXL'),
                                ),
                                DropdownMenuItem(
                                  value: 'XXXL',
                                  child: Text('XXXL'),
                                ),
                              ],
                              // onChanged: (value) {
                              //   if (value != null) {
                              //     taxTypeProvider.setSelectedItemType(value);
                              //   }
                              //    },
                              onChanged: (String? newValue) {
                                // if (newValue != null) {
                                  taxTypeProvider
                                      .setSelectedItemType(newValue!);
                                // }
                                // setState(() {
                                //   selectedUnit = newValue ??
                                //       'COUNT'; // Update selected unit
                                // });
                              },

                              decoration: InputDecoration(
                                // label: Text('Tax Type*'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 2.w,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          label: Text('Item Quantity*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: taxController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          double? percentage = double.tryParse(value!);
                          if (value!.isEmpty) {
                            return 'Please enter tax';
                          }
                          if (taxTypeProvider.selectedTaxType == 'Percentage') {
                            // double? percentage = double.tryParse(value);
                            if (percentage == null ||
                                percentage < 0 ||
                                percentage > 70) {
                              return 'Tax percentage must be between 0 and 70%';
                            }
                          }
                          if(percentage == null){
                            return 'Tax must be interger or double value';
                          }
                          return null;
                        },
                        maxLength: 10,
                        decoration: InputDecoration(
                          // suffixIcon: taxTypeProvider.selectedTaxType == 'Percentage'
                          //     ? Text('%')
                          //     : Icon(Icons.currency_rupee),
                          suffixIcon: SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              value: taxTypeProvider.selectedTaxType,
                              items: [
                                DropdownMenuItem(
                                  value: 'Amount',
                                  child: Row(
                                    children: [
                                      Icon(Icons.attach_money,
                                          color: Colors.blue),
                                      // Icon for Amount
                                      SizedBox(width: 8),
                                      // Space between icon and text
                                      Text('Amount'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Percentage',
                                  child: Row(
                                    children: [
                                      Icon(Icons.percent, color: Colors.green),
                                      // Icon for Percentage
                                      SizedBox(width: 8),
                                      // Space between icon and text
                                      Text('Percentage'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  taxTypeProvider.setSelectedTaxType(value);
                                }
                              },
                              decoration: InputDecoration(
                                // label: Text('Tax Type*'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 2.w,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          label: Text('Tax Amount*'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.cyan),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            vertical: 10.r, horizontal: 40.r)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        )),
                      ),
                      onPressed: () {
                        if (formKey?.currentState?.validate() ?? false) {
                          double amount =
                              double.tryParse(amountController?.text ?? '0') ??
                                  0;
                          int quantity = int.tryParse(
                                  itemQuantityController?.text ?? '0') ??
                              0;
                          double taxValue =
                              double.tryParse(taxController?.text ?? '0') ?? 0;

                          // Determine tax value format
                          String formattedTaxValue;
                          if (taxTypeProvider.selectedTaxType == 'Percentage') {
                            formattedTaxValue =
                                "${taxValue.toStringAsFixed(2)}%";
                          } else {
                            formattedTaxValue = taxValue
                                .toStringAsFixed(2); // Store as plain number
                          }

                          // Determine tax value format
                          String formattedItemValue;
                          if (taxTypeProvider.selectedTaxType != 'COUNT') {
                            formattedItemValue = quantity.toString();
                          } else {
                            // Combine quantity and selected item type
                            formattedItemValue =
                                "$quantity ${taxTypeProvider.selectedItemType}";

                            // formattedItemValue = "${quantity.toStringAsFixed(2)} ${taxTypeProvider.selectedTaxType}"; // Store as plain number
                          }
                          String formattedItemValue1 =
                              "$quantity ${taxTypeProvider.selectedItemType}";

                          // Calculate tax and total
                          double tax =
                              taxTypeProvider.selectedTaxType == 'Percentage'
                                  ? (amount *
                                      quantity *
                                      taxValue /
                                      100) // Convert percentage to decimal
                                  : taxValue;

                          double total = (amount * quantity) + tax;
                          if (isPurchase!) {
                            if (isProfile ?? false) {
                              onAdd({
                                'Item Price': priceController!.text,
                                'Item Stock': amountController!.text,
                                'Item Name': itemNameController!.text,
                                'Tax': formattedTaxValue,
                                'Total': total.toString(),
                                'Tax Type': taxTypeProvider.selectedTaxType,
                              });
                            } else {
                              onAdd({
                                'Supplier Name': nameController!.text,
                                'Phone Number': mobileController!.text,
                                'Item Price': amountController!.text,
                                'Item Quantity': formattedItemValue1,
                                // quantity.toString(),
                                'Item Name': itemNameController!.text,
                                'Tax': formattedTaxValue,
                                'Total': total.toString(),
                                'Tax Type': taxTypeProvider.selectedTaxType,
                              });
                            }
                          } else {
                            onAdd({
                              'Customer Name': nameController!.text,
                              'Customer Phone Number': mobileController!.text,
                              'Item Amount': amountController!.text,
                              'Item Quantity': formattedItemValue1,
                              // quantity.toString(),
                              'Item Name': itemNameController!.text,
                              'Tax': formattedTaxValue,
                              'Total': total.toString(),
                              'Tax Type': taxTypeProvider.selectedTaxType,
                            });
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        isEditing ? 'Save Changes' : 'Add',
                        style: TextStyle(
                          fontSize: ResponsiveFontSize.getFontSize(16, 9, 7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
