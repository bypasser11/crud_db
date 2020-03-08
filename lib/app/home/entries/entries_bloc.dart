import 'package:crud_db/app/home/entries/daily_jobs_details.dart';
import 'package:crud_db/app/home/entries/entries_list_tile.dart';
import 'package:crud_db/app/home/entries/entry_job.dart';
import 'package:crud_db/app/home/job_entries/format.dart';
import 'package:crud_db/app/home/models/entry.dart';
import 'package:crud_db/app/home/models/job.dart';
import 'package:crud_db/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';


class EntriesBloc {
  EntriesBloc({@required this.database});
  final Database database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  /// //Rx was previosly called Observeable
  Stream<List<EntryJob>> get _allEntriesStream => Rx.combineLatest2(
        database.entriesStream(),
        database.jobsStream(),
        //this is the entry combiner function
        _entriesJobsCombiner,
      );

  static List<EntryJob> _entriesJobsCombiner(
      List<Entry> entries, List<Job> jobs) {
    return entries.map((entry) {
      //find the match with entries job id
      final job = jobs.firstWhere((job) => job.id == entry.jobId);
      return EntryJob(entry, job);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
    if (allEntries.isEmpty) {
      return [];
    }
    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    // total duration across all jobs
    // final totalDuration = allDailyJobsDetails
    //     .map((dateJobsDuration) => dateJobsDuration.duration)
    //     .reduce((value, element) => value + element);

     // total pay across all jobs
    // final totalPay = allDailyJobsDetails
    //     .map((dateJobsDuration) => dateJobsDuration.pay)
    //     .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'Entries',
        middleText: 'Earnings',
        trailingText: 'Hours',
        isDescriptor: true,
      ),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyJobsDetails.date),
          middleText: Format.currency(dailyJobsDetails.pay),
          trailingText: Format.hours(dailyJobsDetails.duration),
        ),
        for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            leadingText: jobDuration.name,
            middleText: Format.currency(jobDuration.pay),
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
