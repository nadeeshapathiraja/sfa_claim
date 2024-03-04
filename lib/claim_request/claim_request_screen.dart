// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sfa_claim/blocs/claim_bloc/claim_bloc.dart';
import 'package:sfa_claim/claim_history/claim_history.dart';
import 'package:sfa_claim/components/custom_button.dart';
import 'package:sfa_claim/components/custom_text.dart';
import 'package:sfa_claim/components/custom_text_form_field.dart';

import '../components/customIcon_button.dart';
import '../model/objects.dart';

class ClaimRequest extends StatefulWidget {
  const ClaimRequest({super.key});

  @override
  State<ClaimRequest> createState() => _ClaimRequestState();
}

class _ClaimRequestState extends State<ClaimRequest> {
  final _bloc = ClaimBloc();
  final List<String> items = [
    'Fuel',
    'Highway',
    'Accomadation',
    'Meals',
    'Others',
  ];

  final ImagePicker imagePiceker = ImagePicker();

  String selectedVisitNo = '';
  String selectedExpenseType = '';
  TextEditingController textEditingController = TextEditingController();
  final TextEditingController _expenseAmount = TextEditingController();
  final TextEditingController _expenseRemark = TextEditingController();
  bool withBill = false;

  List<String> expenseNamelist = [];
  List<String> finalExpenseNamelist = [];

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

  // void _changeVisitNo(selectedVal) {
  //   setState(
  //     () {
  //       selectedVisitNo = selectedVal;
  //     },
  //   );
  // }

  // void _changeBillType(selectedVal) {
  //   setState(
  //     () {
  //       withBill = selectedVal;
  //     },
  //   );
  // }

  List<XFile> imageList = [];
  List<String> base64ImageList = [];

//Select Images
  Future<void> selectImages(Function() state) async {
    final List<XFile> selectedImages = await imagePiceker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      imageList.addAll(selectedImages);
    }

    base64ImageList = [];
    for (var file in imageList) {
      Uint8List fileBytes = await file.readAsBytes();
      // String base64String = base64Encode(fileBytes);
      final imageEncoded = base64.encode(fileBytes);
      final setImage = "'$imageEncoded'";
      base64ImageList.add(setImage);
    }
    Logger().wtf(base64ImageList);
    state();
  }

//Get All expense types
  Future<void> getClaimConfirmResons(
    BuildContext context,
    String com,
  ) async {
    Map data = {
      'com': com,
    };

    var getAllTypesAPI =
        "http://scm-stg.abans.com:1105/api/v1/SFA/Visitclaimtype";

    var response = await http.post(
      Uri.parse(getAllTypesAPI),
      body: data,
    );

    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body).cast<String, dynamic>();
        Logger().w(json);

        if (json['Success'] == true) {
          expenseNamelist = [];
          finalExpenseNamelist = [];
          List<GetExpenseTypes> claimTypes = json['Data']
              .map<GetExpenseTypes>((json) => GetExpenseTypes.fromJson(json))
              .toList();

          for (var element in claimTypes) {
            expenseNamelist.add(element.SAVCT_TYPE!);
          }
          finalExpenseNamelist = expenseNamelist;
          Logger().d(finalExpenseNamelist.length);
        } else {
          return Future.error("Success Failed");
        }
      } else {
        return Future.error("Status Code Error");
      }
    } catch (e) {
      Logger().e(e);
      return Future.error(e);
    }
  }

  String visitNo = '';
  List<GetExpenseHistory> claimHistoryList = [];
  //Get All expense types
  Future<void> getClaimHistory(
    BuildContext context,
    String com,
    String vistnumber,
  ) async {
    Map data = {
      'vistnumber': vistnumber,
      'com': com,
    };

    var getClaimHistoryAPI =
        "http://scm-stg.abans.com:1105/api/v1/SFA/getvisitclaimdata";

    var response = await http.post(
      Uri.parse(getClaimHistoryAPI),
      body: data,
    );

    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body).cast<String, dynamic>();
        Logger().w(json);

        if (json['Success'] == true) {
          claimHistoryList = [];
          List<GetExpenseHistory> claimHistory = json['Data']
              .map<GetExpenseHistory>(
                  (json) => GetExpenseHistory.fromJson(json))
              .toList();
          claimHistoryList = claimHistory;
          selectedVisitNo = claimHistoryList.first.SAVCD_VISIT_NO ?? "N/A";
        } else {
          return Future.error("Success Failed");
        }
      } else {
        return Future.error("Status Code Error");
      }
    } catch (e) {
      Logger().e(e);
      return Future.error(e);
    }
  }

  //Save Claim Request
  Future<void> saveClaimRequest({
    required BuildContext context,
    required String com,
    required String userId,
    required String visitnumber,
    required String claimType,
    required String claimremakr,
    required String amount,
    required String session,
    required List<String> imageList,
  }) async {
    Map data = {
      "com": com,
      "user": userId,
      "visitnumber": visitnumber,
      "claimType": claimType,
      "claimremakr": claimremakr,
      "amount": double.parse(amount).toStringAsFixed(2),
      "session": session,
      "image": imageList.toString(),
    };

    Logger().wtf(data);
    var saveClaimAPI = "http://scm-stg.abans.com:1105/api/v1/SFA/Visitclaimadd";

    var response = await http.post(
      Uri.parse(saveClaimAPI),
      body: data,
    );

    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body).cast<String, dynamic>();
        Logger().w(json);

        if (json['Success'] == true) {
          Navigator.pop(context, true);
          Logger().d("Successfully Added");
        } else {
          return Future.error("Success Failed");
        }
      } else {
        return Future.error("Status Code Error");
      }
    } catch (e) {
      Logger().e(e);
      return Future.error(e);
    }
  }

  @override
  void initState() {
    selectedVisitNo = '';
    getClaimHistory(context, "ABL", "ABL-SVH-24-0000008");
    super.initState();
    _bloc.add(GetClaimType(com: "ABL", context: context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const ClaimHistory(),
            ),
            (route) => false);
        return true;
      },
      child: FutureBuilder(
        future: getClaimHistory(context, "ABL", "ABL-SVH-24-0000008"),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const CustomText(
                text: 'Claim Request',
                textAlign: TextAlign.center,
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // body: BlocConsumer(
            //   listener: (context, state) {},
            //   builder: (context, state) {
            //     if (state is ClaimLoading) {
            //       return const Center(child: Text('Loading'));
            //     }

            //     if (state is ClaimError) {
            //       return const Center(child: Text('Error'));
            //     }

            //     if (state is ClaimLoaded) {
            //       return ListView.builder(
            //         itemCount: state.expensetype.length,
            //         itemBuilder: (context, index) {
            //           return Text(state.expensetype[index].SAVCT_TYPE as String);
            //         },
            //       );
            //     }
            //     return Container();
            //   },
            //   bloc: _bloc,
            // ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
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
                                onTap: () async {
                                  await getClaimConfirmResons(
                                    context,
                                    "ABL",
                                  );
                                  _expenseAmount.clear();
                                  _expenseRemark.clear();
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
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                      ),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton2<
                                                            String>(
                                                          isExpanded: true,
                                                          hint: Text(
                                                            'Select Expense',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ),
                                                          ),
                                                          value: selectedExpenseType
                                                                  .isNotEmpty
                                                              ? selectedExpenseType
                                                              : finalExpenseNamelist
                                                                  .first,
                                                          items:
                                                              finalExpenseNamelist
                                                                  .map((item) =>
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            Text(
                                                                          item,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
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
                                                          buttonStyleData:
                                                              const ButtonStyleData(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16),
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
                                                              child:
                                                                  TextFormField(
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
                                                                    horizontal:
                                                                        10,
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
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            searchMatchFn: (item,
                                                                searchValue) {
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
                                                      inputType:
                                                          TextInputType.number,
                                                      controller:
                                                          _expenseAmount,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    CustomTextFormField(
                                                      lable: 'Remark',
                                                      // inputType: TextInputType.number,
                                                      lines: 4,
                                                      controller:
                                                          _expenseRemark,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          flex: 2,
                                                          fit: FlexFit.tight,
                                                          child:
                                                              RoundedCheckBox(
                                                            checkedColor: Colors
                                                                .deepPurple,
                                                            isChecked: false,
                                                            text: ' With Bill',
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            onTap: (val) {
                                                              setState2(() {
                                                                withBill = val!;
                                                              });
                                                              if (withBill ==
                                                                  false) {
                                                                imageList
                                                                    .clear();
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: withBill,
                                                          child: Flexible(
                                                            flex: 2,
                                                            fit: FlexFit.tight,
                                                            child:
                                                                CustomIconButton(
                                                              color:
                                                                  Colors.purple,
                                                              icon:
                                                                  Icons.upload,
                                                              onTap: () {
                                                                setState2(() {
                                                                  selectImages(
                                                                    () {
                                                                      setState2(
                                                                          () {});
                                                                    },
                                                                  );
                                                                });
                                                                setState2(
                                                                    () {});
                                                                print(imageList
                                                                    .length);
                                                              },
                                                              text: 'Upload',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    //Display selected image list
                                                    Builder(builder: (context) {
                                                      return imageList
                                                              .isNotEmpty
                                                          ? Expanded(
                                                              child: GridView
                                                                  .builder(
                                                                itemCount:
                                                                    imageList
                                                                        .length,
                                                                gridDelegate:
                                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      3,
                                                                  crossAxisSpacing:
                                                                      4.0,
                                                                  mainAxisSpacing:
                                                                      4.0,
                                                                ),
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  // return Text(
                                                                  //   imageList.length.toString(),
                                                                  // );
                                                                  return Image
                                                                      .file(
                                                                    File(
                                                                      imageList[
                                                                              index]
                                                                          .path,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          : const SizedBox(
                                                              height: 0);
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      color: Colors.red,
                                                      text: 'Close',
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: CustomButton(
                                                      onTap: () async {
                                                        await saveClaimRequest(
                                                          context: context,
                                                          com: "ABL",
                                                          userId: "1800153",
                                                          visitnumber:
                                                              "ABL-SVH-24-0000008",
                                                          claimType: selectedExpenseType
                                                                  .isNotEmpty
                                                              ? selectedExpenseType
                                                              : finalExpenseNamelist
                                                                  .first,
                                                          claimremakr:
                                                              _expenseRemark
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? _expenseRemark
                                                                      .text
                                                                  : '',
                                                          amount: _expenseAmount
                                                                  .text
                                                                  .isNotEmpty
                                                              ? _expenseAmount
                                                                  .text
                                                              : " 0",
                                                          session: "180154358",
                                                          imageList:
                                                              base64ImageList,
                                                        );
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const ClaimRequest(),
                                                                ),
                                                                (route) =>
                                                                    false);
                                                        return true;
                                                      },
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
                                  color: const Color(0xffCCCCFF),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.deepPurple,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SizedBox(
                                    height: 110,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClaimColumn(
                                          title: "Year",
                                          value: DateTime.now().year.toString(),
                                        ),
                                        ClaimColumn(
                                          title: "Month",
                                          value:
                                              formatDate(DateTime.now(), [MM]),
                                        ),
                                        const ClaimColumn(
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
                                    child: SizedBox(
                                      height: 110,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                  claimHistoryList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: claimHistoryList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                // height: 100,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                      const Color.fromARGB(255, 223, 197, 251),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.deepPurple,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: size.width,
                                      color: Colors.deepPurple,
                                      child: Center(
                                        child: CustomText(
                                          text: claimHistoryList[index]
                                              .SAVCD_TYPE!,
                                          fontSize: 12,
                                          textAlign: TextAlign.center,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          textOverflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          ListViewTile(
                                            title: 'Amount',
                                            value: claimHistoryList[index]
                                                .SAVCD_AMOUNT!,
                                          ),
                                          ListViewTile(
                                            title: 'Remark',
                                            value: claimHistoryList[index]
                                                .SAVCD_REMARK!,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox(
                          child: Text(
                            'Loading...',
                          ),
                        ),
                  SizedBox(
                    height: context.height() * 0.02,
                  )
                ],
              ),
            ),
          );
        },
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
