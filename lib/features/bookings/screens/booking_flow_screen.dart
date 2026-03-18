import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';
import 'package:legalhelp_kz/providers/providers.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final String lawyerId;
  const BookingFlowScreen({super.key, required this.lawyerId});

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int _step = 0;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  ConsultationType _consultationType = ConsultationType.online;

  final _times = ['09:00', '10:00', '11:00', '12:00', '14:00', '15:00', '16:00', '17:00'];

  @override
  Widget build(BuildContext context) {
    final lawyerAsync = ref.watch(lawyerProfileProvider(widget.lawyerId));

    return lawyerAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: EmptyState(icon: '⚠️', title: 'Ошибка загрузки', subtitle: err.toString()),
      ),
      data: (lawyer) {
        if (lawyer == null) {
          return const Scaffold(
            backgroundColor: AppColors.primaryBackground,
            body: EmptyState(icon: '😕', title: 'Юрист не найден', subtitle: 'Возможно профиль был удален.'),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: CustomAppBar(title: 'Запись к юристу'),
          body: Column(
            children: [
              // Progress steps
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: List.generate(3, (i) {
                final done = i < _step;
                final active = i == _step;
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: done ? AppColors.success : active ? AppColors.gold : AppColors.secondaryBackground,
                          shape: BoxShape.circle,
                          border: Border.all(color: done ? AppColors.success : active ? AppColors.gold : AppColors.border),
                        ),
                        child: Center(child: done
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : Text('${i + 1}', style: TextStyle(color: active ? AppColors.primaryBackground : AppColors.textTertiary, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter'))),
                      ),
                      if (i < 2) Expanded(child: Container(height: 2, color: done ? AppColors.success : AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 4))),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _step == 0
                  ? _DateStep(
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                      times: _times,
                      onDateChanged: (d) => setState(() => _selectedDate = d),
                      onTimeChanged: (t) => setState(() => _selectedTime = t),
                    )
                  : _step == 1
                      ? _TypeStep(
                          type: _consultationType,
                          onChanged: (t) => setState(() => _consultationType = t),
                        )
                      : _ConfirmStep(lawyer: lawyer, date: _selectedDate, time: _selectedTime!, type: _consultationType),
            ),
          ),
          // Bottom buttons
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
            decoration: const BoxDecoration(color: AppColors.secondaryBackground, border: Border(top: BorderSide(color: AppColors.border, width: 0.5))),
            child: Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GoldButton(text: 'Назад', isOutlined: true, onTap: () => setState(() => _step--)),
                    ),
                  ),
                Expanded(
                  child: GoldButton(
                    text: _step == 2 ? 'Перейти к оплате' : 'Далее',
                    onTap: () {
                      if (_step == 0 && _selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Выберите время')));
                        return;
                      }
                      if (_step < 2) {
                        setState(() => _step++);
                      } else {
                        final parts = _selectedTime!.split(':');
                        final dt = DateTime(
                          _selectedDate.year, _selectedDate.month, _selectedDate.day,
                          int.parse(parts[0]), int.parse(parts[1]),
                        );
                        final typeStr = _consultationType == ConsultationType.online ? 'online' : 
                                        _consultationType == ConsultationType.phone ? 'phone' : 'inPerson';
                        
                        context.push('${AppRoutes.payment}?lawyerId=${widget.lawyerId}&price=${lawyer.price}&date=${dt.toIso8601String()}&type=$typeStr');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

class _DateStep extends StatelessWidget {
  final DateTime selectedDate;
  final String? selectedTime;
  final List<String> times;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onTimeChanged;

  const _DateStep({required this.selectedDate, required this.selectedTime, required this.times, required this.onDateChanged, required this.onTimeChanged});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dates = List.generate(14, (i) => now.add(Duration(days: i + 1)));
    final dayNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final monthNames = ['янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Выберите дату', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        const SizedBox(height: 14),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (_, i) {
              final d = dates[i];
              final sel = d.day == selectedDate.day && d.month == selectedDate.month;
              return GestureDetector(
                onTap: () => onDateChanged(d),
                child: Container(
                  width: 56,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dayNames[d.weekday - 1], style: TextStyle(color: sel ? AppColors.gold : AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
                      const SizedBox(height: 4),
                      Text('${d.day}', style: TextStyle(color: sel ? AppColors.gold : AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                      Text(monthNames[d.month - 1], style: TextStyle(color: sel ? AppColors.gold : AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text('Выберите время', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.0),
          itemCount: times.length,
          itemBuilder: (_, i) {
            final t = times[i];
            final sel = t == selectedTime;
            return GestureDetector(
              onTap: () => onTimeChanged(t),
              child: Container(
                decoration: BoxDecoration(
                  color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                ),
                child: Center(child: Text(t, style: TextStyle(color: sel ? AppColors.gold : AppColors.textPrimary, fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontFamily: 'Inter'))),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TypeStep extends StatelessWidget {
  final ConsultationType type;
  final ValueChanged<ConsultationType> onChanged;
  const _TypeStep({required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final types = [
      (ConsultationType.online, '💻', 'Онлайн', 'Видеозвонок'),
      (ConsultationType.phone, '📞', 'По телефону', 'Аудиозвонок'),
      (ConsultationType.inPerson, '🏛️', 'Очно', 'В офисе юриста'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Тип консультации', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        const SizedBox(height: 14),
        ...types.map((t) {
          final sel = t.$1 == type;
          return GestureDetector(
            onTap: () => onChanged(t.$1),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sel ? AppColors.gold : AppColors.border),
              ),
              child: Row(
                children: [
                  Text(t.$2, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.$3, style: TextStyle(color: sel ? AppColors.gold : AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        Text(t.$4, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
                      ],
                    ),
                  ),
                  if (sel) const Icon(Icons.check_circle, color: AppColors.gold, size: 22),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ConfirmStep extends StatelessWidget {
  final Lawyer lawyer;
  final DateTime date;
  final String time;
  final ConsultationType type;
  const _ConfirmStep({required this.lawyer, required this.date, required this.time, required this.type});

  @override
  Widget build(BuildContext context) {
    final dayNames = ['', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final monthNames = ['', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Подтверждение', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(
            children: [
              _ConfirmRow(label: 'Юрист', value: lawyer.name),
              const Divider(color: AppColors.border, height: 20),
              _ConfirmRow(label: 'Дата', value: '${dayNames[date.weekday]}, ${date.day} ${monthNames[date.month]}'),
              const Divider(color: AppColors.border, height: 20),
              _ConfirmRow(label: 'Время', value: time),
              const Divider(color: AppColors.border, height: 20),
              _ConfirmRow(label: 'Тип', value: ConsultationTypeHelper.label(type)),
              const Divider(color: AppColors.border, height: 20),
              _ConfirmRow(label: 'Стоимость', value: '${lawyer.price} ₸', isGold: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.borderGold, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
          child: const Row(
            children: [
              Text('ℹ️', style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Expanded(child: Text('После подтверждения юрист получит уведомление и свяжется с вами', style: TextStyle(color: AppColors.gold, fontSize: 12, fontFamily: 'Inter', height: 1.4))),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label, value;
  final bool isGold;
  const _ConfirmRow({required this.label, required this.value, this.isGold = false});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter')),
      const Spacer(),
      Text(value, style: TextStyle(color: isGold ? AppColors.gold : AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
    ],
  );
}

extension ConsultationTypeHelper on ConsultationType {
  static String label(ConsultationType t) {
    switch (t) {
      case ConsultationType.online: return 'Онлайн';
      case ConsultationType.phone: return 'По телефону';
      case ConsultationType.inPerson: return 'Очно';
    }
  }
}
