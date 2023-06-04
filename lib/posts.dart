import 'dart:convert';
import 'dart:io';

import 'package:astarte/network_manager/models/post.dart';
import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:astarte/network_manager/services/posts_service.dart';
import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/utils/parameters.dart' as parameters;
import 'package:built_collection/built_collection.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:astarte/sidebar.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Posts'),
      body: Column(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.75,
                child: const PostList(),
              )
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-post');
                    },
                    child: const Text('Ask a new question', style: TextStyle(fontSize: 20)),
                  )
              ),
            ),
          ),
        ],
      ),
      drawer: NavBar(context),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<BuiltList<PostData>>>(
      future: Provider.of<PostsService>(context, listen: false).getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data?.body;
          if (data == null || data.isEmpty) {
            return const Center(child: Text('No posts yet', style: TextStyle(fontSize: 18)));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final post = data[index];
              return Column(
                children: [
                  Card(
                    color: Colors.white70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                post.username,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Visibility(
                                visible: post.username == Provider.of<parameters.CurrentUser>(context, listen: false).username,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Delete post'),
                                            content: const Text('Are you sure you want to delete this post?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  final response = await Provider.of<PostsService>(context, listen: false).deletePost(post.id!);
                                                  if (response.isSuccessful) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Post deleted'),
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Could not delete post'),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                              width: double.infinity,
                              height: post.image == null ? 0 : 200,
                              child: post.image == null
                                  ? const SizedBox.shrink()
                                  : Image.memory(base64.decode(post.image!))
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.message,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      final replyController = TextEditingController();
                                      return AlertDialog(
                                        title: const Text('Reply'),
                                        content: TextField(
                                          controller: replyController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Reply',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final response = await Provider.of<PostsService>(context, listen: false)
                                                  .createReply(post.id!,
                                                PostData((b) => b
                                                  ..message = replyController.text
                                                  ..username = Provider.of<parameters.CurrentUser>(context, listen: false).username
                                              ),
                                              );

                                              if (response.isSuccessful) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Reply created'),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Could not create reply'),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Reply'),
                                          ),
                                        ],
                                      );
                                    }
                                );
                              },
                              child: const Text('Reply', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: FutureBuilder<Response<BuiltList<PostData>>>(
                            future: Provider.of<PostsService>(context, listen: false).getReplies(post.id!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else {
                                final data = snapshot.data?.body;
                                if (data == null || data.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final reply = data[index];
                                    return Column(
                                      children: [
                                        Card(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          reply.username,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Visibility(
                                                          visible: reply.username == Provider.of<parameters.CurrentUser>(context, listen: false).username,
                                                          child: IconButton(
                                                            icon: const Icon(Icons.delete),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return AlertDialog(
                                                                      title: const Text('Delete reply'),
                                                                      content: const Text('Are you sure you want to delete this reply?'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text('Cancel'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () async {
                                                                            final response = await Provider.of<PostsService>(context, listen: false).deleteReply(reply.id!);
                                                                            if (response.isSuccessful) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Text('Reply deleted'),
                                                                                ),
                                                                              );
                                                                              Navigator.pop(context);
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Text('Could not delete reply'),
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                          child: const Text('Delete'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 10),
                                                    Text(
                                                      reply.message,
                                                      style: Theme.of(context).textTheme.titleMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
