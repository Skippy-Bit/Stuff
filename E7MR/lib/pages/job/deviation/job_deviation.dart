import 'package:flutter/material.dart';

class JobDeviationPage extends StatefulWidget {
  JobDeviationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JobDeviationPageState createState() => _JobDeviationPageState();
}

class _JobDeviationPageState extends State<JobDeviationPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Oppgavenummer:' + ' ' + 'PO1'),
          subtitle: Text('Gjennområtten vegg, må byttes før installasjon.'),
          isThreeLine: true,
        ),
        ListTile(
          title: Text('Oppgavenummer:' + ' ' + 'PO2'),
          subtitle: Text(
              'Rørlegger var ikke ferdig, kommer ikke til før han er ferdig.'),
          isThreeLine: true,
        ),
      ],
    );
  }
}
