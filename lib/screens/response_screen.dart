import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


Widget response(
    BuildContext context, int i, AsyncSnapshot<QuerySnapshot> snapshot) {
  var responseController = TextEditingController();

  return AlertDialog(
    title: Text(
      "Штрихкод",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    content: SizedBox(
      width: 300,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(snapshot.data!.docs[i].get('barCode') ?? "No item code", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 200,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('responses')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty)
                      return Text("Any response");
                    // Не знаю як зробити перевірку на те, щоб відображати коментарі для певного Item (знизу є showResponce() в якому вказав логіку, пробував декілька варіантів, ніякий з них не працює, гуглив, на жаль інфи не знайшов)
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, i) {
                        return responseItem(i, snapshot);
                      },
                    );
                  },
                ),
              ),
              Divider(color: Colors.grey)
            ],
          ),
          addResponse(context, i, responseController, snapshot)
        ],
      ),
    ),
  );
}

Widget responseItem(int i, AsyncSnapshot<QuerySnapshot> snapshot) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    height: 50,
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
    child: Text(
        snapshot.data!.docs[i].get('responseItem') ?? Text('Error response!'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
  );
}

Widget addResponse(
    BuildContext context,
    int i,
    TextEditingController responseController,
    AsyncSnapshot<QuerySnapshot> snapshot) {
  return TextField(
    controller: responseController,
    maxLines: 1,
    decoration: InputDecoration(
      iconColor: Colors.grey,
      border: InputBorder.none,
      hintText: 'Відгук...',
      suffixIcon: IconButton(
        icon: Icon(
          Icons.send_rounded,
          size: 31,
        ),
        color: Color(0xFF171D26),
        onPressed: () {
          if (responseController.text.isNotEmpty) {
            var responseId = snapshot.data!.docs[i].get('barCode');

            FirebaseFirestore.instance.collection('responses').add({
              'responseId': responseId,
              'responseItem': responseController.text
            });
            FocusScope.of(context).unfocus();
            responseController.clear();
          }
        },
      ),
    ),
  );
}

bool showResponse(int i, AsyncSnapshot<QuerySnapshot> snapshot) {
  var type = false;
  if (snapshot.data!.docs[i].get('barCode') ==
      snapshot.data!.docs[i].get('responseId')) type = true;
  return type;
}
