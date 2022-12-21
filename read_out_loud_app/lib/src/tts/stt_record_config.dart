class STTConfig {
  STTConfig({
    this.onDevice = false,
    this.minSoundLevel = 50000,
    this.maxSoundLevel = -50000,
  });
  bool onDevice;

  double minSoundLevel;
  double maxSoundLevel;
}
