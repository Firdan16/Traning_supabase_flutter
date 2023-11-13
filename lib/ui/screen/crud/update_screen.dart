import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateScreen extends StatefulWidget {
  final String editData;
  final int editId;

  const UpdateScreen(this.editData, this.editId, {super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    titleController.dispose();
    supabase.dispose();
    super.dispose();
  }

  Future<void> updateData() async {
    if (titleController.text != '') {
      setState(() {
        isLoading = true;
      });
      try {
        await supabase
            .from('todos')
            .update({'title': titleController.text}).match(
          {
            'id': widget.editId,
          },
        );
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> deleteData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('todos').delete().match(
        {
          'id': widget.editId,
        },
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    titleController.text = widget.editData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
        centerTitle: true,
      ),
      body: Column(
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
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: updateData,
                      child: const Text(
                        'Update',
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: deleteData,
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
