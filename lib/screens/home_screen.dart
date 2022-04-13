import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hash_tag/screens/response_screen.dart';

import '../util/common.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var barCodeController = TextEditingController();
  var nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext) {
              return _addItem();
            },
          );
        },
        child: Icon(
          Icons.add_circle_outline,
          size: 55,
        ),
        backgroundColor: Colors.purple[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) return _noItem();
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (ctx, i) {
                return item(context, i, snapshot);
              },
            );
          },
        ),
      ),
    );
  }

  Widget item(context, int i, AsyncSnapshot<QuerySnapshot> snapshot) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext) {
            return response(context, i, snapshot);
          }
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 120,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.indigo[300],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Штрихкод:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(snapshot.data!.docs[i].get('barCode') ?? "BarCode",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                SizedBox(
                  width: 250,
                  child: Text(snapshot.data!.docs[i].get('name') ?? "Name",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
              ],
            ),
            IconButton(
                onPressed: () => FirebaseFirestore.instance
                    .collection('items')
                    .doc(snapshot.data!.docs[i].id)
                    .delete(),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }

  Widget _addItem() {
    return AlertDialog(
      title: Text("Додати штрихкод:"),
      content: SizedBox(
        height: 220,
        child: Column(
          children: [
            TextFormField(
              maxLength: 15,
              style: const TextStyle(fontSize: 14),
              decoration: Common.getInputDecoration(
                "Штрихкод",
              ),
              keyboardType: TextInputType.number,
              controller: barCodeController,
              onSaved: (value) {
                barCodeController.text = value.toString();
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              style: const TextStyle(fontSize: 14),
              decoration: Common.getInputDecoration(
                "Назва продукту",
              ),
              keyboardType: TextInputType.text,
              controller: nameController,
              onSaved: (value) {
                nameController.text = value.toString();
              },
            ),
            SizedBox(
              height: 16,
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              child: MaterialButton(
                child: Text(
                  "Додати",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.purple),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.purple[400],
                onPressed: () {
                  FirebaseFirestore.instance.collection('items').add({
                    'barCode': barCodeController.text,
                    'name': nameController.text
                  });
                  barCodeController.text = "";
                  nameController.text = "";
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noItem() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.purple),
        height: 75,
        width: 275,
        child: Center(
          child: Text(
            "Додайте штрихкод",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
