import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskfrontend/screens/task.dart';
import 'package:taskfrontend/screens/taskdetails.dart';

class dashscreen extends StatefulWidget {
  const dashscreen({super.key});

  @override
  State<dashscreen> createState() => _dashscreenstate();
}

class _dashscreenstate extends State<dashscreen> {
  List<Map<String, dynamic>> tasks = [];
  late int userID;
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 172, 255),
        title: const Text(
          'DashBoard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.cyan, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context,index){
              Color StatusColor = _getStatusColor(tasks[index]['status']);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    tasks[index]['title'],
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: StatusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tasks[index]['status'],
                            style: TextStyle(color:const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          ),
                          ],
                        ),
                        onTap: () {
                            print("Navigating with ID: ${tasks[index]['id']}");

                              Navigator.push(
                               context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailScreen(taskID: tasks[index]['id']),
    ),
  );
},

                      
                    ),
                  );
                },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? taskAdded = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => taskscreen()));
          if (taskAdded != null && taskAdded) {
            fetchtasks();
          }
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add),),
          );
      
  }
  Future<void> fetchtasks() async{

print("hi");

    SharedPreferences prefs= await SharedPreferences.getInstance();
      userID= prefs.getInt('userID') ?? 0;
      String url= 'http://localhost:5210/api/Task/get_list_of_tasks?userID=$userID';

      print("hihelo:$url");

      print("helo");   
        final response = await http.get(
    Uri.parse(url),
    
        );
        if (response.statusCode == 200)
        {
        
            List<dynamic> data = json.decode(response.body);
            print(data);
            setState(() {
              tasks = data.map((task)
              {
                return{
                  'id': task['taskID'],
                  'title' : task['title']?.toString()??'',
                  'status':task['status']?.toString() ??'',
                };
              }).toList();

              print(tasks);
              
            });  
          } 
           else{

            print('Error');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("failed to load data"))
            );
           }
          }
        void initState(){
          super.initState();
          print("hi");
          fetchtasks();
        }
         Color _getStatusColor(String status){
          switch (status) {
            case 'not started':
              return const Color.fromARGB(255, 246, 2, 2);
            case 'ongoing':
              return const Color.fromARGB(255, 230, 230, 4);
            case 'completed':
              return const Color.fromARGB(221, 3, 241, 31);
            default:
              return const Color.fromARGB(115, 103, 116, 101);
          }
        }
        
}
       
        
    
