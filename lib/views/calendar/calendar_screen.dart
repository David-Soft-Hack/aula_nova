import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/daos.dart';
import '../../../providers/calendar_providers.dart';
import '../../../providers/career_providers.dart';
import '../../../providers/class_group_providers.dart';
import '../shared/app_input_decoration.dart';
import 'widgets/agenda_list.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/session_detail_dialog.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen>
    with SingleTickerProviderStateMixin {
  bool _isAgendaView = false;
  bool _showFilters = false;
  late final AnimationController _viewAnim;

  @override
  void initState() {
    super.initState();
    _viewAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _viewAnim.dispose();
    super.dispose();
  }

  void _setView(bool agenda) {
    if (_isAgendaView == agenda) return;
    setState(() => _isAgendaView = agenda);
    _viewAnim.forward(from: 0);
  }

  void _showSessionDetail(TodaySessionData session) {
    showDialog(
      context: context,
      builder: (_) => SessionDetailDialog(sessionData: session),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final activeMonth = ref.watch(activeMonthProvider);
    final calendarSessionsAsync = ref.watch(allCalendarSessionsProvider);
    final filteredSessions = calendarSessionsAsync.valueOrNull ?? [];

    final pendingCount = filteredSessions.where((s) => !s.entry.estadoImpartido).length;
    final evalCount = filteredSessions.where((s) => s.entry.esEvaluativa && !s.entry.estadoImpartido).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            _buildHeader(pendingCount, evalCount),

            // ── View selector ─────────────────────────────────────────────
            _buildViewSelector(),

            // ── Filters ───────────────────────────────────────────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: _showFilters ? _buildFiltersSection() : const SizedBox.shrink(),
            ),

            // ── Thin divider ──────────────────────────────────────────────
            Container(
              height: 1,
              color: Colors.grey.shade100,
            ),

            // ── Body ──────────────────────────────────────────────────────
            Expanded(
              child: calendarSessionsAsync.when(
                loading: () => _buildLoading(),
                error: (err, _) => _buildError(err),
                data: (_) => FadeTransition(
                  opacity: Tween<double>(begin: 0.7, end: 1.0).animate(
                    CurvedAnimation(parent: _viewAnim..forward(), curve: Curves.easeOut),
                  ),
                  child: _isAgendaView
                      ? AgendaList(onSessionTap: _showSessionDetail)
                      : CalendarGrid(
                          activeMonth: activeMonth,
                          selectedDate: selectedDate,
                          onDateSelected: (date) {
                            ref.read(selectedDateProvider.notifier).state = date;
                          },
                          onSessionTap: _showSessionDetail,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(int pendingCount, int evalCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.calendarDays,
                        size: 22, color: AppTheme.academic600),
                    const SizedBox(width: 8),
                    Text(
                      'Calendario Escolar',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Outfit',
                            color: const Color(0xFF0F172A),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    if (pendingCount > 0)
                      _HeaderStat(
                        label: '$pendingCount pendientes',
                        color: AppTheme.academic600,
                        bgColor: AppTheme.academic50,
                        icon: LucideIcons.clock,
                      ),
                    if (evalCount > 0)
                      _HeaderStat(
                        label: '$evalCount evaluaciones',
                        color: const Color(0xFFF97316),
                        bgColor: const Color(0xFFFFF7ED),
                        icon: LucideIcons.award,
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Filter button
          GestureDetector(
            onTap: () => setState(() => _showFilters = !_showFilters),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _showFilters ? AppTheme.academic600 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _showFilters
                    ? [
                        BoxShadow(
                          color: AppTheme.academic600.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Icon(
                _showFilters ? LucideIcons.filterX : LucideIcons.sliders,
                size: 18,
                color: _showFilters ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── View selector ────────────────────────────────────────────────────────────

  Widget _buildViewSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _ViewTab(
              icon: LucideIcons.grid,
              label: 'Mensual',
              active: !_isAgendaView,
              onTap: () => _setView(false),
            ),
            _ViewTab(
              icon: LucideIcons.list,
              label: 'Agenda',
              active: _isAgendaView,
              onTap: () => _setView(true),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filters section ──────────────────────────────────────────────────────────

  Widget _buildFiltersSection() {
    final filters = ref.watch(calendarFiltersProvider);
    final careersAsync = ref.watch(allCareersStreamProvider);
    final groupsAsync = ref.watch(allClassGroupsStreamProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.academic100),
        boxShadow: [
          BoxShadow(
            color: AppTheme.academic600.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.filter, size: 14, color: AppTheme.academic600),
              const SizedBox(width: 6),
              const Text(
                'Filtros',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.academic700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ref.read(calendarFiltersProvider.notifier).state =
                      const CalendarFiltersState();
                },
                child: Text(
                  'Limpiar',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: careersAsync.maybeWhen(
                  data: (careers) => DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: filters.career,
                    decoration: AppInputDecoration.build(
                      hintText: 'Programa',
                      prefixIcon: LucideIcons.graduationCap,
                      borderColor: Colors.grey.shade200,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ...careers.map((c) => DropdownMenuItem(
                            value: c.nombre,
                            child: Text(c.nombre),
                          )),
                    ],
                    onChanged: (val) {
                      ref.read(calendarFiltersProvider.notifier).state =
                          filters.copyWith(career: val, clearCareer: val == null);
                    },
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: groupsAsync.maybeWhen(
                  data: (groups) => DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: filters.groupCode,
                    decoration: AppInputDecoration.build(
                      hintText: 'Grupo',
                      prefixIcon: LucideIcons.users,
                      borderColor: Colors.grey.shade200,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ...groups.map((g) => DropdownMenuItem(
                            value: g.codigo,
                            child: Text('G. ${g.codigo}'),
                          )),
                    ],
                    onChanged: (val) {
                      ref.read(calendarFiltersProvider.notifier).state =
                          filters.copyWith(groupCode: val, clearGroup: val == null);
                    },
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              final current = filters.onlyPending ?? false;
              ref.read(calendarFiltersProvider.notifier).state =
                  filters.copyWith(onlyPending: !current, clearOnlyPending: current);
            },
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: (filters.onlyPending ?? false)
                        ? AppTheme.academic600
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: (filters.onlyPending ?? false)
                          ? AppTheme.academic600
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: (filters.onlyPending ?? false)
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Solo sesiones pendientes',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading / error states ────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.academic600,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando sesiones...',
            style: TextStyle(color: Colors.grey.shade500, fontFamily: 'Outfit'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.alertTriangle, size: 40, color: Color(0xFFF97316)),
          const SizedBox(height: 12),
          Text('Error al cargar: $err',
              style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _HeaderStat extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _HeaderStat({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ViewTab({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: active ? AppTheme.academic600 : Colors.grey.shade400,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13,
                    color: active ? AppTheme.academic700 : Colors.grey.shade500,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
