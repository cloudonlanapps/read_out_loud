class ViewConfig {
  final bool hideContent;
  final bool showContentBorder;
  final double? borderRadius;
  final String scheme;

  ViewConfig({
    this.hideContent = false,
    this.showContentBorder = true,
    this.borderRadius,
    this.scheme = "size",
  });
}