import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Basic interface for all calendar events
abstract class CalendarEvent extends Equatable
    implements Comparable<CalendarEvent> {
  /// Create a calendar event with given unique [id] and params
  const CalendarEvent({
    required this.id,
    required this.start,
    required this.duration,
    this.color = Colors.transparent,
  });

  /// Unique [Object] which allows to identify a specific event
  final Object id;

  /// The event [start] date
  final DateTime start;

  /// The event [duration]
  final Duration duration;

  /// Background color of the event view
  final Color color;

  /// The event [end] date
  DateTime get end => start.add(duration);

  @override
  List<Object?> get props => [id, start, duration];

  @override
  bool? get stringify => true;

  @override
  int compareTo(CalendarEvent other) {
    final cmp = start.compareTo(other.start);
    return (cmp != 0) ? cmp : -duration.compareTo(other.duration);
  }
}

/// Interface which allows to modify an event [start] date
abstract class FloatingCalendarEvent extends CalendarEvent {
  /// Create a calendar event which allows to modify
  /// it's [start] date with given unique [id] and params
  const FloatingCalendarEvent({
    required super.id,
    required super.start,
    required super.duration,
    super.color,
  });

  /// Returns modified instance of the event with given params
  FloatingCalendarEvent copyWith({DateTime? start});
}

/// Function definition which allows to use custom [T] events builders
typedef EventBuilder<T extends CalendarEvent> = Widget Function(
  BuildContext context,
  T event,
);

/// Interface which allows to modify an event [start] date and it's [duration]
abstract class EditableCalendarEvent extends FloatingCalendarEvent {
  /// Create a calendar event which allows to modify
  /// it's [start] date and [duration] with given unique [id] and params
  const EditableCalendarEvent({
    required super.id,
    required super.start,
    required super.duration,
    super.color,
  });

  /// Returns modified instance of the event with given params
  @override
  EditableCalendarEvent copyWith({
    DateTime? start,
    Duration? duration,
  });
}

/// Base class for all day events
/// Which allows to modify an event [start] date and it's [duration]
abstract class AllDayCalendarEvent extends EditableCalendarEvent {
  /// Create a calendar all day event
  const AllDayCalendarEvent({
    required super.id,
    required super.start,
    required super.duration,
    super.color,
  });
}

class Break extends CalendarEvent {
  /// Create a break in the calendar
  const Break({
    required super.id,
    required super.start,
    required super.duration,
    super.color = Colors.grey,
  });
}

class TaskDue extends FloatingCalendarEvent {
  /// create a task due event
  const TaskDue({
    required super.id,
    required super.start,
    super.color = Colors.cyan,
    this.wholeDay = false,
  }) : super(duration: wholeDay ? const Duration(days: 1) : Duration.zero);

  /// Whether the task is due for the whole day
  final bool wholeDay;

  /// Returns modified instance of the event with given params
  @override
  TaskDue copyWith({
    DateTime? start,
    Color? color,
    bool? wholeDay,
  }) {
    return TaskDue(
      id: id,
      start: start ?? this.start,
      color: color ?? this.color,
      wholeDay: wholeDay ?? this.wholeDay,
    );
  }
}

/// Basic implementation of [FloatingCalendarEvent]
class SimpleEvent extends EditableCalendarEvent {
  /// Create a simple event
  const SimpleEvent({
    required super.id,
    required super.start,
    required super.duration,
    required this.title,
    required this.description,
    super.color = Colors.white,
  });

  /// The event title
  final String title;
  final String description;

  /// Returns modified instance of the event with given params

  @override
  SimpleEvent copyWith({
    DateTime? start,
    Duration? duration,
    Color? color,
    String? title,
    String? description,
  }) {
    return SimpleEvent(
      id: id,
      start: start ?? this.start,
      duration: duration ?? this.duration,
      color: color ?? this.color,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

/// Basic implementation of [FloatingCalendarEvent] for all day events
class SimpleAllDayEvent extends AllDayCalendarEvent {
  /// Create a simple all day event
  const SimpleAllDayEvent({
    required super.id,
    required super.start,
    required super.duration,
    required this.title,
    super.color = Colors.white,
  });

  /// The event title
  final String title;

  /// Returns modified instance of the event with given params
  @override
  SimpleAllDayEvent copyWith({
    DateTime? start,
    Duration? duration,
    Color? color,
    String? title,
  }) {
    return SimpleAllDayEvent(
      id: id,
      start: start ?? this.start,
      duration: duration ?? this.duration,
      color: color ?? this.color,
      title: title ?? this.title,
    );
  }
}
