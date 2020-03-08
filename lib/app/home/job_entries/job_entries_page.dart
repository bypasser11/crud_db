import 'dart:async';

import 'package:crud_db/app/home/job_entries/entry_list_item.dart';
import 'package:crud_db/app/home/job_entries/entry_page.dart';
import 'package:crud_db/app/home/jobs/edit_job_page.dart';
import 'package:crud_db/app/home/jobs/list_item_builder.dart';
import 'package:crud_db/app/home/models/entry.dart';
import 'package:crud_db/app/home/models/job.dart';
import 'package:crud_db/common_widgets/platform_exception_alert_dialog.dart';
import 'package:crud_db/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
      //Streambuilder enables the page to be update when Jobs are being edited inside the entry page
      stream: database.jobStream(jobId: job.id),
      builder: (context, snapshot) {
        final job = snapshot.data;
        final jobName = job?.name ?? '';
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 2.0,
            title: Text(jobName),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white,),
                onPressed: () => EditJobPage.show(context, job: job, database: database),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white,),
                onPressed: () =>
                EntryPage.show(context: context, database: database, job: job),
              ),
            ],
          ),
          body: _buildContent(context, job),
        );
      }
    );
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
