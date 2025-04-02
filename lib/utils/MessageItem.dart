class MessageItem {
  MessageItem({
    required this.expandedValue,
    required this.headerValue,
    required this.msgId,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  int msgId;
  bool isExpanded;
}
