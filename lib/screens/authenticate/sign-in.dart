import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:primeform/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1100;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 80 : 20,
                    vertical: isWide ? 42 : 24,
                  ),
                  child: Column(
                    children: [
                      const _Header(),
                      SizedBox(height: isWide ? 48 : 28),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: isWide
                            ? const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 7, child: _LeftContent()),
                                  SizedBox(width: 40),
                                  Expanded(flex: 5, child: _LoginCard()),
                                ],
                              )
                            : const Column(
                                children: [
                                  _LeftContent(),
                                  SizedBox(height: 22),
                                  _LoginCard(),
                                ],
                              ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A0D14), Color(0xFF0A0D14), Color(0xFF0E1118)],
            ),
          ),
        ),
        // Subtle vignette / spotlight
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.35),
                radius: 1.15,
                colors: [
                  Color(0x331DA1FF), // light blue glow
                  Color(0x00000000),
                  Color(0xCC000000),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo + name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo2-contexto-transp.png', height: 100),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Transformando la manera en que los clubes cuidan la salud\n'
          'y potencian el rendimiento de sus deportistas.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.5,
            color: Color(0xFFCFD6E4),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LeftContent extends StatelessWidget {
  const _LeftContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seguimiento médico y deportivo profesional',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Centralizá toda la información médico-deportiva de tu plantel.\n'
          'Lesiones, evaluaciones físicas, rehabilitaciones y rendimiento en una sola\n'
          'plataforma.',
          style: TextStyle(
            fontSize: 14,
            height: 1.55,
            color: Color(0xFFB7C0D3),
          ),
        ),
        const SizedBox(height: 22),

        // Feature cards (2x2)
        LayoutBuilder(
          builder: (context, c) {
            final isNarrow = c.maxWidth < 700;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: isNarrow ? double.infinity : (c.maxWidth - 16) / 2,
                  child: const _FeatureTile(
                    title: 'Gestión integral',
                    subtitle:
                        'Seguimiento completo del estado físico y\nmédico',
                  ),
                ),
                SizedBox(
                  width: isNarrow ? double.infinity : (c.maxWidth - 16) / 2,
                  child: const _FeatureTile(
                    title: 'Múltiples roles',
                    subtitle:
                        'Acceso diferenciado para médicos,\nkinesiólogos y jugadores',
                  ),
                ),
                SizedBox(
                  width: isNarrow ? double.infinity : (c.maxWidth - 16) / 2,
                  child: const _FeatureTile(
                    title: 'Datos en tiempo real',
                    subtitle: 'Métricas GPS y seguimiento de\nrendimiento',
                  ),
                ),
                SizedBox(
                  width: isNarrow ? double.infinity : (c.maxWidth - 16) / 2,
                  child: const _FeatureTile(
                    title: 'IA integrada',
                    subtitle: 'Asistente virtual para consultas inteligentes',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FeatureTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121826).withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.35,
              color: Color(0xFF9EABC6),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatefulWidget {
  const _LoginCard();

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  bool _obscure = true;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _loading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1422).withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                Divider(color: Colors.white.withOpacity(0.08), height: 1),
                const SizedBox(height: 16),

                if ((_errorMessage ?? '').trim().isNotEmpty)
                  _ErrorBanner(text: _errorMessage!),

                const SizedBox(height: 14),
                const _FieldLabel('Email'),
                const SizedBox(height: 8),

                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'usuario@gmail.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() => email = value.trim()),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Ingresá tu email';
                    if (!value.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),

                const SizedBox(height: 14),
                const _FieldLabel('Contraseña'),
                const SizedBox(height: 8),

                TextFormField(
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    suffixIcon: IconButton(
                      tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() => password = value),
                  obscureText: _obscure,
                  validator: (v) {
                    final value = (v ?? '');
                    if (value.isEmpty) return 'Ingresá tu contraseña';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),

                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _loading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            setState(() => _errorMessage = null);

                            if (!_formKey.currentState!.validate()) return;

                            setState(() => _loading = true);
                            try {
                              final user = await _auth
                                  .signInWithEmailAndPassword(email, password);

                              if (user == null) {
                                setState(() {
                                  _errorMessage =
                                      'No se pudo iniciar sesión. Intentá nuevamente.';
                                });
                              }

                              // ✅ NO hacemos Navigator acá.
                              // Si usás Wrapper + StreamProvider, al loguear te manda solo al Dashboard.
                            } on Exception catch (e) {
                              setState(() {
                                _errorMessage = _friendlyFirebaseError(e);
                              });
                            } finally {
                              if (mounted) setState(() => _loading = false);
                            }
                          },
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Iniciar sesión',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                ),

                const SizedBox(height: 14),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB7C0D3),
                  ),
                  child: const Text(
                    '¿Necesitas acceso? Contacta al administrador del sistema',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _friendlyFirebaseError(Object e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'Email inválido.';
        case 'user-disabled':
          return 'La cuenta está deshabilitada.';
        case 'user-not-found':
          return 'No existe una cuenta con ese email.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        case 'invalid-credential':
          return 'Credenciales inválidas.';
        case 'network-request-failed':
          return 'Problema de red. Revisá tu conexión.';
        default:
          return 'Error al iniciar sesión: ${e.message ?? e.code}';
      }
    }

    final msg = e.toString();
    if (msg.contains('user-not-found'))
      return 'No existe una cuenta con ese email.';
    if (msg.contains('wrong-password')) return 'Contraseña incorrecta.';
    if (msg.contains('network')) return 'Problema de red. Revisá tu conexión.';
    return 'Error al iniciar sesión.';
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;
  const _ErrorBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1116).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB3261E).withOpacity(0.55)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.white.withOpacity(0.85),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFFE6E9F2)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFFD9DEEA),
        ),
      ),
    );
  }
}

// (te lo dejo como lo tenías, por si lo usás después)
class _StyledTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _StyledTextField({
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13.5),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF95A2BF)),
        filled: true,
        fillColor: const Color(0xFF223044).withOpacity(0.85),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1DA1FF), width: 1.2),
        ),
        suffixIcon: suffix,
      ),
    );
  }
}
