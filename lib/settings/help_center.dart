import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/colorUtils.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  void initState() {
    // Initially, display all items
    filteredItems = questionAnswerList;
    super.initState();
  }

// Search query
  String query = '';
  List<QuestionAnswerModel> questionAnswerList = <QuestionAnswerModel>[
    QuestionAnswerModel(question: 'What is Funky?', answer: 'answer1'),
    QuestionAnswerModel(
        question: 'How do I create an account?',
        answer:
            'You can create an account by downloading our app from the [App Store/Google Play], opening it, and following the sign-up instructions.'),
    QuestionAnswerModel(
        question: 'How do I reset my password?',
        answer:
            'To reset your password, go to the login page, tap on "Forgot Password," and follow the instructions to reset your password via email.'),
    QuestionAnswerModel(
        question: 'Can I use funky on multiple devices?',
        answer:
            'Yes, you can use [App Name] on multiple devices by logging in with the same account credentials.'),
  ];
  List<QuestionAnswerModel> filteredItems = <QuestionAnswerModel>[];
// Function to filter the list
  void updateList(String query) {
    setState(() {
      this.query = query;
      filteredItems = questionAnswerList
          .where((item) => item.question
              .toLowerCase()
              .contains(query.toLowerCase())) // Case-insensitive search
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Help center',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: ClipRRect(
              child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 41),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  "Hi, How can we help you?",
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.symmetric(vertical: 29),
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
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 20, top: 14, bottom: 0),
                    alignLabelWithHint: false,
                    isDense: true,
                    hintText: "Search",
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    suffixIcon: IconButton(
                      color: HexColor(CommonColor.pinkFont),
                      icon: const Icon(Icons.search),
                      iconSize: 25,
                      onPressed: () {},
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'PR',
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'PR',
                    color: Colors.black,
                  ),
                  // controller: controller,
                  keyboardType: TextInputType.text,
                  onChanged: updateList,
                ),
              ),
              ListView.builder(
                itemCount: filteredItems.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ExpansionTile(
                  iconColor: HexColor('#582338'),
                  collapsedIconColor: HexColor('#582338'),
                  title: Text(
                    filteredItems[index].question,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        filteredItems[index].answer,
                        style: TextStyle(
                            fontSize: 16,
                            color: HexColor('#707070'),
                            fontFamily: 'PR'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionAnswerModel {
  String question;
  String answer;
  QuestionAnswerModel({required this.question, required this.answer});
}
