import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/chat_model.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/custom_text_field.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({
    super.key,
    required this.onOpenChat,
  });

  final ValueChanged<ChatConversation> onOpenChat;

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final _searchController = TextEditingController();
  String _filterQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final conversations = chatProvider.conversations.where((c) {
      if (_filterQuery.isEmpty) return true;
      final q = _filterQuery.toLowerCase();
      return c.otherUserName.toLowerCase().contains(q) ||
          c.outfitTitle.toLowerCase().contains(q) ||
          c.lastMessage.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your conversations',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 14),

              SearchInputField(
                controller: _searchController,
                hintText: 'Search chats or outfits...',
                onChanged: (val) => setState(() => _filterQuery = val.trim()),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: conversations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 44,
                              color: AppColors.mutedLight,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No conversations yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Reach out to owners from outfit details to chat!',
                              style: TextStyle(color: AppColors.muted, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: conversations.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, color: AppColors.border),
                        itemBuilder: (context, index) {
                          final conv = conversations[index];
                          final initials = conv.otherUserName.isNotEmpty
                              ? conv.otherUserName[0].toUpperCase()
                              : 'U';

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            onTap: () {
                              chatProvider.setActiveConversation(conv);
                              widget.onOpenChat(conv);
                            },
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.pink,
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (conv.unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: AppColors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  conv.otherUserName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  Formatters.formatTime(conv.lastMessageTime),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  conv.outfitTitle,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.red,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  conv.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: conv.unreadCount > 0
                                        ? AppColors.ink
                                        : AppColors.muted,
                                    fontWeight: conv.unreadCount > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
