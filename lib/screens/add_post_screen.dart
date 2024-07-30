import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController desccontroller = TextEditingController();
  Uint8List? _file;
  bool islaoding = false;

  void postimage(String uid, String username, String profimage) async{
    setState(() {
      islaoding =true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(desccontroller.text, _file!, uid, username, profimage);
      if(res == 'success'){
        
        setState(() {
          islaoding =false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('posted')));
        clearImage();
      }
      else {
        setState(() {
          islaoding =false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      }
    }catch(e){
      // setState(() {
      //     islaoding =false;
      //   });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('create a post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickimage(ImageSource.camera);  
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickimage(ImageSource.gallery);  
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('cancel', style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      },
    );
  }



  void clearImage(){
    setState(() {
      _file = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getuser;

    return _file == null ? Center(child: IconButton(onPressed: () => _selectImage(context), icon: Icon(Icons.upload)),) : 
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: clearImage, ///////////////////////////////////////////////
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('post to'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postimage(user!.uid, user.username, user.photourl), ///////////////////////////////////////////////////// 
            child: const Text(
              'post',
              style: TextStyle(
                  color: blueColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          islaoding? const LinearProgressIndicator(): const Padding(padding: EdgeInsets.only(top: 0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
user!.photourl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(controller: desccontroller,
                  decoration: InputDecoration(
                    hintText: 'write a caption.',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: MemoryImage(_file!),
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                    )),
                  ),
                ),
              ),
              const Divider()
            ],
          )
        ],
      ),
    );
  }
}
