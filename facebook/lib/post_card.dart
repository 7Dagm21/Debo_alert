import 'package:flutter/material.dart';
import 'design_system.dart';

class PostCard extends StatelessWidget {
  final String name;
  final String time;
  final String content;
  final String? imageUrl;
  final String avatarUrl;
  final bool isAsset;
  final bool isAvatarAsset;

  const PostCard({
    required this.name,
    required this.time,
    required this.content,
    required this.avatarUrl,
    this.imageUrl,
    this.isAsset = false,
    this.isAvatarAsset = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: FBColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: isAvatarAsset
                      ? AssetImage(avatarUrl) as ImageProvider
                      : NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: FBText.postName),
                      Row(
                        children: [
                          Text(time, style: FBText.postTime),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.public,
                            size: 12,
                            color: FBColors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: FBColors.grey),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Text(content, style: FBText.body),
          ),
          if (imageUrl != null)
            isAsset
                ? Image.asset(
                    imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          const Divider(height: 1, color: FBColors.offWhite),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.thumb_up_alt_outlined,
                  text: 'Like',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You liked this post!')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.comment_outlined,
                  text: 'Comment',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comment clicked!')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  text: 'Share',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share clicked!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.text, this.onTap});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  Color get _activeColor => _isPressed
      ? FBColors.blue.withOpacity(0.2)
      : _isHovered
      ? FBColors.blue.withOpacity(0.1)
      : Colors.transparent;

  Color get _iconColor =>
      _isPressed || _isHovered ? FBColors.blue : FBColors.grey;
  TextStyle get _textStyle => FBText.actionButton.copyWith(
    color: _isPressed || _isHovered ? FBColors.blue : FBColors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: _activeColor,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: _iconColor),
              const SizedBox(width: 6),
              Text(widget.text, style: _textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
