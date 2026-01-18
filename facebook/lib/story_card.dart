import 'package:flutter/material.dart';
import 'design_system.dart';

class StoryCard extends StatelessWidget {
  final String imageUrl;
  final String avatarUrl;
  final String name;
  final bool isMe;
  final bool isAsset;
  final bool isAvatarAsset;

  const StoryCard({
    required this.imageUrl,
    required this.avatarUrl,
    required this.name,
    this.isMe = false,
    this.isAsset = false,
    this.isAvatarAsset = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(left: 8, top: 12, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: isAsset ? AssetImage(imageUrl) as ImageProvider : NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          Position(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: FBColors.blue,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: isAvatarAsset 
                    ? AssetImage(avatarUrl) as ImageProvider 
                    : NetworkImage(avatarUrl),
              ),
            ),
          ),
          Position(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class Position extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Widget child;

  const Position({this.top, this.left, this.right, this.bottom, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(top: top, left: left, right: right, bottom: bottom, child: child);
  }
}
