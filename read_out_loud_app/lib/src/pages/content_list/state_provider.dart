// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

class ContentListConfig {
  final String repoPath;
  final int itemsPerPage;

  ContentListConfig({required this.repoPath, required this.itemsPerPage});

  @override
  bool operator ==(covariant ContentListConfig other) {
    if (identical(this, other)) return true;

    return other.repoPath == repoPath && other.itemsPerPage == itemsPerPage;
  }

  @override
  int get hashCode => repoPath.hashCode ^ itemsPerPage.hashCode;
}

class ContentListState {
  final ContentListConfig contentListConfig;
  final int currentPage;
  final Repository repository;
  late int numPages;
  ContentListState({
    required this.contentListConfig,
    required this.repository,
    required this.currentPage,
  }) : numPages =
            (repository.chapters.length + contentListConfig.itemsPerPage - 1) ~/
                contentListConfig.itemsPerPage {
    if (repository.chapters.isEmpty) {
      //   throw Exception("No lessons found");
    }
    if (numPages > 0) {
      if (currentPage < 0 || currentPage >= numPages) {
        throw Exception("Invalid value for currentPage");
      }
    }
  }

  ContentListState copyWith({
    ContentListConfig? contentListConfig,
    Repository? repository,
    int? currentPage,
  }) {
    return ContentListState(
      contentListConfig: contentListConfig ?? this.contentListConfig,
      repository: repository ?? this.repository,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  bool get isFirst => currentPage == 0;
  bool get isLast => currentPage == (numPages - 1);

  List<Chapter> getcurrentPage() {
    return repository.chapters.sublist(
        currentPage * contentListConfig.itemsPerPage,
        min(repository.chapters.length,
            (currentPage + 1) * contentListConfig.itemsPerPage));
  }

  ContentListState prev() {
    if (isFirst) {
      return this;
    }
    return copyWith(currentPage: currentPage - 1);
  }

  ContentListState next() {
    if (isLast) {
      return this;
    }
    return copyWith(currentPage: currentPage + 1);
  }
}

class ContentListStateNotifier
    extends StateNotifier<AsyncValue<ContentListState>> {
  ContentListStateNotifier(AsyncValue<ContentListState> contentListStateAsync)
      : super(contentListStateAsync);

  prev(ContentListState contentListState) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return contentListState.prev();
    });
  }

  next(ContentListState contentListState) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return contentListState.next();
    });
  }
}

final contentListStateProvider = StateNotifierProvider.family<
    ContentListStateNotifier,
    AsyncValue<ContentListState>,
    ContentListConfig>((ref, contentListConfig) {
  AsyncValue<Repository> repositoryAsync =
      ref.watch(repositoryProvider(contentListConfig.repoPath));
  return repositoryAsync.when(
      data: (Repository repository) => ContentListStateNotifier(AsyncValue.data(
          ContentListState(
              contentListConfig: contentListConfig,
              currentPage: 0,
              repository: repository))),
      error: ((error, stackTrace) =>
          ContentListStateNotifier(AsyncValue.error(error, stackTrace))),
      loading: () => ContentListStateNotifier(const AsyncValue.loading()));
});
