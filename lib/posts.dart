import 'dart:convert';
import 'dart:io';

import 'package:astarte/network_manager/models/post.dart';
import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:astarte/network_manager/services/posts_service.dart';
import 'package:astarte/network_manager/services/sensor_data_service.dart';
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
                height: MediaQuery.of(context).size.height * 0.7,
                child: const PostList(),
              )
          ),
          Align(
            alignment: Alignment.center,
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
          final data = snapshot.data!.body!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final post = data[index];
              return Column(
                children: [
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: post.image == null
                                ? const Icon(Icons.image_not_supported)
                                : Image.memory(base64.decode(post.image!))
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.message,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: open reply dialog
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Reply'),
                                      content: const TextField(
                                        decoration: InputDecoration(
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
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Reply'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            child: const Text('Reply'),
                          ),
                        )
                      ],
                    ),
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
