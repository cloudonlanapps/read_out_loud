import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud_app/src/custom_widgets/custom_menu.dart';
import 'package:services/services.dart';

import '../../../custom_widgets/menu3.dart';
import '../../../tts/tts_speaker.dart';
import 'audio_parameters.dart';

class AudioPlayer extends ConsumerStatefulWidget {
  const AudioPlayer({super.key});

  @override
  AudioPlayerConfigState createState() => AudioPlayerConfigState();
}

enum TtsState {
  playing,
  stopped,
}

class AudioPlayerConfigState extends ConsumerState<AudioPlayer>
    with WidgetsBindingObserver {
  late TextEditingController textEditingController;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    textEditingController =
        TextEditingController(text: ref.read(ttsSpeakerProvider).sampleText);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ttsSpeaker = ref.watch(ttsSpeakerProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomMenuButton(
                          menuItem: CustomMenuItem(
                            alignment: Alignment.bottomCenter,
                            icon: Icons.play_arrow,
                            color: Colors.greenAccent,
                            onTap: () async {
                              await ref.read(ttsSpeakerProvider.notifier).play(
                                    textEditingController.text,
                                    onComplete: () {},
                                    onCancel: () {},
                                  );
                            },
                            title: 'Play',
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        CustomMenuButton(
                          menuItem: CustomMenuItem(
                            alignment: Alignment.bottomCenter,
                            icon: Icons.stop,
                            color: Colors.redAccent,
                            onTap: () async {
                              await ref
                                  .read(ttsSpeakerProvider.notifier)
                                  .stop();
                            },
                            title: 'Stop',
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  decoration:
                      AppTextFieldTheme.inputDecoration(label: 'Sample text'),
                  controller: textEditingController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  minLines: 2,
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                Menu3(
                  height: 65,
                  children: [
                    null,
                    null,
                    TextButton(
                      onPressed:
                          (textEditingController.text == ttsSpeaker.sampleText)
                              ? null
                              : () async {
                                  setState(() {
                                    textEditingController.text =
                                        ttsSpeaker.sampleText;
                                  });
                                },
                      child: const Text('Restore sample text'),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    left: 8,
                    right: 8,
                  ),
                  child: Container(),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          if (ttsSpeaker.isStopped && !isKeyboardVisible)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: AudioParameters(),
              ),
            )
        ],
      ),
    );
  }
}
