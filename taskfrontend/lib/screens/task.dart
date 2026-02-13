import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



class taskscreen extends StatefulWidget {
  const taskscreen({super.key});

  @override
  State<taskscreen> createState() => _taskscreen();
}

class _taskscreen extends State<taskscreen> {
 

  final TextEditingController titlecontrol = TextEditingController();
  final TextEditingController Descriptioncontrol = TextEditingController();
  final TextEditingController Deadlinecontrol = TextEditingController();
  final TextEditingController Statuscontrol = TextEditingController();

  List <String> statusoptions = ['completed', 'ongoing','not started'];
  String selectedstatus= 'completed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 126, 4),
        foregroundColor: const Color.fromARGB(255, 5, 187, 233),
        centerTitle: true,
        title: Text(
          "Welcome to Task Assigning Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: Center(
        
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: 300, // Reduce width of text fields and button
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Task',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: titlecontrol,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    ),
                  SizedBox(height: 20),
                  TextField(
                     controller: Descriptioncontrol,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    ),
                               SizedBox(height: 20),

            // Deadline Field with Date + Time Picker
            SizedBox(
              width: 300,
              
              child: TextField(
                controller: Deadlinecontrol,
                readOnly: true,
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  final dt = DateTime(
                    d!.year,
                    d.month,
                    d.day,
                    t!.hour,
                    t.minute,
                  );
                  Deadlinecontrol.text = DateFormat(
                    'yyyy-MM-dd HH:mm',
                  ).format(dt);
                },
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Deadline',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

                   SizedBox(height: 20),
                  SizedBox(
                     
                    width: 300,
                    child: DropdownButtonFormField<String> (
                      value: selectedstatus,
                      items: statusoptions.map((status) 
                      {
                        return DropdownMenuItem(value: status, child: Text(status));
                      }).toList(),
                       onChanged: (newvalue) { 
                        setState(() {
                          selectedstatus = newvalue!;
                        });

                        },
                        decoration: InputDecoration(
                          labelText: 'status',
                          border: OutlineInputBorder(),  
                        ),                      
                        ),
                    ),
                  
      
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      taskuser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 254, 58),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text('Add Task'),
                  )

                ],
              ),

              

            ),
          ),
        ),
      ),
    );
  }

Future <void> taskuser () async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
      
      var userID= prefs.getInt('userID');
  print("===========>1");

  String Title = titlecontrol.text.trim();
  String Description= Descriptioncontrol.text.trim();
  String Status = selectedstatus; // ✅ Use selectedstatus instead
  String Deadline= Deadlinecontrol.text.trim();

  if (Title.isEmpty || Description.isEmpty || Status.isEmpty || Deadline.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  String url = 'http://localhost:5210/api/Task/addtask?Title=$Title&Descrip=$Description&Status=$Status&Deadline=$Deadline&UserID=$userID';
  print("url: $url");

  final response = await http.post(Uri.parse(url));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task Added successful')),
      
    );
    Navigator.pushReplacementNamed(context, '/dashscreen');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task adding failed')),
    );
  }
}
}