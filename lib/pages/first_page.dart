import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost_position_maps/model/slide.dart';
import 'package:ghost_position_maps/pages/map_page.dart';
import 'package:ghost_position_maps/utils/shared_prefs.dart';

class MyAppFirst extends StatefulWidget {
  const MyAppFirst({Key? key}) : super(key: key);

  @override
  State<MyAppFirst> createState() => _MyAppFirstState();
}

class _MyAppFirstState extends State<MyAppFirst> {
  int _currentPage = 0;

  List<Slide> _slides = [];

  PageController _pageController = PageController();

  @override
  void initState() {
    _currentPage = 0;
    _slides = [
      Slide("assets/tokyo.jpg", "ピンの場所に心霊スポットがあります"),
      Slide("assets/tokyo.jpg", "ピンをタップすると、詳細がわかります"),
      Slide("assets/tokyo.jpg", "掲示板で情報を共有できます"),
    ];
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  // the list which contain the build slides
  List<Widget> _buildSlides() {
    return _slides.map(_buildSlide).toList();
  }

  // building single slide
  Widget _buildSlide(Slide slide) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(32),
            child: Image.asset(slide.image, fit: BoxFit.contain),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: Text(
            slide.heading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(
          height: 230,
        )
      ],
    );
  }

  // handling the on page changed
  void _handlingOnPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  // building page indicator
  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1)
        row.children.add(SizedBox(
          width: 12,
        ));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 8 : 5,
      height: index == _currentPage ? 8 : 5,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == _currentPage
              ? const Color.fromRGBO(136, 144, 178, 1)
              : const Color.fromRGBO(206, 209, 223, 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView(
          controller: _pageController,
          onPageChanged: _handlingOnPageChanged,
          physics: const BouncingScrollPhysics(),
          children: _buildSlides(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: <Widget>[
              _buildPageIndicator(),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                  child: const Text(
                    "利用開始",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: () async {
                    await SharedPrefs.setUid("123456");
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapSample()));
                  }),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        )
      ],
    );
  }
}
