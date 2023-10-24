import 'package:life_calendar/components/about_row_with_button.dart';
import 'package:life_calendar/components/adaptive_banner_ad.dart';
import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'Support@fourthmouse.com',
      query: encodeQueryParameters(
          <String, String>{'subject': 'LifeCalendar support inquiry'}),
    );

    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Flexible(
                        child: Text(
                          "Thank you for using my app!",
                          style: TextStyle(fontSize: 24),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ]),
              AboutRowWithButton(
                  "This LifeCalendar app was solely developed by Paul McNamee.",
                  Uri(scheme: 'https', host: 'www.paulmcnamee.com', path: '/'),
                  "VISIT PAUL"),
              AboutRowWithButton(
                  "This app code can be viewed on GitHub.",
                  Uri(
                      scheme: 'https',
                      host: 'www.github.com',
                      path: '/paul-mcnamee/LifeCalendar'),
                  "VISIT GITHUB"),
              AboutRowWithButton(
                  "This app is owned by FourthMouse LLC.",
                  Uri(scheme: 'https', host: 'www.fourthmouse.com', path: '/'),
                  "VISIT FOURTHMOUSE"),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "If you have problems with the app or would like to request a new feature please email us.",
                        maxLines: null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Row(
                        children: [
                          StyledButton(
                            onPressed: () {
                              launchUrl(emailLaunchUri);
                            },
                            child: const Text('SEND EMAIL'),
                          ),
                        ],
                      ),
                    )
                  ]),
            ],
          ),
        ),
      ),
      appBar: buildAppBar("Life Calendar (Months)"),
      bottomNavigationBar: Container(child: AdaptiveBannerAd()),
    );
  }
}
