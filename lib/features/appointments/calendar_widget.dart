import 'package:fluent_ui/fluent_ui.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/model.dart';

class WeekAgendaCalendar<T extends Model> extends StatefulWidget {
  final List<T> items;
  final void Function(T) onSelect;
  final void Function() onAddNew;
  final void Function(T, DateTime) onSetTime;
  final List<Widget> actions;
  final DateTime? startDay;
  final DateTime? initiallySelectedDay;

  const WeekAgendaCalendar({
    super.key,
    required this.items,
    required this.onSelect,
    required this.onAddNew,
    required this.onSetTime,
    this.actions = const [],
    this.startDay,
    this.initiallySelectedDay,
  });

  @override
  State<WeekAgendaCalendar<T>> createState() => _WeekAgendaCalendarState<T>();
}

class _WeekAgendaCalendarState<T extends Model> extends State<WeekAgendaCalendar<T>> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initiallySelectedDay ?? DateTime.now();
    _focusedDay = widget.startDay ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar Header with Actions
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getFormattedDate(_focusedDay),
                  style: FluentTheme.of(context).typography.subtitle,
                ),
              ),
              ...widget.actions,
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(FluentIcons.add),
                onPressed: widget.onAddNew,
              ),
            ],
          ),
        ),
        
        // Calendar Widget
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TableCalendar<T>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red),
              holidayTextStyle: TextStyle(color: Colors.red),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Events List for Selected Day
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildEventsListForSelectedDay(),
          ),
        ),
      ],
    );
  }

  List<T> _getEventsForDay(DateTime day) {
    // This would filter items based on the day
    // For appointments, this would check the date field
    return widget.items.where((item) {
      // This is a placeholder - would need to implement based on the model
      return true;
    }).toList();
  }

  Widget _buildEventsListForSelectedDay() {
    final eventsForDay = _getEventsForDay(_selectedDay);
    
    if (eventsForDay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FluentIcons.calendar, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No events for ${_getFormattedDate(_selectedDay)}',
              style: FluentTheme.of(context).typography.body?.copyWith(
                color: Colors.grey[100],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: eventsForDay.length,
      itemBuilder: (context, index) {
        final item = eventsForDay[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(item.title),
            leading: CircleAvatar(
              backgroundColor: item.color,
              child: Text(
                item.title.isNotEmpty ? item.title[0] : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(FluentIcons.clock),
                  onPressed: () => widget.onSetTime(item, _selectedDay),
                ),
                IconButton(
                  icon: const Icon(FluentIcons.edit),
                  onPressed: () => widget.onSelect(item),
                ),
              ],
            ),
            onPressed: () => widget.onSelect(item),
          ),
        );
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}