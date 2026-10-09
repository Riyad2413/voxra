import 'package:flutter/material.dart';

void main() => runApp(const VoxraApp());

const purple = Color(0xFF8B5CF6);
const background = Color(0xFF0B0B12);
const panel = Color(0xFF171722);

class VoxraApp extends StatelessWidget {
  const VoxraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voxra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void continueToApp() {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email/username ও password দিন।')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(username: email.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.graphic_eq_rounded, size: 76, color: purple),
                  const SizedBox(height: 22),
                  const Text(
                    'Welcome to Voxra',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect with people through voice.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email or username',
                      prefixIcon: Icon(Icons.person_outline),
                      filled: true,
                      fillColor: panel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: password,
                    obscureText: hidePassword,
                    onSubmitted: (_) => continueToApp(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => hidePassword = !hidePassword),
                        icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                      filled: true,
                      fillColor: panel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: continueToApp,
                      style: FilledButton.styleFrom(backgroundColor: purple),
                      child: const Text('Continue'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Demo login only. No account data is sent to a server.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Friend {
  const Friend(this.name, this.handle, this.online, this.color);
  final String name;
  final String handle;
  final bool online;
  final Color color;
}

const friends = <Friend>[
  Friend('Arian', '@arian', true, Color(0xFFEC4899)),
  Friend('Nabil', '@nabil', true, Color(0xFF06B6D4)),
  Friend('Samiha', '@samiha', false, Color(0xFFF59E0B)),
  Friend('Rafi', '@rafi', true, Color(0xFF22C55E)),
  Friend('Tanvir', '@tanvir', false, Color(0xFF818CF8)),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.username});
  final String username;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final search = TextEditingController();
  int tab = 0;

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = friends.where((f) {
      final q = search.text.toLowerCase().trim();
      return f.name.toLowerCase().contains(q) || f.handle.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.graphic_eq_rounded, color: purple),
            SizedBox(width: 8),
            Text('Voxra', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Profile'),
                content: Text('Signed in as ${widget.username}'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                ],
              ),
            ),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 6),
            child: Text('People', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text('Find someone and start a voice call.', style: TextStyle(color: Colors.white70)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search people',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: panel,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No people found'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final f = filtered[index];
                      return Card(
                        color: panel,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: f.color.withValues(alpha: 0.2),
                            child: Text(f.name.substring(0, 1), style: TextStyle(color: f.color)),
                          ),
                          title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text('${f.handle} • ${f.online ? "Online" : "Offline"}'),
                          trailing: IconButton.filled(
                            tooltip: 'Open demo call',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (_) => CallScreen(friend: f)),
                            ),
                            style: IconButton.styleFrom(backgroundColor: purple),
                            icon: const Icon(Icons.call),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) {
          setState(() => tab = index);
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(index == 1 ? 'Messages screen coming later.' : 'Settings screen coming later.')),
            );
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'People'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  const CallScreen({super.key, required this.friend});
  final Friend friend;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool muted = false;
  bool speaker = false;
  String effect = 'Normal';
  static const effects = ['Normal', 'Deep', 'Robot', 'Echo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice call'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              CircleAvatar(
                radius: 58,
                backgroundColor: widget.friend.color.withValues(alpha: 0.2),
                child: Text(
                  widget.friend.name.substring(0, 1),
                  style: TextStyle(color: widget.friend.color, fontSize: 48, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 18),
              Text(widget.friend.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Demo call screen', style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Voice effect', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: effects.map((e) => ChoiceChip(
                        label: Text(e),
                        selected: effect == e,
                        onSelected: (_) => setState(() => effect = e),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    const Text('Visual demo only; live audio effects are not connected.', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  callButton(muted ? Icons.mic_off : Icons.mic, muted ? 'Unmute' : 'Mute', muted, () => setState(() => muted = !muted)),
                  callButton(speaker ? Icons.volume_up : Icons.volume_down, 'Speaker', speaker, () => setState(() => speaker = !speaker)),
                  callButton(Icons.call_end, 'End', false, () => Navigator.of(context).pop(), color: Colors.redAccent),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget callButton(IconData icon, String label, bool active, VoidCallback onPressed, {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 26,
          style: IconButton.styleFrom(
            backgroundColor: color ?? (active ? purple : panel),
            foregroundColor: Colors.white,
            minimumSize: const Size(60, 60),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
