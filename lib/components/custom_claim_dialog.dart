import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sfa_claim/components/custom_button.dart';
import 'package:sfa_claim/components/custom_text.dart';

class ClaimDialog {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  Future<void> selectSerialDialog(
    BuildContext context,
    List<String> list,
    // Function onConfirmTap,
  ) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                DropdownButton(
                  items: list
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
                  onChanged: (val) {},
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
