enum EventType {
  holiday('Holiday', 'holidays'),
  birthday('Birthday', 'births'),
  death('Notable death', 'deaths'),
  event('Event', 'events'),
  selected('Wikipedia featured event', 'selected');

  const EventType(this.humanReadable, this.apiStr);

  final String humanReadable;
  final String apiStr;
}
