class STTConfig {
  bool onDevice;

  double minSoundLevel;
  double maxSoundLevel;

  STTConfig({
    this.onDevice = false,
    this.minSoundLevel = 50000,
    this.maxSoundLevel = -50000,
  });
}
