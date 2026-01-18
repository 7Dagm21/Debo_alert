import 'package:flutter/material.dart';
import 'design_system.dart';
import 'post_card.dart';
import 'story_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FBColors.lightGrey,
      child: ListView(
        children: [
          _createPostSection(),
          const SizedBox(height: 10),
          _storiesSection(),
          const SizedBox(height: 10),
          const PostCard(
            name: 'Nature Lover',
            time: 'Just now',
            content: 'Look at this beautiful forest!',
            avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
            imageUrl:
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
            isAsset: false,
            isAvatarAsset: false,
          ),
          const PostCard(
            name: 'Explorer',
            time: '2 hrs ago',
            content: 'Mountain adventures!',
            avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
            imageUrl:
                'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=800&q=80',
            isAsset: false,
            isAvatarAsset: false,
          ),
          const PostCard(
            name: 'Jane Smith',
            time: '5 mins ago',
            content: 'Sunset by the lake. Peaceful and beautiful.',
            avatarUrl: 'https://randomuser.me/api/portraits/women/47.jpg',
            imageUrl:
                'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=800&q=80',
            isAsset: false,
            isAvatarAsset: false,
          ),
        ],
      ),
    );
  }

  Widget _createPostSection() {
    return Container(
      color: FBColors.white,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/dag.jpg'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: FBColors.offWhite),
                  ),
                  child: const Text(
                    "What's on your mind?",
                    style: TextStyle(color: FBColors.grey, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5, color: FBColors.offWhite),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: _Action(
                  icon: Icons.videocam,
                  text: 'Live',
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: _Action(
                  icon: Icons.photo_library,
                  text: 'Photo',
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: _Action(
                  icon: Icons.video_call,
                  text: 'Room',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _storiesSection() {
    return Container(
      height: 200,
      color: FBColors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 8),
        children: const [
          StoryCard(
            imageUrl: 'assets/images/daggg.jpg',
            avatarUrl: 'assets/images/dag.jpg',
            name: 'Dagi',
            isAsset: true,
            isAvatarAsset: true,
          ),
          StoryCard(
            imageUrl: 'assets/images/dag.jpg',
            avatarUrl: 'assets/images/maryam.jpg',
            name: 'Maryam',
            isAsset: true,
            isAvatarAsset: true,
          ),
          StoryCard(
            imageUrl: 'assets/images/daggg.jpg',
            avatarUrl: 'assets/images/maryam.jpg',
            name: 'Alex Berg',
            isAsset: true,
            isAvatarAsset: true,
          ),
          StoryCard(
            imageUrl: 'assets/images/dag.jpg',
            avatarUrl: 'assets/images/dag.jpg',
            name: 'Kirsten Dunbar',
            isAsset: true,
            isAvatarAsset: true,
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _Action({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: FBColors.grey,
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;

  const _CircleIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: FBColors.offWhite,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: FBColors.black, size: 22),
    );
  }
}
