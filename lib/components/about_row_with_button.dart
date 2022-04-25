import 'package:flutter/material.dart';
import 'package:life_calendar/components/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutRowWithButton extends StatelessWidget {
  const AboutRowWithButton(this.description, this.uri, this.buttonText);
  final String description;
  final String buttonText;
  final Uri uri;

  @override
  Widget build(BuildContext context) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Flexible(
                child: Text(
                  description,
                  maxLines: null,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Row(
                children: [
                  StyledButton(
                    onPressed: () {
                      launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(buttonText),
                  ),
                ],
              ),
            )
          ]);
}
