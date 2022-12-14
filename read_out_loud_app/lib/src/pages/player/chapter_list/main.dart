import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

import 'widgets/chapter_list_view.dart';
import 'providers/state_provider.dart';

class MainContent extends ConsumerWidget {
  const MainContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ListPaginate<Chapter> listProvider = ref.watch(contentPageProvider);

    if (listProvider.isEmpty) {
      return Center(
        child: Text(
          "Nothing to show here",
          style: TextStyles.fullPageText(context),
        ),
      );
    }
    final currPage = listProvider.getcurrentPage();
    return ChapterListView(
      key: ObjectKey(currPage),
      chapters: listProvider.getcurrentPage(),
    );
  }
}
