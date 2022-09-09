import 'package:flutter/material.dart';
import 'package:pocmem/config/size_config.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
  }

  int currentPage = 0;
  List<Map<String, String>> content = [
    {"text": "Welcome to POCMEM. Let's start!", "image": "images/notebook_icon.jpg"},
    {
      "text": "You can add your memory with media",
      "image": "images/img.png"
    },
    {"text": "You can add your plans of years", "image": "images/img_1.png"},
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: SizeConfig.defaultSize * 150,
                width: SizeConfig.defaultSize * 150,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: content.length,
                  itemBuilder: (context, index) => Content(
                    image: (content[currentPage]["image"]).toString(),
                    text: (content[currentPage]["text"]).toString(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  content.length,
                  (index) => pageSlide(index),
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize * 30,
              ),
              SizedBox(
                width: SizeConfig.defaultSize * 115,
                height: SizeConfig.defaultSize * 20,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signIn");
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.defaultSize * 9,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple[600]),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container pageSlide(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: SizeConfig.defaultSize * 3,
      width: currentPage == index
          ? SizeConfig.defaultSize * 8
          : SizeConfig.defaultSize * 3,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.deepPurple[400] : Colors.blueGrey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({Key? key, required this.text, required this.image})
      : super(key: key);

  final String text, image;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: SizeConfig.defaultSize * 10,
        ),
        Text(
          "POCMEM",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.defaultSize * 15,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: SizeConfig.defaultSize * 6,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.defaultSize * 7,),
        Image.asset(
          image,
          height: SizeConfig.defaultSize * 100,
          width: SizeConfig.defaultSize * 100,
        ),
      ],
    );
  }
}
