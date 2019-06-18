import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDo {
  final String jobNo;
  final String jobTaskNo;
  String title;
  String description;
  bool completed;
  DateTime followUpDate;
  DateTime deadline;

  ToDo({
    this.jobNo,
    this.jobTaskNo,
    this.title,
    this.description,
    this.completed,
    this.followUpDate,
    this.deadline,
  });
}

class _OverlayPage extends ModalRoute<void> {
  _OverlayPage({this.todo});
  ToDo todo;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context, todo),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context, ToDo todo) {
    return Center(
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                todo.description != null
                    ? Expanded(
                        child: Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Expanded(child: Text(todo.title)),
                todo.description != null
                    ? Expanded(child: Text(todo.description))
                    : Text(''),
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Lukk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class ToDoPage extends StatefulWidget {
  ToDoPage({this.job, this.jobTask});

  final JobState job;
  final JobTaskState jobTask;

  @override
  ToDoPageState createState() => ToDoPageState(job: job, jobTask: jobTask);
}

class ToDoPageState extends State<ToDoPage> {
  ToDoPageState({this.job, this.jobTask});

  JobState job;
  JobTaskState jobTask;
  List<ToDo> todos = List();
  num _count = 1;

  @override
  Widget build(BuildContext context) {
    void _showOverlay(BuildContext context, ToDo todo) {
      Navigator.of(context).push(_OverlayPage(todo: todo));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sjekkliste'),
      ),
      body: Center(
        child: new ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: CheckboxListTile(
                title: Text('${todos[index].title}'),
                subtitle:
                    Text('${todos[index].jobNo} - ${todos[index].jobTaskNo}'),
                value: todos[index].completed,
                secondary: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    todos[index].followUpDate != null
                        ? Text(
                            DateFormat.yMd().format(todos[index].followUpDate),
                          )
                        : Text(''),
                    todos[index].deadline != null
                        ? Text(
                            DateFormat.yMd().format(todos[index].deadline),
                          )
                        : Text(''),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool) {
                  setState(
                    () {
                      todos[index].completed = !todos[index].completed;
                    },
                  );
                },
              ),
              onLongPress: () {
                _showOverlay(context, todos[index]);
                print('Long press! $index');
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.touch_app),
        onPressed: () {
          setState(() {
            todos.add(ToDo(
                title: 'Test $_count',
                completed: false,
                jobNo: job.no,
                jobTaskNo: jobTask.jobTaskNo,
                description: 'This is a description for Task $_count',
                deadline: DateTime(2019, 1, _count),
                followUpDate: DateTime.now()));
            _count++;
          });
        },
      ),
    );
  }
}
