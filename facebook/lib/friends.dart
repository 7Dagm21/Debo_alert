import 'package:flutter/material.dart';
import 'design_system.dart';
import 'widgets.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final people = [
      {
        'name': 'Barbara Schlüter',
        'image': 'https://randomuser.me/api/portraits/women/44.jpg',
      },
      {
        'name': 'Alvina Celina Bergström',
        'image': 'https://randomuser.me/api/portraits/women/45.jpg',
      },
      {
        'name': 'Kirsten Dunbar',
        'image': 'https://randomuser.me/api/portraits/women/46.jpg',
      },
      {
        'name': 'Bete Tesfaye',
        'image': 'https://randomuser.me/api/portraits/women/47.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: FBColors.white,
      appBar: AppBar(
        backgroundColor: FBColors.white,
        elevation: 0,
        title: const Text(
          'Friends',
          style: TextStyle(
            color: FBColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          CircleIconButton(icon: Icons.search),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _pillTab('Suggestions', true),
                const SizedBox(width: 10),
                _pillTab('Your Friends', false),
              ],
            ),
          ),
          const Divider(thickness: 0.5, color: FBColors.offWhite),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'People You May Know',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: FBColors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                final person = people[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(person['image']!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(person['name']!, style: FBText.postName),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: FBColors.blue,
                                      foregroundColor: FBColors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Add Friend'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: FBColors.offWhite,
                                      foregroundColor: FBColors.black,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Remove'),
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillTab(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? FBColors.blue.withOpacity(0.1) : FBColors.offWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? FBColors.blue : FBColors.black,
          fontSize: 15,
        ),
      ),
    );
  }
}
