import 'package:crud_db/app/home/models/job.dart';
import 'package:crud_db/common_widgets/platform_alert_dialog.dart';
import 'package:crud_db/common_widgets/platform_exception_alert_dialog.dart';
import 'package:crud_db/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key,@required this.database, this.job}) : super(key: key);

  //Push a new route inside the navigation stack
  static Future<void> show(BuildContext context, {Database database, Job job}) async {
    //here we are accessing database by rerouting it since the AddJobPage is the children of MaterialApp but Database(Provider) is not the children of MaterialApp
    //Any new widget is always the children of materialapp
    //root navigator override the cupertino tabview
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  String _name;
  double _ratePerHour;


  //Assign initial value if the condition is met.
  @override
  void initState() { 
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
    
  }

  //To be use in Form widget as formkey - to be use to access the state of the form
  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    //TODO: Validate and submit form
    //TODO: Submit data to firestore

    if (_validateAndSaveForm()) {
      try {
        //Prevent multiple job of the same name by get the value on the stream
        final jobs = await widget.database.jobsStream().first;
        final allName = jobs.map((job) => job.name).toList();
        //Prevent the error when containing the same name when creating new database in Editing part of this form
        if (widget.job != null) {
          allName.remove(widget.job.name);
        }
        if (allName.contains(_name)) {
          PlatformAlertDialog(
                  title: 'Name already used',
                  content: 'Please use a different job name',
                  defaultActionText: 'OK')
              .show(context);
        } else {
          //Form saved when validation is correct
          final id = widget.job?.id ?? documentIdFromCurrentDate(); //Getting the id from the job and will be null if we creating new job
          final job = Job(name: _name, ratePerHour: _ratePerHour, id: id);
          await widget.database.setJob(job);
          //Close the AddJobPage when form is submitted
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(title: 'Failed to submit', exception: e)
            .show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey,
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    //To use form, we need a GlobalKey which is _formKey in this case
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    //Return list since the method returns a list
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job Name'),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name cannot be empty',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: true),
        //on saved => the variable ratePerHour will have the value else it will return 0
        onSaved: (value) => _ratePerHour = double.tryParse(value) ?? 0,
      ),
    ];
  }
}
