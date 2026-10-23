import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/friends/data/friends_repository.dart';
import 'package:pracby_mobile/features/friends/data/models/friendship_model.dart';
import 'package:pracby_mobile/features/friends/presentation/providers/friends_provider.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arkadaşlar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Arkadaşlarım'),
            Tab(text: 'İstekler'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddFriendDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsList(),
          _buildRequestsList(),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    final friendsAsync = ref.watch(friendsProvider);

    return friendsAsync.when(
      loading: () => const PbLoading(message: 'Yükleniyor...'),
      error: (e, _) => Center(child: Text(userErrorMessage(e, 'Yüklenemedi. Tekrar dene.'))),
      data: (friends) {
        if (friends.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline, size: 64, color: AppColors.grey300),
                SizedBox(height: 16),
                Text(
                  'Henüz arkadaşın yok',
                  style: TextStyle(color: AppColors.grey500, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Kullanıcı adı ile arkadaş ekle',
                  style: TextStyle(color: AppColors.grey400, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: friends.length,
          itemBuilder: (context, index) =>
              _buildFriendCard(friends[index]),
        );
      },
    );
  }

  Widget _buildRequestsList() {
    final requestsAsync = ref.watch(friendRequestsProvider);

    return requestsAsync.when(
      loading: () => const PbLoading(message: 'Yükleniyor...'),
      error: (e, _) => Center(child: Text(userErrorMessage(e, 'Yüklenemedi. Tekrar dene.'))),
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Text(
              'Bekleyen istek yok',
              style: TextStyle(color: AppColors.grey500, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) =>
              _buildRequestCard(requests[index]),
        );
      },
    );
  }

  Widget _buildFriendCard(FriendshipModel friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: friend.avatarUrl != null
              ? NetworkImage(friend.avatarUrl!)
              : null,
          child: friend.avatarUrl == null
              ? Text(
                  (friend.username ?? '?')[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        title: Text(
          friend.username ?? 'Kullanıcı',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.person_remove, color: AppColors.error),
          onPressed: () => _removeFriend(friend.id),
        ),
      ),
    );
  }

  Widget _buildRequestCard(FriendshipModel request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: request.avatarUrl != null
              ? NetworkImage(request.avatarUrl!)
              : null,
          child: request.avatarUrl == null
              ? Text(
                  (request.username ?? '?')[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        title: Text(
          request.username ?? 'Kullanıcı',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: AppColors.success),
              onPressed: () => _respondToRequest(request.id, 'accept'),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: AppColors.error),
              onPressed: () => _respondToRequest(request.id, 'reject'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Arkadaş Ekle'),
        content: TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            hintText: 'Kullanıcı adı gir',
            prefixIcon: Icon(Icons.person_search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              final username = _usernameController.text.trim();
              if (username.isNotEmpty) {
                _sendFriendRequest(username);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendFriendRequest(String username) async {
    try {
      await ref
          .read(friendsRepositoryProvider)
          .sendRequest(username: username);
      _usernameController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arkadaşlık isteği gönderildi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _sendRequestErrors[e is ApiException ? e.message : null] ??
                  userErrorMessage(e, 'İstek gönderilemedi. Tekrar dene.'),
            ),
          ),
        );
      }
    }
  }

  /// The API's English `POST /friends/request` errors, in Turkish.
  static const _sendRequestErrors = {
    'User not found': 'Bu kullanıcı adıyla kimse bulunamadı.',
    'Cannot send friend request to yourself': 'Kendine istek gönderemezsin.',
    'Already friends': 'Zaten arkadaşsınız.',
    'Friend request already exists': 'Bu kişiyle zaten bekleyen bir istek var.',
  };

  Future<void> _respondToRequest(String id, String action) async {
    try {
      await ref
          .read(friendsRepositoryProvider)
          .respondToRequest(id: id, action: action);
      ref.invalidate(friendRequestsProvider);
      ref.invalidate(friendsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userErrorMessage(e, 'İşlem başarısız. Tekrar dene.')),
          ),
        );
      }
    }
  }

  Future<void> _removeFriend(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Arkadaşı Sil'),
        content: const Text('Bu kişiyi arkadaş listenden çıkarmak istiyor musun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await ref.read(friendsRepositoryProvider).removeFriend(id);
        ref.invalidate(friendsProvider);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userErrorMessage(e, 'Arkadaş silinemedi. Tekrar dene.')),
            ),
          );
        }
      }
    }
  }
}
