import 'package:dars_3_12_uy_ishi/controllers/contact_controller.dart';
import 'package:dars_3_12_uy_ishi/models/contact.dart';
import 'package:dars_3_12_uy_ishi/services/local_database.dart';
import 'package:dars_3_12_uy_ishi/views/widgets/contact_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final addNameController = TextEditingController();

  final addNumberController = TextEditingController();

  final editNameController = TextEditingController();

  final editNumberController = TextEditingController();

  final localDatabase = LocalDatabase();

  final contactController = ContactController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final db = contactController.database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Add Contact"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: addNameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.person,
                                ),
                                hintText: "Enter name"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: addNumberController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.phone,
                                ),
                                hintText: "Enter number"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              contactController.addContact(
                                  addNameController.text,
                                  addNumberController.text);
                              addNameController.clear();
                              addNumberController.clear();
                              Navigator.of(context).pop();
                              setState(() {

                              });
                            },
                            child: const Text(
                              "Add contact",
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: FutureBuilder(future: contactController.getContacts(), builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!snapshot.hasData){
          return Center(
            child: Text("Kontaktlar topilmadi"),
          );
        }
        List<Contact> contacts=  snapshot.data!;
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: contacts.length,

            itemBuilder: (context, index){
         return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueGrey,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    contacts[index].name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    contacts[index].number,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Edit Contact"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: editNameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.person,
                                ),
                                hintText: "Enter new  name"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: editNumberController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.phone,
                                ),
                                hintText: "Enter new number"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              ElevatedButton(onPressed: (){
                                Navigator.of(context).pop();
                              }, child: Text("Cancel")),
                              ElevatedButton(
                                style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () {
                                  contactController.editContact(
                                    contacts[index].name,
                                    contacts[index].number,
                                      editNameController.text,
                                      editNumberController.text);
                                  editNameController.clear();
                                  editNumberController.clear();
                                  Navigator.of(context).pop();
                                  setState(() {
                              
                                  });
                                },
                                child: const Text(
                                  "Edit contact",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        contactController.deleteContact(contacts[index].name, contacts[index].number);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
        });
      }),
    );
  }
}
