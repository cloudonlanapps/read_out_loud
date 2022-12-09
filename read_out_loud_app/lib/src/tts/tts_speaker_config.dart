class TTSSpeakerConfig {
  final String sampleText;
  final bool isAndroid;
  final String? engine;
  final String language;
  final double volume;
  final double pitch;
  final double rate;
  final bool isCurrentLanguageInstalled;
  TTSSpeakerConfig({
    this.sampleText = "The quick brown fox jumps over the lazy dog.",
    required this.isAndroid,
    this.engine,
    this.language = 'en-US',
    this.volume = 0.5,
    this.pitch = 1.0,
    this.rate = 0.5,
    this.isCurrentLanguageInstalled = false,
  });

  TTSSpeakerConfig copyWith({
    String? sampleText,
    bool? isAndroid,
    String? engine,
    String? language,
    double? volume,
    double? pitch,
    double? rate,
    bool? isCurrentLanguageInstalled,
  }) {
    return TTSSpeakerConfig(
      sampleText: sampleText ?? this.sampleText,
      isAndroid: isAndroid ?? this.isAndroid,
      engine: engine ?? this.engine,
      language: language ?? this.language,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
      rate: rate ?? this.rate,
      isCurrentLanguageInstalled:
          isCurrentLanguageInstalled ?? this.isCurrentLanguageInstalled,
    );
  }
}
