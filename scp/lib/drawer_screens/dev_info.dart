import 'package:flutter/material.dart';
import 'package:scp/utils/sizeConfig.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scp/ui/dsc_social.dart';

final String aboutText =
    "Developer Student Clubs (DSC) is a Google Developers powered program for university students to learn mobile and web development skills. The clubs will be open to any student interested to learn, ranging from novice developers who are just starting, to advanced developers who want to further their skills. The clubs are intended as a space for students to try out new ideas and collaborate to solve mobile and web development problems.\n\n"
    "DSC NIT Rourkela is a student chapter of DSC India with a motive to nurture developers within the community and solve real-life problems in the community through technology.";

class DevInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(25, 39, 45, 1),
          title: Text(
            "Developer Info",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'PfDin',
                fontWeight: FontWeight.w600),
          )),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Center(
                child: Text(
                  "ABOUT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PfDin',
                    color: Color.fromRGBO(74, 232, 190, 1),
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/dsc_logo.png',
              fit: BoxFit.scaleDown,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 20, bottom: 30),
              child: Text(
                aboutText,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'PfDin',
                  color: Color.fromRGBO(25, 39, 45, 1),
                ),
              ),
            ),
            dscSocial(),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  "DEVELOPERS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PfDin',
                    color: Color.fromRGBO(74, 232, 190, 1),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                contactCard(
                    context, "Abel Mathew", "https://github.com/DesignrKnight"),
                contactCard(
                    context, "Abhibhaw Asthana", "https://github.com/abhibhaw"),
                contactCard(
                    context, "Ankesh Anku", "https://github.com/ankank30"),
                contactCard(
                    context, "Astha Nayak", "https://github.com/nayakastha"),
                contactCard(context, "Asutosh Ranjan",
                    "https://github.com/asutoshranjan"),
                contactCard(
                    context, "Chinmay Kabi", "https://github.com/Chinmay-KB"),
                contactCard(context, "Manikandan L.",
                    "https://github.com/Manikandan9206"),
                contactCard(
                    context, "Manjeet Pani", "https://github.com/HustleAura"),
                contactCard(context, "Patibanda Sriram ",
                    "https://github.com/SriramPatibanda"),
                contactCard(
                    context, "Reuben Abraham", "http://reubenabraham.com/"),
                contactCard(
                    context, "Smarak Das", "https://github.com/Thesmader"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  "CONTRIBUTORS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PfDin',
                    color: Color.fromRGBO(74, 232, 190, 1),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                contactCard(
                    context, "Harsh Patel", "https://github.com/hkp27299"),
                contactCard(context, "Pratik Priyadarsan",
                    "https://github.com/pratik0197"),
                contactCard(context, "priyanshu0405",
                    "https://github.com/priyanshu0405"),
                contactCard(
                    context, "Rajnish Singh", "https://github.com/rajnis09"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget contactCard(BuildContext context, String name, String contact) {
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (contact != "") {
            _launchURL(contact);
          } else {}
        },
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (name != "Reuben Abraham")
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: SizeConfig.screenWidth * 0.155,
                        width: SizeConfig.screenWidth * 0.155,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.screenWidth * 0.0775),
                          color: Color.fromRGBO(0, 213, 154, 1.0),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: SizeConfig.screenWidth * 0.14,
                        width: SizeConfig.screenWidth * 0.14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.screenWidth * 0.07),
                          color: Colors.white,
                        ),
                        child: Image.network(
                          contact + ".png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: textScaleFactor * 20,
                        fontFamily: 'PfDin',
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  contact,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: textScaleFactor * 15,
                    fontFamily: 'PfDin',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
