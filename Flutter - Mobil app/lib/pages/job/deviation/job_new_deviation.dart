import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class ImageAndFile {
  final File file;
  final Widget widget;
  ImageAndFile(this.file, this.widget);

  Future<String> getFileAsBase64() async =>
      base64.encode(await file.readAsBytes());
}

class NewDeviationPage extends StatefulWidget {
  NewDeviationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewDeviationPageState createState() => _NewDeviationPageState();
}

class _NewDeviationPageState extends State<NewDeviationPage> {
  final _deviationFormKey = GlobalKey<FormState>();
  TextEditingController _c;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Er du sikker?'),
            content: Text('Vil du forlate siden'),
            actions: <Widget>[
              FlatButton(
                child: Text('Nei'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Ja'),
              ),
            ],
          ),
    );
  }

  Future<bool> _handleImageTap(int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Fjern bildet?'),
            content: Text('Er du sikker på at du vil fjerne bildet'),
            actions: <Widget>[
              FlatButton(
                child: Text('Nei'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    images.removeAt(index);
                  });
                  Navigator.of(context).pop(false);
                },
                child: Text('Ja'),
              ),
            ],
          ),
    );
  }

  List<ImageAndFile> images = List<ImageAndFile>();

  Future addImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      images.add(
        ImageAndFile(
          image,
          Container(
            child: Image.file(
              image,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      );
    });
  }

  Widget _imageView(BuildContext context) {
    return Container(
      child: Center(
        child: images.length == 0
            ? Text('Ingen bilder lagt til.')
            : GridView.builder(
                itemCount: images.length,
                padding: EdgeInsets.all(8.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: images[index].widget,
                    onTap: () {
                      _handleImageTap(index);
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registrer avvik'),
        ),
        body: Form(
          onWillPop: _onWillPop,
          key: _deviationFormKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: _c,
                  maxLines: null,
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Beskrivelse:',
                  ),
                ),
              ),
              Expanded(child: _imageView(context)),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 12.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Legg til bilde'),
                  onPressed: addImage,
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Send inn'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
