import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';
import 'package:ailook_flutter/presentation/providers/user/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuth = ref.watch(userAuthProvider);
    final userInfoAsync = ref.watch(userInfoProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MY PROFILE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: userInfoAsync.when(
        data: (profileResponse) {
          final profile = profileResponse?.profile;
          final nickname = profile?.nickname ?? userAuth?.displayName ?? 'Anonymous';
          final email = userAuth?.email ?? 'No email';
          final photoUrl = userAuth?.photoURL;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Header / Avatar
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                        child: photoUrl == null
                            ? const Icon(Icons.person_rounded, size: 50, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      nickname,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Info Section
              const Text(
                'Personal Info',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _InfoGrid(
                items: [
                  _InfoItem(label: 'Gender', value: profile?.gender ?? '-'),
                  _InfoItem(label: 'Age', value: profile?.age ?? '-'),
                  _InfoItem(label: 'Height', value: profile != null ? '${profile.height} cm' : '-'),
                  _InfoItem(label: 'Weight', value: profile != null ? '${profile.weight} kg' : '-'),
                ],
              ),
              const SizedBox(height: 40),

              // Actions
              const Text(
                'Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _ActionTile(
                icon: Icons.edit_note_rounded,
                label: 'Edit Profile',
                onTap: () {
                  const ProfileEditRoute().push(context);
                },
              ),
              _ActionTile(
                icon: Icons.logout_rounded,
                label: 'Sign Out',
                onTap: () async {
                  EasyLoading.show(status: 'Signing out...');
                  try {
                    await ref.read(userAuthProvider.notifier).signOut();
                    if (context.mounted) {
                      const SignInRoute().go(context);
                    }
                  } finally {
                    EasyLoading.dismiss();
                  }
                },
              ),
              _ActionTile(
                icon: Icons.person_remove_rounded,
                label: 'Delete Account',
                isDestructive: true,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    EasyLoading.show(status: 'Deleting account...');
                    try {
                      await ref.read(userAuthProvider.notifier).deleteAccount();
                      if (context.mounted) {
                        const SignInRoute().go(context);
                      }
                    } finally {
                      EasyLoading.dismiss();
                    }
                  }
                },
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: items,
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[50] : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : Colors.black, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}
