import 'package:flutter/material.dart';
class homePage extends StatelessWidget {
  const homePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme : const IconThemeData(color:Colors.black),
          title: Row(
            children: [
                const Text('facebook',
                      style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      ),),

                const Spacer(),
                IconButton( 
                  onPressed: () {}, 
                  icon: Icon(Icons.add),),

                IconButton( 
                    onPressed: () {}, 
                    icon: Icon(Icons.search),),

                IconButton( 
                    onPressed: () {}, 
                    icon: Icon(Icons.message_outlined),),
            ]
        )
        ),
        body: Column(
          children: [            
            // 1st child
            Row(
              children: [
                Expanded(child: IconButton(onPressed: () {}, color: Colors.blue, icon: const Icon(Icons.home))),
                Expanded(child: IconButton(onPressed: () {}, color: Colors.black, icon: const Icon(Icons.ondemand_video))),
                Expanded(child: IconButton(onPressed: () {}, color: Colors.black, icon: const Icon(Icons.groups))),
                Expanded(child: IconButton(onPressed: () {}, color: Colors.black, icon: const Icon(Icons.storefront))),
                Expanded(child: IconButton(onPressed: () {}, color: Colors.black, icon: const Icon(Icons.notifications))),
                Expanded(child: IconButton(onPressed: () {}, color: Colors.black, icon: const Icon(Icons.menu))),
              ],
            ),

            // 2nd child as a whole
            Expanded(
              child:
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: 
               Column(
                children: [
            // 2nd child
                Row(
                children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/EdenPhoto.jpg'),
                  backgroundColor: Colors.transparent,
                ),

                  ),
                
                
                Expanded(
                child: TextField (
                  decoration: InputDecoration(
                    hintText: "What's on your mind?" ,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      )
                      )
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  color: Colors.blue,
                  icon: const Icon(Icons.image),
                ),
              ],
            ),

            const SizedBox(height: 8.0),

            // 3rd child(row)
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:const EdgeInsets.all(4.0),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) =>const SizedBox(width: 8.0),
                itemBuilder: (context, index){
                  if (index == 0){
                    return _CreateStoryCard();
                    }
                  return _SuggestionCard(suggestion: _suggestions[index]);
                  },
              ),
            ),

            // 4th child
            const SizedBox(height: 8.0),
            ListView.separated(
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(4.0),
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                itemBuilder: (context, index) => _PostCard(post: _posts[index],
              ),
            ),
            
                ], 
            ),
              

                
            ),
        ),
          ],
        ),
    
    );
                  
  }
}



class _CreateStoryCard extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      width: 120,
      height: 180,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0,3),
            ),
        ],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: const Image(
                      image: AssetImage('assets/images/EdenPhoto.jpg'),
                      fit: BoxFit.cover,    
                  ),
                  ),
                ),

                Positioned(
                  right: 40,
                  bottom: 1,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: () {},
                      icon: Icon(Icons.add, color: Colors.white,),
                    ),
                  ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Create Story',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
  
    );
  }
}


class _FriendSuggestion {
  final String name;
  const _FriendSuggestion({required this.name});

}

const List<_FriendSuggestion> _suggestions = [
  _FriendSuggestion(name: 'Eden'),
  _FriendSuggestion(name: 'Adoni'),
  _FriendSuggestion(name: 'Anani'),
  _FriendSuggestion(name: 'Heaven'),
  _FriendSuggestion(name: 'Belay')
];

class _SuggestionCard extends StatelessWidget {
  final _FriendSuggestion suggestion;
  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context){
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0,3),
            ),
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton
              (iconSize: 18,
              onPressed: () {},
              icon: Icon(Icons.close),)
            ],
            ),

          CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/EdenPhoto.jpg'),
            ),
            Text(
              suggestion.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            SizedBox(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add, color: Colors.blue),
                label: const Text('Add', style: TextStyle(color: Colors.blue),
              )
            )
            )

        ],
        )

    );
  }

}



class _Post{
  final String author;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;
  const _Post(
    {
      required this.author,
      required this.content,
      required this.imageUrl,
      required this.likes,  
      required this.comments,
      required this.shares,
    }
  );
}


const List<_Post> _posts= [
  _Post(
    author: 'Eden',
    content: 'Had a great day at the park!',
    imageUrl: 'assets/images/EdenPhoto.jpg',
    likes: 120,
    comments: 30,
    shares: 10,
  ),
  _Post(
    author: 'Adoni',
    content: 'Loving the new Flutter update.',
    imageUrl: 'assets/images/EdenPhoto.jpg',
    likes: 95,
    comments: 20,
    shares: 5,
  ),
  _Post(
    author: 'Anani',
    content: 'Check out my latest blog post!',
    imageUrl: 'assets/images/EdenPhoto.jpg',
    likes: 80,
    comments: 15,
    shares: 8,
  ),
  _Post(
    author: 'Heaven',
    content: 'Just finished a marathon!',
    imageUrl: 'assets/images/EdenPhoto.jpg',
    likes: 150,
    comments: 40,
    shares: 12,
  ),
  _Post(
    author: 'Belay',
    content: 'Exploring the mountains.',
    imageUrl: 'assets/images/EdenPhoto.jpg',
    likes: 110,
    comments: 25,
    shares: 7,
  ),
];


class _PostCard extends StatelessWidget{
  final _Post post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black12,
                offset: Offset(0,3),
                ),
            ],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
      ),
          child: 
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius : 20,
                      backgroundImage: AssetImage(post.imageUrl),    
                    ),
                    SizedBox(width: 8.0),

                    Text(post.author),

                    Spacer(),

                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz),
                    ),

                    SizedBox(height: 8.0),

                    IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.close)
                      )
                  ],
                  ),

                  SizedBox(height: 8.0),

                  Text(post.content),

                  SizedBox(height: 8.0),

                  Image(
                    image: AssetImage(post.imageUrl),
                    fit: BoxFit.cover,
                  ),

                  SizedBox(height: 8.0),

                  Row(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.blue,),
                      SizedBox(width: 2.0),
                      Text('${post.likes}'),
                      Spacer(),
                      Text('${post.comments} Comments'),
                      SizedBox(width: 8.0), 
                      Text('${post.shares} Shares'),
                    ],
                    ),

                  SizedBox(height: 8.0),

                  Row(
                    children: [
                      Expanded(
                        child:
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up_alt_outlined),
                                onPressed: () {},
                              ),
                              Text('Like'),

                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.comment_outlined),
                                onPressed: () {},
                              ),
                              Text('Comment'),
                              Spacer(),

                              IconButton(
                                icon: Icon(Icons.share_outlined),
                                onPressed: () {},
                              ),
                              Text('Share'),
                          ],
                          )
                      )
                    ],
                    )
              ],
              )
    );
  }
}