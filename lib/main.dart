import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_downloader/image_downloader.dart';

import 'settings.dart';
import 'func.dart';

void main() => runApp(MaterialApp( home: QRCodePage(), ));

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}
class _QRCodePageState extends State<QRCodePage> {
  Element result;
  TextEditingController keywordEditingController;
  @override
  void initState() {
    super.initState();
    keywordEditingController=new TextEditingController();
    result = Element(code:"",image:"",family: "",designation:"",qte_stock:0,sale_price:0);
  }
  @override
  Widget build(BuildContext context) {
    var pr = new ProgressDialog(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ODYSSEE (Scanner Code)'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (c){
              if(c.title=="Paramètres") Navigator.push(context, MaterialPageRoute(builder:(context)=>Settings()));
            },
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title)
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding:const EdgeInsets.fromLTRB(20.0,20.0,20.0,100.0),
            child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onLongPress: () async {
                          try {
                            await pr.show();
                            if(result.image != ""){
                              var imageId = await ImageDownloader.downloadImage(result.image);
                              if (imageId == null) func.errorToast('Erreur de téléchargement !!!');
                              else Fluttertoast.showToast(msg:"Image téléchargé avec succès", toastLength:Toast.LENGTH_LONG,backgroundColor: Colors.white,textColor: Colors.black);
                              await pr.hide();
                            }
                          } catch (error) {
                            print(error.toString());
                            await pr.hide();
                          }
                        },
                        child: Center(
                          child: result.image == ''?
                          Image.asset('images/default.png'):
                          FadeInImage.assetNetwork(
                              placeholder: 'images/loading.gif',
                              image:result.image
                          ),
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Famille', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.right),
                            )
                        ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(':', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('${result.family}')
                            )
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Désignation', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.right),
                            )
                        ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(':', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('${result.designation}')
                            )
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Quantité en stock', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.right),
                            )
                        ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(':', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('${result.qte_stock}')
                            )
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Prix de vente', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.right),
                            )
                        ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(':', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('${result.sale_price}')
                            )
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Code de l\'article', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.right),
                            )
                        ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(':', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('${result.code}')
                            )
                        )
                      ],
                    ),
                  ),
                  Divider(height: 50),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text('Quantité :', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                            )
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: TextField(
                              controller: keywordEditingController,
                              onSubmitted: (qte){
                                sendQte(qte);
                              },
                              keyboardType: TextInputType.number
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: IconButton(
                              onPressed: (){
                                sendQte(keywordEditingController.text);
                              },
                              color: Colors.blue,
                              icon: Icon(Icons.check),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
            )
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.scanner),
          onPressed: scanQR,
          label: Text('Scanner')
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Future scanQR() async{
    var pr = new ProgressDialog(context);
    String barcodeScanRes;
    try {
      barcodeScanRes = await scanner.scan();
      if (!mounted) return;
      await pr.show();
      var url = await func.readContent();
      var fullUrl = url+"?code="+barcodeScanRes;
      print(fullUrl);
      if(url == null || url.trim() == "") {
        pr.hide();
        Fluttertoast.showToast(msg: "Vous devez donner un url !!!");
        return ;
      }
      var tmp = await http.get(Uri.encodeFull(fullUrl), headers: {'accept': 'application/json'});
      Map<String, dynamic> res = jsonDecode(tmp.body);
      if(res["Content"] != null && res["Content"].toString().trim() != ""){
        if(res["Type"].toString() == "error") func.errorToast(res["Content"].toString());
        else Fluttertoast.showToast(msg: res["Content"].toString());
      }
      else{
        setState(() {
          result = Element(code:res["code"],image:res["image"],family: res["family"],designation:res["designation"],qte_stock:double.parse(res["qte_stock"].toString()),sale_price:double.parse(res["sale_price"].toString()));
        });
      }
      await pr.hide();
    } catch(e) {
      print(e.toString());
      await pr.hide();
    }
  }

  Future sendQte(String qte) async{
    if(qte.trim() != "" && func.isNumeric(qte)){
      if(result.code != "" && result.code != null && result.code.isNotEmpty){
        var pr = new ProgressDialog(context);
        try {
          await pr.show();
          var url = await func.readContent()+"?code="+result.code+"&qte="+qte;
          var tmp = await http.get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
          Map<String, dynamic> res = jsonDecode(tmp.body);
          if(res["Content"] != null && res["Content"].toString().trim() != ""){
            if(res["Type"].toString() == "error") func.errorToast(res["Content"].toString());
            else Fluttertoast.showToast(msg: res["Content"].toString());
          }
          await pr.hide();
        } catch(e) {
          print(e.toString());
          await pr.hide();
        }
      }
      else Fluttertoast.showToast(msg: "Vous devez scanner un code !!!");
    }
    else Fluttertoast.showToast(msg: "Invalide quantité !!!");
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}
class Element{
  String code ;
  String image ;
  String family ;
  String designation;
  double qte_stock;
  double sale_price;
  Element({this.code, this.image,this.family, this.designation, this.qte_stock, this.sale_price});
}
const List<Choice> choices = const <Choice>[
  const Choice(title: 'Paramètres', icon: Icons.settings)
];
