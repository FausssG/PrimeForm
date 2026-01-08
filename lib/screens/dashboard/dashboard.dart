import 'dart:math';

import 'package:flutter/material.dart';
import 'package:primeform/services/auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  // --- Datos mock (después los conectás a Firestore) ---
  final kpis = const [
    _KpiData(
      title: 'Total Jugadores',
      value: '8',
      delta: '+2 este mes',
      tone: _Tone.good,
      icon: Icons.group_outlined,
    ),
    _KpiData(
      title: 'Lesiones Activas',
      value: '2',
      delta: '-2 vs semana anterior',
      tone: _Tone.bad,
      icon: Icons.monitor_heart_outlined,
    ),
    _KpiData(
      title: 'En Recuperación',
      value: '4',
      delta: '+3 esta semana',
      tone: _Tone.warn,
      icon: Icons.shield_outlined,
    ),
    _KpiData(
      title: 'Rendimiento Promedio',
      value: '74%',
      delta: '+5% vs mes anterior',
      tone: _Tone.good,
      icon: Icons.bolt_outlined,
    ),
  ];

  final lesionesMes = const [
    _BarPoint(label: 'Ene', value: 4),
    _BarPoint(label: 'Feb', value: 3),
    _BarPoint(label: 'Mar', value: 7),
    _BarPoint(label: 'Abr', value: 2),
    _BarPoint(label: 'May', value: 5),
    _BarPoint(label: 'Jun', value: 2),
  ];

  final rendimientoSemanal = const [
    _LinePoint(label: 'Lun', value: 88),
    _LinePoint(label: 'Mar', value: 80),
    _LinePoint(label: 'Mié', value: 92),
    _LinePoint(label: 'Jue', value: 90),
    _LinePoint(label: 'Vie', value: 96),
    _LinePoint(label: 'Sáb', value: 91),
    _LinePoint(label: 'Dom', value: 86),
  ];

  final tiposLesion = const [
    _PieSlice(label: 'Muscular', value: 3, color: Color(0xFFDC3545)),
    _PieSlice(label: 'Articular', value: 1, color: Color(0xFFFFC107)),
    _PieSlice(label: 'Traumática', value: 1, color: Color(0xFF1F2A3A)),
  ];

  final alertas = const [
    _AlertItem(
      title: 'Paulo Dybala - Lesión muscular grado 2',
      time: 'hace 10 min',
    ),
    _AlertItem(
      title: 'Control médico pendiente - 3 jugadores',
      time: 'hace 1 hora',
    ),
    _AlertItem(
      title: 'Sesión de recuperación completada',
      time: 'hace 2 horas',
    ),
  ];

  final eventos = const [
    _EventItem(
      title: 'Control médico semanal',
      when: 'Hoy 14:00',
      countLabel: '8 jugadores',
    ),
    _EventItem(
      title: 'Evaluación física',
      when: 'Mañana 09:00',
      countLabel: '15 jugadores',
    ),
    _EventItem(
      title: 'Sesión de recuperación',
      when: 'Mañana 16:00',
      countLabel: '4 jugadores',
    ),
  ];

  final jugadores = const [
    _PlayerCard(
      name: 'Lionel Messi',
      role: 'DEL',
      initials: 'LM',
      status: _PlayerStatus.active,
      pct: 92,
    ),
    _PlayerCard(
      name: 'Dani Alves.',
      role: 'DEF',
      initials: 'DA',
      status: _PlayerStatus.recovery,
    ),
    _PlayerCard(
      name: 'Angel Di Maria',
      role: 'MED',
      initials: 'ADM',
      status: _PlayerStatus.injured,
    ),
    _PlayerCard(
      name: 'Emiliano Martinez',
      role: 'ARQ',
      initials: 'EM',
      status: _PlayerStatus.active,
      pct: 85,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: Row(
        children: [
          _Sidebar(
            selectedIndex: _selectedIndex,
            onSelect: (i) => setState(() => _selectedIndex = i),
            onLogout: () async => AuthService().signOut(),
          ),
          Expanded(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 1100;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 28 : 16,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopBar(onSchedule: () {}),
                        const SizedBox(height: 14),
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Resumen general del estado del plantel',
                          style: TextStyle(color: Color(0xFFB7C0D3)),
                        ),
                        const SizedBox(height: 18),

                        // KPI row
                        _KpiGrid(items: kpis),
                        const SizedBox(height: 18),

                        // Charts row
                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: _AppCard(
                                      title: 'Lesiones por Mes',
                                      subtitle:
                                          'Evolución de lesiones en los últimos 6 meses',
                                      child: _BarChart(points: lesionesMes),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 7,
                                    child: _AppCard(
                                      title: 'Rendimiento Semanal',
                                      subtitle:
                                          'Promedio de rendimiento del plantel',
                                      child: _LineChart(
                                        points: rendimientoSemanal,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _AppCard(
                                    title: 'Lesiones por Mes',
                                    subtitle:
                                        'Evolución de lesiones en los últimos 6 meses',
                                    child: _BarChart(points: lesionesMes),
                                  ),
                                  const SizedBox(height: 16),
                                  _AppCard(
                                    title: 'Rendimiento Semanal',
                                    subtitle:
                                        'Promedio de rendimiento del plantel',
                                    child: _LineChart(
                                      points: rendimientoSemanal,
                                    ),
                                  ),
                                ],
                              ),

                        const SizedBox(height: 16),

                        // 3 cards row (pie / alerts / events)
                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _AppCard(
                                      title: 'Tipos de Lesiones',
                                      subtitle: 'Distribución actual',
                                      child: _PiePanel(slices: tiposLesion),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _AppCard(
                                      title: 'Alertas Recientes',
                                      subtitle:
                                          'Últimas notificaciones importantes',
                                      child: _AlertsList(items: alertas),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _AppCard(
                                      title: 'Próximos Eventos',
                                      subtitle:
                                          'Controles y evaluaciones programadas',
                                      child: _EventsList(items: eventos),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _AppCard(
                                    title: 'Tipos de Lesiones',
                                    subtitle: 'Distribución actual',
                                    child: _PiePanel(slices: tiposLesion),
                                  ),
                                  const SizedBox(height: 16),
                                  _AppCard(
                                    title: 'Alertas Recientes',
                                    subtitle:
                                        'Últimas notificaciones importantes',
                                    child: _AlertsList(items: alertas),
                                  ),
                                  const SizedBox(height: 16),
                                  _AppCard(
                                    title: 'Próximos Eventos',
                                    subtitle:
                                        'Controles y evaluaciones programadas',
                                    child: _EventsList(items: eventos),
                                  ),
                                ],
                              ),

                        const SizedBox(height: 16),

                        _AppCard(
                          title: 'Estado de Jugadores',
                          subtitle: 'Resumen del estado actual del plantel',
                          child: _PlayersRow(items: jugadores),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------- UI: Sidebar ----------------------------- */

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E1118);
    const border = Color(0xFF1B2230);

    final items = const [
      _NavItem(Icons.dashboard_outlined, 'Dashboard'),
      _NavItem(Icons.groups_outlined, 'Jugadores'),
      _NavItem(Icons.healing_outlined, 'Lesiones'),
      _NavItem(Icons.fitness_center_outlined, 'Rehabilitación'),
      _NavItem(Icons.medical_information_outlined, 'Historial Médico'),
      _NavItem(Icons.monitor_heart_outlined, 'Historial Kinésico'),
      _NavItem(Icons.show_chart_outlined, 'Rendimiento'),
      _NavItem(Icons.forum_outlined, 'Comunicación'),
      _NavItem(Icons.auto_awesome_outlined, 'Asistente IA'),
      _NavItem(Icons.description_outlined, 'Reportes'),
      _NavItem(Icons.settings_outlined, 'Configuración'),
    ];

    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: bg,
        border: Border(right: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                // Logo placeholder (poné tu asset si querés)
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF121826),
                  child: Icon(
                    Icons.shield_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'PrimeForm',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF1B2230), height: 1),

          // Perfil
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFF7C948),
                  child: Text(
                    'TP',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tiago Pieroni',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 6),
                      _Pill(text: 'Administrador', tone: _Tone.warn),
                    ],
                  ),
                ),
                Stack(
                  children: const [
                    Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white70,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text('3', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF1B2230), height: 1),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final it = items[i];
                final selected = i == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  child: Material(
                    color: selected
                        ? const Color(0xFF141B28)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onSelect(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              it.icon,
                              color: selected ? Colors.white : Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                it.label,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(color: Color(0xFF1B2230), height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _SidebarButton(
                  icon: Icons.person_outline,
                  label: 'Mi Perfil',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _SidebarButton(
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  danger: true,
                  onTap: onLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;
  final VoidCallback onTap;

  const _SidebarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF121826),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: danger ? const Color(0xFFFF4D4D) : Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: danger ? const Color(0xFFFF4D4D) : Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

/* ----------------------------- UI: Top bar ----------------------------- */

class _TopBar extends StatelessWidget {
  final VoidCallback onSchedule;
  const _TopBar({required this.onSchedule});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        const _Pill(text: 'Administrador', tone: _Tone.warn),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: onSchedule,
          icon: const Icon(Icons.calendar_month_outlined, size: 18),
          label: const Text('Programar control'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

/* ----------------------------- UI: Cards ----------------------------- */

class _AppCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _AppCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1420),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFFB7C0D3), fontSize: 12.5),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/* ----------------------------- KPI Grid ----------------------------- */

class _KpiGrid extends StatelessWidget {
  final List<_KpiData> items;
  const _KpiGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final width = c.maxWidth;
        int cols = 4;
        if (width < 900) cols = 2;
        if (width < 520) cols = 1;

        final gap = 14.0;
        final itemW = (width - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map(
                (k) => SizedBox(
                  width: itemW,
                  child: _KpiCard(data: k),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1420),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Icon(data.icon, size: 18, color: Colors.white60),
                  ],
                ),
                const Spacer(),
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: _toneColor(data.tone),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.delta,
                  style: TextStyle(
                    fontSize: 12,
                    color: _toneColor(data.tone).withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiData {
  final String title;
  final String value;
  final String delta;
  final _Tone tone;
  final IconData icon;
  const _KpiData({
    required this.title,
    required this.value,
    required this.delta,
    required this.tone,
    required this.icon,
  });
}

/* ----------------------------- Alerts / Events ----------------------------- */

class _AlertsList extends StatelessWidget {
  final List<_AlertItem> items;
  const _AlertsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (a) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF121826),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.report_gmailerrorred_outlined,
                    color: Color(0xFFDC3545),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: Colors.white54,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              a.time,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _EventsList extends StatelessWidget {
  final List<_EventItem> items;
  const _EventsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF121826),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.when,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1420),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Text(
                      e.countLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AlertItem {
  final String title;
  final String time;
  const _AlertItem({required this.title, required this.time});
}

class _EventItem {
  final String title;
  final String when;
  final String countLabel;
  const _EventItem({
    required this.title,
    required this.when,
    required this.countLabel,
  });
}

/* ----------------------------- Players Row ----------------------------- */

enum _PlayerStatus { active, recovery, injured }

class _PlayersRow extends StatelessWidget {
  final List<_PlayerCard> items;
  const _PlayersRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final isNarrow = c.maxWidth < 900;
        final cardW = isNarrow ? c.maxWidth : (c.maxWidth - 24) / 4;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (p) => SizedBox(
                  width: cardW,
                  child: _PlayerTile(p: p),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final _PlayerCard p;
  const _PlayerTile({required this.p});

  @override
  Widget build(BuildContext context) {
    final pill = switch (p.status) {
      _PlayerStatus.active => const _Pill(text: 'Activo', tone: _Tone.good),
      _PlayerStatus.recovery => const _Pill(
        text: 'Recuperación',
        tone: _Tone.warn,
      ),
      _PlayerStatus.injured => const _Pill(text: 'Lesionado', tone: _Tone.bad),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF121826),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF0F1420),
            child: Text(
              p.initials,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p.role,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    pill,
                    const Spacer(),
                    if (p.pct != null)
                      Text(
                        '${p.pct}%',
                        style: const TextStyle(
                          color: Color(0xFF3DDC84),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerCard {
  final String name;
  final String role;
  final String initials;
  final _PlayerStatus status;
  final int? pct;

  const _PlayerCard({
    required this.name,
    required this.role,
    required this.initials,
    required this.status,
    this.pct,
  });
}

/* ----------------------------- Charts ----------------------------- */

class _BarPoint {
  final String label;
  final double value;
  const _BarPoint({required this.label, required this.value});
}

class _BarChart extends StatelessWidget {
  final List<_BarPoint> points;
  const _BarChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: CustomPaint(painter: _BarChartPainter(points)),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<_BarPoint> points;
  _BarChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0F1420);
    canvas.drawRect(Offset.zero & size, bg);

    final padL = 28.0;
    final padR = 10.0;
    final padT = 14.0;
    final padB = 30.0;

    final chart = Rect.fromLTWH(
      padL,
      padT,
      size.width - padL - padR,
      size.height - padT - padB,
    );

    // grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * (i / 4);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    // bars
    final maxV = points
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final barW = chart.width / (points.length * 1.35);
    final gap = (chart.width - barW * points.length) / (points.length + 1);

    final barPaint = Paint()..color = const Color(0xFFDC3545);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < points.length; i++) {
      final x = chart.left + gap + i * (barW + gap);
      final h = maxV == 0 ? 0 : (points[i].value / maxV) * chart.height;

      // labels
      textPainter.text = TextSpan(
        text: points[i].label,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barW - textPainter.width) / 2, chart.bottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LinePoint {
  final String label;
  final double value;
  const _LinePoint({required this.label, required this.value});
}

class _LineChart extends StatelessWidget {
  final List<_LinePoint> points;
  const _LineChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: CustomPaint(painter: _LineChartPainter(points)),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<_LinePoint> points;
  _LineChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0F1420);
    canvas.drawRect(Offset.zero & size, bg);

    final padL = 28.0;
    final padR = 10.0;
    final padT = 14.0;
    final padB = 30.0;

    final chart = Rect.fromLTWH(
      padL,
      padT,
      size.width - padL - padR,
      size.height - padT - padB,
    );

    // grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * (i / 4);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    // bounds
    final minV = points.map((e) => e.value).fold<double>(999999, min);
    final maxV = points.map((e) => e.value).fold<double>(0, max);
    final range = max(1.0, maxV - minV);

    final linePaint = Paint()
      ..color = const Color(0xFF1DA1FF).withOpacity(0.35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = Colors.white.withOpacity(0.85);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = chart.left + (chart.width) * (i / (points.length - 1));
      final yNorm = (points[i].value - minV) / range;
      final y = chart.bottom - yNorm * chart.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    // dots + labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < points.length; i++) {
      final x = chart.left + (chart.width) * (i / (points.length - 1));
      final yNorm = (points[i].value - minV) / range;
      final y = chart.bottom - yNorm * chart.height;

      canvas.drawCircle(Offset(x, y), 3.2, dotPaint);

      tp.text = TextSpan(
        text: points[i].label,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chart.bottom + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PieSlice {
  final String label;
  final double value;
  final Color color;
  const _PieSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _PiePanel extends StatelessWidget {
  final List<_PieSlice> slices;
  const _PiePanel({required this.slices});

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<double>(0, (a, b) => a + b.value);
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: CustomPaint(
            painter: _PiePainter(slices),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 12),
        ...slices.map((s) {
          final cases = s.value.toInt();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s.label,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '$cases casos',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 2),
        Text(
          'Total: ${total.toInt()}',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<_PieSlice> slices;
  _PiePainter(this.slices);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.33;

    final total = slices.fold<double>(0, (a, b) => a + b.value);
    if (total <= 0) return;

    double start = -pi / 2;
    for (final s in slices) {
      final sweep = (s.value / total) * 2 * pi;
      final p = Paint()
        ..color = s.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        p,
      );
      start += sweep;
    }

    // inner hole
    canvas.drawCircle(
      center,
      radius * 0.58,
      Paint()..color = const Color(0xFF0F1420),
    );
    // subtle ring
    canvas.drawCircle(
      center,
      radius * 1.02,
      Paint()
        ..color = Colors.white.withOpacity(0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* ----------------------------- Pills + helpers ----------------------------- */

enum _Tone { good, warn, bad, neutral }

Color _toneColor(_Tone t) {
  switch (t) {
    case _Tone.good:
      return const Color(0xFF3DDC84);
    case _Tone.warn:
      return const Color(0xFFFFC107);
    case _Tone.bad:
      return const Color(0xFFDC3545);
    case _Tone.neutral:
    default:
      return const Color(0xFFB7C0D3);
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final _Tone tone;
  const _Pill({required this.text, required this.tone});

  @override
  Widget build(BuildContext context) {
    final c = _toneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: 12),
      ),
    );
  }
}
