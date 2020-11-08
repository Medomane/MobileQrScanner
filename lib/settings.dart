import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'func.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  TextEditingController keywordEditingController;
  @override
  initState() {
    super.initState();
    keywordEditingController=new TextEditingController();
    func.readContent().then((value) => keywordEditingController.text = value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paramètre')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: "http://exemple.com"),
              controller: keywordEditingController,
              onSubmitted: (str) async {
                setUrl(str);
              },
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () async {
                  var str =keywordEditingController.text ;
                  setUrl(str);
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Valider')
              ),
            )
          ],
        )
      )
    );
  }

  Future<void> setUrl(String url) async {
    var pr = new ProgressDialog(context);
    try{
      if(url == null || url.trim() == "") Fluttertoast.showToast(msg: "Vous devez saisir un lien !!!");
      else{
        final response = await http.get(url);
        if (response.statusCode != 200) Fluttertoast.showToast(msg: "Vous devez saisir un lien valide !!!");
        else {
          await pr.show();
          var f = await func.writeContent(url);
          Fluttertoast.showToast(msg: "Operation s'est bien passée !!!");
          await pr.hide();
        }
      }
    }
    catch(e){
      func.errorToast(e.toString());
      await pr.hide();
    }
  }
}