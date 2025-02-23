import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scp/utils/routes.dart';
import 'package:scp/utils/sizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'time_table_resources.dart';
import 'package:url_launcher/url_launcher.dart';

class TimeTable extends StatefulWidget {
  TimeTable();

  @override
  TimeTableState createState() => new TimeTableState();
}

class TimeTableState extends State<TimeTable> {
  String? theorySection = 'E';
  String? practicalSection = 'P6';
  String sectionSequence = 'pt';
  bool allowedSection = true;

  bool showTimeTable = false;

  final Color primaryColor = Color.fromARGB(255, 49, 68, 76);
  final Color secondaryColor = Color.fromARGB(255, 158, 218, 224);
  final Color lunchColor = Color.fromARGB(255, 238, 71, 89);
  final double unitHeight = 80.0;
  double? screenWidth, screenHeight;

  Future _fetchSectionData(BuildContext context) async {
    TimeTableResources.setCourseNumber();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys();
    theorySection = prefs.getString('theory_section');
    practicalSection = prefs.getString('prac_section');
    bool? isAutumnSemester = await TimeTableResources.isAutumnSem();
    if ((theorySection!.compareTo('Ar.') == 0) ||
        (theorySection!.compareTo('A') == 0) ||
        (theorySection!.compareTo('D') == 0) ||
        (theorySection!.compareTo('C') == 0) ||
        (theorySection!.compareTo('B') == 0)) {
      sectionSequence = isAutumnSemester! ? 'tp' : 'pt';
    } else {
      sectionSequence = isAutumnSemester! ? 'pt' : 'tp';
    }
    if (!isAutumnSemester && theorySection!.compareTo('Ar.') != 0) {
      theorySection = TimeTableResources.subsituteTheorySection[theorySection];
      practicalSection =
          TimeTableResources.substitutePracticalSection[practicalSection];
    }
  }

  _resetSections(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getKeys();
    sharedPreferences.remove('theory_section');
    sharedPreferences.remove('prac_section');
    sharedPreferences.setBool('show_timetable', false);
    Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.rHomepage, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    screenWidth = SizeConfig.screenWidth;
    screenHeight = SizeConfig.screenHeight;
    if (allowedSection) {}
    return FutureBuilder(
      future: _fetchSectionData(context),
      builder: (context, snap) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (val) {
                  _resetSections(context);
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "Reset",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.sync_outlined,
                            color: Color(0xff313131),
                            size: 21,
                          ),
                          Text(
                            "Reset Section",
                            style: TextStyle(
                                color: Color(0xff313131),
                                fontSize: 16.5,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ];
                },
              )
            ],
            title: Text(
              'Your Timetable',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PfDin',
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: primaryColor,
          ),
          body: DefaultTabController(
            length: 5,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: AppBar(
                  // brightness: Brightness.light,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  toolbarOpacity: 0.0,
                  flexibleSpace: TabBar(
                    indicatorPadding: EdgeInsets.zero,
                    labelStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 30,
                    ),
                    unselectedLabelStyle: TextStyle(
                        color: primaryColor.withAlpha(100), fontSize: 20),
                    labelPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                    indicatorColor: Colors.transparent,
                    tabs: TimeTableResources.sequence[sectionSequence]!.keys
                        .map(
                          (day) => Tab(
                            child: Text(
                              day,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    isScrollable: true,
                  ),
                ),
              ),
              body: TabBarView(
                  children: TimeTableResources
                      .sequence[sectionSequence]!.entries
                      .map((entry) => Container(
                          child: buildList(context, entry.key, entry.value)))
                      .toList()),
            ),
          ),
        );
      },
    );
  }

  Widget buildMarker(double? length, Color stripColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 8.0,
        height: length,
        decoration: BoxDecoration(
          color: stripColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }

  void launchMap(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not launch $url");
      throw 'Could not launch Maps';
    }
  }

  Widget buildTheoryCard(PeriodDetails periodDetail) {
    Color stripColor = primaryColor;

    return Container(
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          buildMarker(unitHeight * periodDetail.slotLength!, stripColor),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: screenWidth! - 32.0,
              height: unitHeight * periodDetail.slotLength!,
              child: Card(
                color: stripColor,
                margin: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 23,
                            width: screenWidth! * 0.62,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                periodDetail.name!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            height: 19.8,
                            width: screenWidth! * 0.65,
                            child: AutoSizeText(
                              periodDetail.slotTime!,
                              style: TextStyle(
                                color: Colors.white.withAlpha(200),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          launchMap(periodDetail.location!);
                        },
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withAlpha(200),
                                size: 24.0,
                              ),
                              Text(
                                periodDetail.locationName!,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 24.0,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFreeCard(PeriodDetails periodDetail) {
    Color stripColor = secondaryColor;

    return Container(
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          buildMarker(unitHeight * periodDetail.slotLength!, stripColor),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: screenWidth! - 32.0,
              height: unitHeight * periodDetail.slotLength!,
              child: Card(
                color: stripColor,
                margin: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                          text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: periodDetail.name! + '\n',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: periodDetail.slotTime,
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPracticalCard(PeriodDetails periodDetail) {
    Color stripColor = primaryColor;

    return Container(
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          buildMarker(unitHeight * periodDetail.slotLength!, stripColor),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: screenWidth! - 32.0,
              height: unitHeight * periodDetail.slotLength!,
              child: Card(
                color: stripColor,
                margin: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                          text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: periodDetail.name! + '\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: periodDetail.slotTime,
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: screenWidth! * 0.4,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              backgroundColor: Color(0xff1f538d),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.navigation_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              launchMap(periodDetail.location!);
                            }),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLunchCard(PeriodDetails periodDetail) {
    Color stripColor = lunchColor;

    return Container(
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          buildMarker(unitHeight * periodDetail.slotLength!, stripColor),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: screenWidth! - 32.0,
              height: unitHeight * periodDetail.slotLength!,
              child: Card(
                color: stripColor,
                margin: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                          text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: periodDetail.name! + '\n',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: periodDetail.slotTime,
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildList(BuildContext context, String day, List<String> codes) {
    List<PeriodDetails?> dayList = [];
    dayList = getDayList(day, codes);

    debugPrint("Length ${dayList.length}");

    return ListView.builder(
        itemCount: dayList.length,
        itemBuilder: (BuildContext context, int index) {
          if (dayList[index]!.type == 'theory') {
            return buildTheoryCard(dayList[index]!);
          } else if (dayList[index]!.type == 'practical') {
            return buildPracticalCard(dayList[index]!);
          } else if (dayList[index]!.type == 'lunch') {
            return buildLunchCard(dayList[index]!);
          } else {
            return buildFreeCard(dayList[index]!);
          }
        });
  }

  List<PeriodDetails?> getDayList(String day, List<String> codes) {
    List<bool> slotFilled = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    List<PeriodDetails?> dayList = List.generate(9, (index) => null);

    int j;
    for (int i = 0; i < codes.length; i++) {
      j = i % 9;
      if (slotFilled[j] == true) {
        continue;
      } else if (TimeTableResources.theory[theorySection]!
          .containsKey(codes[i])) {
        dayList[j] = PeriodDetails(
          name: TimeTableResources.theory[theorySection]![codes[i]],
          slotTime: getSlotTime(j, j),
          slotLength: 1,
          type: 'theory',
          location:
              'https://www.google.com/maps/search/?api=1&query=22.25082839,84.90534609',
          locationName: 'LA-II',
        );
        slotFilled[j] = true;
      } else if (TimeTableResources.practical[practicalSection]!
          .containsKey(codes[i])) {
        dayList[j] = PeriodDetails(
          name: TimeTableResources.practicalDetails[TimeTableResources
              .practical[practicalSection]![codes[i]]]!['name'],
          slotTime: getSlotTime(j, j + 2),
          location: TimeTableResources.practicalDetails[TimeTableResources
              .practical[practicalSection]![codes[i]]]!['location'],
          locationName: TimeTableResources.practicalDetails[TimeTableResources
              .practical[practicalSection]![codes[i]]]!['locationName'],
          slotLength: 3,
          type: 'practical',
        );
        debugPrint(
            'location ${TimeTableResources.practicalDetails[TimeTableResources.practical[practicalSection]![codes[i]]]!['location']}');
        slotFilled[j] = true;
        slotFilled[j + 1] = true;
        slotFilled[j + 2] = true;
        i += 2;
      }
    }

    List<PeriodDetails?> dayList2 = [];
    dayList2.addAll(dayList);
    dayList2.insert(
      4,
      PeriodDetails(
        name: 'Lunch',
        location: null,
        slotLength: 1,
        slotTime: '12:00-1:15',
        type: 'lunch',
      ),
    );
    slotFilled.insert(4, true);
    int numbContinuousFree = 0;
    for (int i = 0; i < 4; i++) {
      if (!slotFilled[i]) {
        dayList2[i - numbContinuousFree] = PeriodDetails(
          name: 'Free',
          location: null,
          slotTime: getSlotTime(i - numbContinuousFree, i),
          slotLength: ++numbContinuousFree,
          type: 'free',
        );
      } else {
        numbContinuousFree = 0;
      }
    }
    numbContinuousFree = 0;
    for (int i = 5; i < 10; i++) {
      if (!slotFilled[i]) {
        dayList2[i - numbContinuousFree] = PeriodDetails(
          name: 'Free',
          location: null,
          slotTime: getSlotTime(i - numbContinuousFree - 1, i - 1),
          slotLength: ++numbContinuousFree,
          type: 'free',
        );
      } else {
        numbContinuousFree = 0;
      }
    }
    for (int i = 0; i < dayList2.length; i++) {
      if (dayList2[i] == null) {
        dayList2.removeAt(i);
        i--;
      }
    }

    return dayList2;
  }

  String getSlotTime(int startSlotIndex, int endSlotIndex) {
    debugPrint("startSlotIndex" + startSlotIndex.toString());
    debugPrint("endSlotIndex" + endSlotIndex.toString());
    return TimeTableResources.slotTime[startSlotIndex]['start']! +
        '-' +
        TimeTableResources.slotTime[endSlotIndex]['end']!;
  }
}
