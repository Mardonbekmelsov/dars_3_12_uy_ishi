import 'package:dars_3_12_uy_ishi/models/contact.dart';
import 'package:dars_3_12_uy_ishi/services/local_database.dart';
import 'package:sqflite/sqflite.dart';

class ContactController{
  final localDatabase=LocalDatabase();

  Future<Database> get database async{
    return  localDatabase.database;
  }

  void addContact(String name, String number){
    localDatabase.addContact(name, number);
    getContacts();
  }

  Future<List<Contact>> getContacts()async{
    List<Contact> contactList =[];
    List contacts= await localDatabase.getContacts();
    contacts.forEach((map){
      contactList.add(Contact(name: map["name"], number: map["number"]));
    });
    print(contactList);
    return contactList;
  }

  Future<void> deleteContact(String name, String number)async {
    await localDatabase.deleteContact(name, number);
  }

  Future<void> editContact(String name, String number, String newName, String newNumber) async {
    await localDatabase.editContact(name, number, newName, newNumber);
  }
}