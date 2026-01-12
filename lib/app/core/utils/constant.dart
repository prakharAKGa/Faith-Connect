enum MessageStatus { SENT, DELIVERED, SEEN }

MessageStatus parseStatus(String s) {
  switch (s) {
    case 'DELIVERED':
      return MessageStatus.DELIVERED;
    case 'SEEN':
      return MessageStatus.SEEN;
    default:
      return MessageStatus.SENT;
  }
}
