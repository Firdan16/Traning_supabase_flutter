import 'package:flutter/material.dart';
import 'package:flutter_supabase/ui/screen/CRUD/create_screen.dart';
import 'package:flutter_supabase/ui/screen/crud/update_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _readStream;

  // Syntax to read data in realtime
  @override
  void initState() {
    String userId = supabase.auth.currentUser!.id;
    _readStream = supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('id', ascending: false);
    super.initState();
  }

  // Syntax to read data
  // Future<List> readData() async {
  //   String userId = supabase.auth.currentUser!.id;
  //   final result = await supabase
  //       .from('todos')
  //       .select()
  //       .eq('user_id', userId)
  //       .order('id', ascending: false);
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Flutter'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _readStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return const Center(child: Text('No data found'));
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var data = snapshot.data[index];

                return ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['created_at']),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateScreen(
                            data['title'],
                            data['id'],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.greenAccent,
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateScreen()));
        },
      ),
    );
  }
}
