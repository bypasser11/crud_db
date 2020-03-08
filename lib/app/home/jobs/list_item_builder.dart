import 'package:crud_db/app/home/jobs/empty_content.dart';
import 'package:flutter/material.dart';

//typedef that is a function that returns widget
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({Key key, this.snapshot, this.itemBuilder})
      : super(key: key);

  final AsyncSnapshot<List> snapshot;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Cannot load item right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List items) {
    //Large numbers of items using list.builder. the builder is called for items that only visible. better for
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
      ),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
