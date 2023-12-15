import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab_7/users_model.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  //place the url
  get url_ => 'https://randomuser.me/api/?results=20';

  //save the users from url to users list
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemExtent: 80,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.picture),
                radius: 35,
              ),
              title: Text(
                '${user.title}. ${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(user.email),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: fetch,
        child: const Icon(
          Icons.refresh,
          size: 36,
        ),
      ),
    );
  }

  void fetch() async {
    final uri = Uri.parse(url_);
    final response = await http.get(uri);

    String body = '';

    //if successful
    if (response.statusCode == 200) {
      body = response.body;
      //decode json and save to jsonData
      final jsonData = jsonDecode(body);
      List<User> jsonUsers = [];

      for (Map<String, dynamic> user in jsonData['results']) {
        final newUser = User.fromJson(user);
        jsonUsers.add(newUser);
      }
      setState(() {
        users = jsonUsers;
      });
    }
  }
}
