import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Drop_Down extends StatelessWidget {
  final String title;
  final List item;
  final Function(Object?)? onChang;
  final  value;
   Drop_Down({super.key, required this.title,this.value,required this.item , required this.onChang});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 3,
        borderRadius: BorderRadius.zero,
        color: Colors.white,
        child: Container(
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ).tr(),
              items: item
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: value,
              onChanged:onChang,
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
               decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                width: 140,
              ),
              menuItemStyleData: MenuItemStyleData(
    
                padding: EdgeInsets.symmetric(horizontal: 16),
                overlayColor: MaterialStatePropertyAll(Colors.blue)
                // height: 40,
              ),
            ),
          ),
        ),
    );
  }
}