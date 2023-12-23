import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isUploading = false;
  final SupabaseClient supabase = Supabase.instance.client;

  Future getMyFile() async {
    final List<FileObject> result = await supabase.storage
        .from('user_image')
        .list(path: supabase.auth.currentUser!.id);
    List<Map<String, String>> myImage = [];

    for (var image in result) {
      final getUrl = supabase.storage
          .from('user_image')
          .getPublicUrl("${supabase.auth.currentUser!.id}/${image.name}");

      myImage.add({
        'name': image.name,
        'url': getUrl,
      });
    }
    return myImage;
  }

  Future uploadFile() async {
    var pickedFile = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (pickedFile != null) {
      setState(() {
        isUploading = true;
      });
      try {
        File file = File(pickedFile.files.first.path!);
        String fileName = pickedFile.files.first.name;
        String uploadedUrl = await supabase.storage
            .from('user_image')
            .upload("${supabase.auth.currentUser!.id}/$fileName", file);
        setState(() {
          isUploading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File Uploaded Successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print("Error : $e");
        setState(() {
          isUploading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> deleteImage(String imageName) async {
    try {
      await supabase.storage
          .from('user_image')
          .remove(["${supabase.auth.currentUser!.id}/$imageName"]);
      setState(() {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File Remove Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getMyFile(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return const Center(child: Text('No image hehe'));
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  Map imageData = snapshot.data[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          imageData['url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(imageData['name']),
                      IconButton(
                        onPressed: () => deleteImage(imageData['name']),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(thickness: 2, color: Colors.grey);
                },
                itemCount: snapshot.data.length,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadFile,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
