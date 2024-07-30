import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';
const webscreemsize = 600;

List<Widget> homeScreenItems = [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text('4'),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
          
        ];