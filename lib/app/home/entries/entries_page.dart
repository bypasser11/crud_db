import 'package:crud_db/app/home/entries/entries_bloc.dart';
import 'package:crud_db/app/home/entries/entries_list_tile.dart';
import 'package:crud_db/app/home/jobs/list_item_builder.dart';
import 'package:crud_db/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntriesPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      child: EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemBuilder(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
