class ViewConfig {
  final bool hideContent;
  final bool showContentBorder;
  final double? borderRadius;
  final String scheme;

  ViewConfig({
    this.hideContent = false,
    this.showContentBorder = false,
    this.borderRadius,
    this.scheme = "size",
  });
}
