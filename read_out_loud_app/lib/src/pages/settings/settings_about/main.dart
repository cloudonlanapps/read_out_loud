// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../custom_widgets/app_snackbar.dart';
import '../../../custom_widgets/custom_menu.dart';

class MainContent extends ConsumerStatefulWidget {
  final Repository repository;
  final String filename;
  const MainContent({
    required this.repository,
    required this.filename,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainContentState();
}

class _MainContentState extends ConsumerState<MainContent> {
  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    final repositoryPath = ref.watch(repositoryPathProvider);
    final path = repositoryPath.whenOrNull(data: (data) => data);
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Center(
              child: Text(
                aboutText,
                style: TextStyles.normal(context),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.blueGrey,
          thickness: 2,
        ),
        if (path != null)
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CardMenu(
                    menuItems: <CustomMenuItem?>[
                      CustomMenuItem(
                        title: 'Import',
                        icon: FontAwesomeIcons.download,
                        onTap: () => confirmBeforeCall(
                          context,
                          message:
                              'If the chapter with same file name exists, do you want to overwrite?',
                          action: (overwrite) =>
                              onImport(path, overwrite: overwrite),
                        ),
                      ),
                      null,
                      CustomMenuItem(
                        title: 'Archive',
                        icon: FontAwesomeIcons.fileZipper,
                        onTap: () => onArchive(path),
                      ),
                      null,
                      CustomMenuItem(
                        title: 'Reset',
                        icon: FontAwesomeIcons.arrowsRotate,
                        color: Colors.redAccent,
                        onTap: () {
                          confirmBeforeCall(
                            context,
                            message:
                                'Are you sure you want to reset the complete app. This will '
                                'remove the chapter you added, clear all the progress. '
                                'Please make sure you back up your data before resetting',
                            action: (yes) {
                              if (yes) {
                                onReset();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (inProgress)
                  DecoratedBox(
                    decoration: BoxDecoration(color: Colors.blueGrey.shade100),
                    child: const Center(child: CircularProgressIndicator()),
                  )
              ],
            ),
          ),
        const SizedBox(height: 32)
      ],
    );
  }

  void confirmBeforeCall(
    BuildContext context, {
    required String message,
    required Function(bool userChoice) action,
  }) {
    showOkCancelAlertDialog(
      context: context,
      message: message,
      okLabel: 'Yes',
      cancelLabel: 'No',
    ).then((result) {
      action(result == OkCancelResult.ok);
    });
  }

  Future<void> onImport(String path, {required bool overwrite}) async {
    final result = await FilePicker.platform.pickFiles();

    if (result?.files.single.path != null) {
      final file = File((result?.files.single.path)!);
      if (file.existsSync()) {
        await ref
            .read(repositoryProvider(widget.filename).notifier)
            .loadFromZip(
              repository: widget.repository,
              path: path,
              zipFileName: (result?.files.single.path)!,
              overwrite: overwrite,
            );
        if (mounted) {
          AppSnackBar.show(context, 'Import complete');
        }
      } else {
        if (mounted) {
          AppSnackBar.show(context, 'File not found');
        }
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> onReset() async {
    setState(() {
      inProgress = true;
    });
    await ref
        .read(repositoryProvider(widget.filename).notifier)
        .reset(widget.repository);

    if (mounted) {
      AppSnackBar.show(context, 'Reset Done');
    }
    if (mounted) {
      setState(() {
        inProgress = false;
      });
    }
  }

  Future<void> onArchive(String path) async {
    setState(() {
      inProgress = true;
    });
    final archive =
        await widget.repository.archive(path, 'ReadOutLoudArchive.zip');

    if (mounted) {
      if (archive != null) {
        await Share.shareXFiles(
          [XFile(archive)],
          text: 'The Archive is ready, Please download',
        );
        if (mounted) {
          AppSnackBar.show(context, 'Archive Created $archive');
        }
      } else {
        AppSnackBar.show(context, 'Archive failed');
      }
    }
    setState(() {
      inProgress = false;
    });
  }
}

const String aboutText = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Felis donec et odio pellentesque. Commodo nulla facilisi nullam vehicula ipsum a. Phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Adipiscing enim eu turpis egestas. Iaculis at erat pellentesque adipiscing commodo elit at imperdiet. Lorem ipsum dolor sit amet. Venenatis tellus in metus vulputate eu scelerisque. Eu lobortis elementum nibh tellus molestie nunc. Mi proin sed libero enim sed. Ipsum dolor sit amet consectetur adipiscing. Et malesuada fames ac turpis egestas integer eget. Dis parturient montes nascetur ridiculus mus. Donec et odio pellentesque diam volutpat commodo. Amet consectetur adipiscing elit duis tristique sollicitudin nibh.

Vitae elementum curabitur vitae nunc sed velit dignissim. Purus semper eget duis at tellus at. Hendrerit dolor magna eget est. Tortor consequat id porta nibh venenatis cras. Ut diam quam nulla porttitor massa. Pellentesque pulvinar pellentesque habitant morbi tristique senectus. Dui ut ornare lectus sit amet est placerat. Euismod quis viverra nibh cras pulvinar. Lobortis feugiat vivamus at augue eget arcu dictum varius duis. Vestibulum lectus mauris ultrices eros in. Diam maecenas sed enim ut sem viverra aliquet. Faucibus pulvinar elementum integer enim neque volutpat ac tincidunt vitae. Non consectetur a erat nam at lectus urna duis. Urna porttitor rhoncus dolor purus non enim praesent. Ultrices eros in cursus turpis massa tincidunt dui. Malesuada pellentesque elit eget gravida cum sociis natoque. Vitae auctor eu augue ut lectus arcu bibendum at varius. Donec pretium vulputate sapien nec sagittis aliquam malesuada bibendum. Turpis massa sed elementum tempus. Eu volutpat odio facilisis mauris.

Curabitur vitae nunc sed velit dignissim sodales ut eu. Felis bibendum ut tristique et egestas. Orci phasellus egestas tellus rutrum. Enim diam vulputate ut pharetra sit. Nisi scelerisque eu ultrices vitae. Eget est lorem ipsum dolor. Velit ut tortor pretium viverra. Et magnis dis parturient montes nascetur ridiculus mus. Vulputate odio ut enim blandit. Ut placerat orci nulla pellentesque dignissim enim sit amet venenatis. Vitae purus faucibus ornare suspendisse sed nisi lacus. Ultricies mi eget mauris pharetra. Interdum velit euismod in pellentesque massa placerat duis ultricies. Vestibulum sed arcu non odio.

Pulvinar elementum integer enim neque. Id ornare arcu odio ut sem nulla pharetra diam sit. Amet commodo nulla facilisi nullam vehicula ipsum a arcu cursus. Nisl vel pretium lectus quam id. In eu mi bibendum neque egestas congue. Arcu non sodales neque sodales ut etiam. Laoreet sit amet cursus sit amet dictum sit. Erat nam at lectus urna duis convallis. Quisque non tellus orci ac. Posuere urna nec tincidunt praesent semper feugiat. In hac habitasse platea dictumst quisque. Faucibus vitae aliquet nec ullamcorper sit amet risus nullam eget. Lacus viverra vitae congue eu consequat ac felis donec. Vestibulum mattis ullamcorper velit sed ullamcorper. Sem viverra aliquet eget sit amet tellus. Molestie ac feugiat sed lectus vestibulum. Vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt ornare massa. Morbi tincidunt augue interdum velit euismod in pellentesque massa. Quis varius quam quisque id diam vel quam elementum pulvinar. Sem et tortor consequat id porta nibh venenatis.

Velit sed ullamcorper morbi tincidunt ornare massa eget egestas. Potenti nullam ac tortor vitae purus faucibus ornare suspendisse sed. Duis ultricies lacus sed turpis tincidunt id. Id aliquet lectus proin nibh nisl condimentum id venenatis a. Diam maecenas ultricies mi eget. Sit amet nisl purus in mollis nunc. Congue nisi vitae suscipit tellus mauris a diam. Pharetra massa massa ultricies mi quis hendrerit dolor magna eget. Cras pulvinar mattis nunc sed blandit libero volutpat sed. Blandit volutpat maecenas volutpat blandit aliquam etiam erat velit. Pellentesque habitant morbi tristique senectus et netus. Quam adipiscing vitae proin sagittis nisl rhoncus mattis. Enim neque volutpat ac tincidunt.
''';
