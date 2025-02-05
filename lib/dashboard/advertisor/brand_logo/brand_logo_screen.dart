import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'brand_logo_payment.dart';

class BrandLogoScreen extends StatefulWidget {
  final File imageFile;

  const BrandLogoScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<BrandLogoScreen> createState() => _BrandLogoScreenState();
}

class _BrandLogoScreenState extends State<BrandLogoScreen> {
  double _value = 100;
  double _value1 = 100;
  double? middle_ammount;
  double? final_ammount;

  @override
  void initState() {
    setState(() {
      middle_ammount = _value * 2;
      var tax = (middle_ammount! * 18) / 100;
      final_ammount = middle_ammount! + tax;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("#000000"),
                  HexColor("#000000"),
                  Color(0xFF941414),
                ],
              ),
            ),
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  "Brand Logo",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
                ),
                centerTitle: true,
                leadingWidth: 100,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Head Counts',
                            style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PM'),
                          ),
                        ),
                        Theme(
                          data: ThemeData(
                              sliderTheme: SliderThemeData(
                            showValueIndicator: ShowValueIndicator.always,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.redAccent,
                            valueIndicatorTextStyle: TextStyle(color: Colors.white, fontFamily: 'PR'),
                          )),
                          child: Slider(
                            min: 100.0,
                            max: 5000.0,
                            activeColor: HexColor(CommonColor.pinkFont),
                            inactiveColor: Colors.white,
                            thumbColor: Colors.pink,
                            label: '${_value.round()}',
                            value: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                                _value1 = _value;
                                middle_ammount = _value * 2;
                                var tax = (middle_ammount! * 18) / 100;
                                // var tax = (_value * 18) / 100;
                                final_ammount = middle_ammount! + tax;
                              });
                              print("final_ammount ${final_ammount!.toStringAsFixed(2)}");
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Custom',
                            style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PM'),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            // width: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                  spreadRadius: -5,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: TextFormField(
                              maxLength: 150,
                              onChanged: (value) {
                                setState(() {
                                  var value1 = double.parse(value);
                                  // var tax = (_value1 * 18) / 100;
                                  _value1 = value1;
                                  middle_ammount = value1 * 2;
                                  var tax = (middle_ammount! * 18) / 100;
                                  final_ammount = middle_ammount! + tax;

                                  // final_ammount = _value1 + tax;
                                });
                                print(middle_ammount);
                                print(final_ammount);
                              },
                              // enabled: enabled,
                              // validator: validator,
                              maxLines: 1,
                              // onTap: tap,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
                                alignLabelWithHint: false,
                                isDense: true,
                                hintText: 'Enter custom head counts',
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                filled: true,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide:
                                //   BorderSide(color: ColorUtils.blueColor, width: 1),
                                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                // ),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PR',
                                  color: Colors.grey,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'PR',
                                color: Colors.black,
                              ),
                              // controller: controller,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${_value1.toStringAsFixed(2)} Head counts',
                            style: TextStyle(fontSize: 14, color: Colors.pink, fontFamily: 'PB'),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Text(
                                '${middle_ammount!.toStringAsFixed(2)} USD+',
                                style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PB'),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '18% tax and service charges',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: HexColor(CommonColor.subHeaderColor), fontFamily: 'PB'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Total price to pay',
                      style: TextStyle(fontSize: 16, color: HexColor(CommonColor.orange), fontFamily: 'PB'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5), borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          '${final_ammount!.toStringAsFixed(2)} USD',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(Brand_payment(
                          brand_logo: widget.imageFile,
                          currency: 'USD',
                          place: 'Ahmedabad',
                          price: final_ammount!.toStringAsFixed(2),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: HexColor(CommonColor.pinkFont),
                            border: Border.all(color: HexColor(CommonColor.pinkFont), width: 1.5),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          child: Text(
                            'Make a payment',
                            style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PM'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(widget.imageFile)),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
