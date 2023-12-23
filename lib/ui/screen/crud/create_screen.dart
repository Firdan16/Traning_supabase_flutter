import 'package:flutter/material.dart';
import 'package:flutter_supabase/helper/date_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();

  // Syntax to insert a record
  // supabase.from('todos').insert({ 'title': 'dummy value', 'date': 'value' })

  @override
  void dispose() {
    titleController.dispose();
    supabase.dispose();
    super.dispose();
  }

  Future insertData() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = supabase.auth.currentUser!.id;

      await supabase.from('todos').insert(
        {
          'title': titleController.text,
          'user_id': userId,
          'device_id': resiDate(DateTime.now()),
        },
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter the title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: insertData,
                    child: const Text(
                      'Create',
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
