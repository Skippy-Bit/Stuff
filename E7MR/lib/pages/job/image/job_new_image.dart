import 'dart:async';
import 'dart:typed_data';

import 'package:e7mr/state/actions/log.actions.dart';
import 'package:e7mr/state/actions/log_commands/upload_picture.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';

class _NewImagePageModel {
  UploadPicture picture;
  final TextEditingController controller;

  _NewImagePageModel(this.picture)
      : controller = TextEditingController(text: picture.description);

  void setDescription(String newDescription) {
    picture = picture.copyWith(description: newDescription);
  }
}

class NewImagePage extends StatefulWidget {
  NewImagePage({
    Key key,
    this.title,
    @required this.jobTask,
  }) : super(key: key);

  final String title;
  final JobTaskState jobTask;

  @override
  _NewImagePageState createState() => _NewImagePageState();
}

class _NewImagePageState extends State<NewImagePage> {
  final _imageFormKey = GlobalKey<FormState>();

  final models = List<_NewImagePageModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Legg til bilder'),
        ),
        body: Form(
          onWillPop: _onWillPop,
          key: _imageFormKey,
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: _buildImageView(context),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 12.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceAround,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Ta nytt bilde'),
                  onPressed: () {
                    _launchCamera();
                  },
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Fra galleri'),
                  onPressed: () {
                    _launchGallery();
                  },
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Send inn'),
                  onPressed: () {
                    _savePictures(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<bool> _onImageTap(int index) {
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
                    models.removeAt(index);
                  });
                  Navigator.of(context).pop(false);
                },
                child: Text('Ja'),
              ),
            ],
          ),
    );
  }

  Future<void> _launchCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final data = Uint8List.fromList(await image.readAsBytes());
      if (this.mounted) {
        setState(() {
          models.add(_NewImagePageModel(UploadPicture(
            widget.jobTask.jobNo,
            widget.jobTask.jobTaskNo,
            '',
            DateTime.now(),
            data,
          )));
        });
      }
    }
  }

  Future<void> _launchGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final data = Uint8List.fromList(await image.readAsBytes());
      if (this.mounted) {
        setState(() {
          models.add(_NewImagePageModel(UploadPicture(
            widget.jobTask.jobNo,
            widget.jobTask.jobTaskNo,
            '',
            DateTime.now(),
            data,
          )));
        });
      }
    }
  }

  Widget _buildImageView(BuildContext context) {
    return Container(
      child: Center(
        child: models.length == 0
            ? Center(child: Text('Ingen bilder lagt til.'))
            : ListView.builder(
                itemCount: models.length,
                padding: EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: Image.memory(
                                models[index].picture.picture,
                                height: 160,
                                width: 90,
                                fit: BoxFit.contain,
                              ),
                              onTap: () {
                                _onImageTap(index);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: models[index].controller,
                                decoration: InputDecoration(
                                  labelText: 'Beskrivelse:',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void _savePictures(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (store != null) {
      for (final model in models) {
        model.setDescription(model.controller.text);
        postLogPayload(store, model.picture);
      }
    }
  }
}
