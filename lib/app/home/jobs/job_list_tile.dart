import 'package:crud_db/app/home/models/job.dart';
import 'package:flutter/material.dart';


//To make the list look better and arranged in tiles that have proper paddings and etc. and can be tapped
class JobListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}