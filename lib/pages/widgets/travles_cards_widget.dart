import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class travles extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firestore Popup Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showCustomDialog(context),
          child: Text('Open Dialog'),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                submitData();
                Navigator.of(context). pop(); // Close the dialog after data submission
              },
            ),
          ],
        );
      },
    );
  }

  void submitData() {
    FirebaseFirestore.instance.collection('YourCollectionName').add({
      'name': nameController.text,
      'email': emailController.text,
    }).then((result) {
      print("Data added successfully.");
      nameController.clear();  // Clear the text fields after submission
      emailController.clear();
    }).catchError((error) {
      print("Failed to add data: $error");
    });
  }
}