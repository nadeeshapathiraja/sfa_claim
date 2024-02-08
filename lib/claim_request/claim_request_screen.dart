import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sfa_claim/claim_history/claim_history.dart';
import 'package:sfa_claim/components/custom_button.dart';
import 'package:sfa_claim/components/custom_claim_dialog.dart';
import 'package:sfa_claim/components/custom_text.dart';
import 'package:sfa_claim/components/custom_text_form_field.dart';

import '../components/customIcon_button.dart';

class ClaimRequest extends StatefulWidget {
  const ClaimRequest({super.key});

  @override
  State<ClaimRequest> createState() => _ClaimRequestState();
}

class _ClaimRequestState extends State<ClaimRequest> {
  final List<String> items = [
    'Fuel',
    'Highway',
    'Accomadation',
    'Meals',
    'Others',
  ];

  final List<String> visit_no = [
    'DPS45-01-00-121222',
    'DPS45-01-00-121243',
    'DPS45-01-00-121253',
    'DPS45-01-00-233421',
    'DPS45-01-00-233312',
  ];

  final ImagePicker imagePiceker = ImagePicker();

  String selectedVisitNo = '';
  String selectedExpenseType = '';
  TextEditingController textEditingController = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  bool withBill = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _changeType(selectedVal) {
    setState(
      () {
        selectedExpenseType = selectedVal;
      },
    );
  }

  void _changeVisitNo(selectedVal) {
    setState(
      () {
        selectedVisitNo = selectedVal;
      },
    );
  }

  void _changeBillType(selectedVal) {
    setState(
      () {
        withBill = selectedVal;
      },
    );
  }

  List<XFile> imageList = [];

  Future<void> selectImages(Function() state) async {
    final List<XFile> selectedImages = await imagePiceker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      imageList.addAll(selectedImages);
    }
    state();
  }

  @override
  void initState() {
    selectedVisitNo = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff99ccff).withOpacity(0.4),
        centerTitle: true,
        title: const CustomText(
          text: 'Claim Request',
          textAlign: TextAlign.center,
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xff99ccff).withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xffCCCCFF),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.deepPurple,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                RowTile(
                                  title: 'Visit No',
                                  value: 'DPS45-01-00-121222',
                                ),
                                RowTile(
                                  title: 'Date Range',
                                  value: '21/Jan/2024 - 22/Jan/2024',
                                ),
                                RowTile(
                                  title: 'Vehicle Type',
                                  value: 'Van',
                                ),
                                RowTile(
                                  title: 'Fuel Type',
                                  value: 'Petrol',
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomButton(
                          width: size.width * 0.16,
                          height: size.width * 0.15,
                          color: Colors.green,
                          text: 'ADD\n EXPENSE',
                          fontSize: 10,
                          onTap: () {
                            // ClaimDialog().selectSerialDialog(context, items);
                            setState(() {
                              selectedExpenseType = '';
                              withBill = false;
                              imageList.clear();
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState2) {
                                    return AlertDialog(
                                      title: SizedBox(
                                        width: size.width * 0.9,
                                        child: const CustomText(
                                          text: 'Claim Expense',
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                          fontSize: 20,
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: SizedBox(
                                          height: withBill
                                              ? context.height() * 0.9
                                              : 400,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CustomText(
                                                text: 'Expense Type',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              const SizedBox(height: 5),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Select Expense',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                    ),
                                                    items: items
                                                        .map((item) =>
                                                            DropdownMenuItem(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      _changeType(value);
                                                      setState2(() {
                                                        selectedExpenseType =
                                                            value!;
                                                      });

                                                      print(
                                                          selectedExpenseType);
                                                    },
                                                    value: selectedExpenseType
                                                            .isEmpty
                                                        ? items.first
                                                        : selectedExpenseType,
                                                    buttonStyleData:
                                                        const ButtonStyleData(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16),
                                                      height: 40,
                                                      width: 200,
                                                    ),
                                                    dropdownStyleData:
                                                        const DropdownStyleData(
                                                      maxHeight: 200,
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                    ),
                                                    dropdownSearchData:
                                                        DropdownSearchData(
                                                      searchController:
                                                          textEditingController,
                                                      searchInnerWidgetHeight:
                                                          50,
                                                      searchInnerWidget:
                                                          Container(
                                                        height: 50,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 8,
                                                          bottom: 4,
                                                          right: 8,
                                                          left: 8,
                                                        ),
                                                        child: TextFormField(
                                                          expands: true,
                                                          maxLines: null,
                                                          controller:
                                                              textEditingController,
                                                          decoration:
                                                              InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                              vertical: 8,
                                                            ),
                                                            hintText:
                                                                'Search for an item...',
                                                            hintStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      searchMatchFn:
                                                          (item, searchValue) {
                                                        return item.value!
                                                            .toLowerCase()
                                                            .toString()
                                                            .contains(
                                                              searchValue
                                                                  .toLowerCase(),
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextFormField(
                                                lable: 'Amount',
                                                inputType: TextInputType.number,
                                                controller: _amount,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextFormField(
                                                lable: 'Remark',
                                                inputType: TextInputType.number,
                                                lines: 4,
                                                controller: _amount,
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: RoundedCheckBox(
                                                      checkedColor:
                                                          Colors.deepPurple,
                                                      isChecked: false,
                                                      text: ' With Bill',
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      onTap: (val) {
                                                        setState2(() {
                                                          withBill = val!;
                                                        });
                                                        if (withBill == false) {
                                                          imageList.clear();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: withBill,
                                                    child: Flexible(
                                                      flex: 2,
                                                      fit: FlexFit.tight,
                                                      child: CustomIconButton(
                                                        color: Colors.purple,
                                                        icon: Icons.upload,
                                                        onTap: () {
                                                          setState2(() {
                                                            selectImages(
                                                              () {
                                                                setState2(
                                                                    () {});
                                                              },
                                                            );
                                                          });
                                                          setState2(() {});
                                                          print(
                                                              imageList.length);
                                                        },
                                                        text: 'Upload',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              //Display selected image list
                                              Builder(builder: (context) {
                                                return imageList.isNotEmpty
                                                    ? Expanded(
                                                        child: GridView.builder(
                                                          itemCount:
                                                              imageList.length,
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                            crossAxisSpacing:
                                                                4.0,
                                                            mainAxisSpacing:
                                                                4.0,
                                                          ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            // return Text(
                                                            //   imageList.length.toString(),
                                                            // );
                                                            return Image.file(
                                                              File(
                                                                imageList[index]
                                                                    .path,
                                                              ),
                                                              fit: BoxFit.cover,
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : const SizedBox(height: 0);
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: CustomButton(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                color: Colors.red,
                                                text: 'Close',
                                              ),
                                            ),
                                            Flexible(
                                              child: CustomButton(
                                                onTap: () {},
                                                text: 'Claim',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xffCCFFCC),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.deepPurple,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClaimColumn(
                                    title: "Year",
                                    value: "2024",
                                  ),
                                  ClaimColumn(
                                    title: "Month",
                                    value: "January",
                                  ),
                                  ClaimColumn(
                                    title: "Base Location",
                                    value: "Colombo 05",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ClaimHistory(),
                            //   ),
                            // );
                          },
                          child: Container(
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xffFFCCCC),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.deepPurple,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: SizedBox(
                                height: 110,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: "Total Claims",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    SizedBox(height: 10),
                                    CustomText(
                                      text: '10, 000.00',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),  
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    // height: 100,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffffccff),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.deepPurple,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff0066cc).withOpacity(0.8),
                              // borderRadius: const BorderRadius.only(
                              //   bottomRight: Radius.circular(10),
                              //   topRight: Radius.circular(10),
                              //   topLeft: Radius.circular(5),
                              //   bottomLeft: Radius.circular(5),
                              // ),
                            ),
                            width: context.width() * 0.5,
                            height: 100,
                            child: const Center(
                              child: CustomText(
                                text: 'Accomadation',
                                fontSize: 12,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                textOverflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                        const Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                ListViewTile(
                                  title: 'Amount',
                                  value: "10000.00",
                                ),
                                ListViewTile(
                                  title: 'Remark',
                                  value:
                                      "Test Remark adadad dadada sdadad dadad da dada dadada dadada dadad ",
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: context.height() * 0.02,
            )
          ],
        ),
      ),
    );
  }
}

class ListViewTile extends StatelessWidget {
  const ListViewTile({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        // width: context.width() * 0.6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CustomText(
                text: title,
                fontWeight: FontWeight.bold,
              ),
            ),
            const CustomText(
              text: ' :  ',
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width() * 0.45,
                    child: CustomText(
                      textOverflow: TextOverflow.ellipsis,
                      text: value,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClaimColumn extends StatelessWidget {
  const ClaimColumn({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: title,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          text: value,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

class RowTile extends StatelessWidget {
  const RowTile({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: CustomText(
            text: title,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: CustomText(
            text: ' : ',
          ),
        ),
        Flexible(
          flex: 6,
          fit: FlexFit.tight,
          child: Row(
            children: [
              CustomText(
                text: value,
                fontSize: 11,
                textOverflow: TextOverflow.clip,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
