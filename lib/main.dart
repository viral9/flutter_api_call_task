import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'DataProject.dart';

void main() {
  runApp(MaterialApp(
    home: Home()
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    Future<List<DataProject>> getDataProject() async{


    try {
      var data = await http.get(
          "https://64672025-cb38-4a13-8dcb-03a45118624b.mock.pstmn.io/trending_repository");

      // print("++++++++++++++++++++++++++++++++++++++");
      //print(data.body);

      var jsondata = json.decode(data.body);

      var jsonlist = jsondata["list"];

      print(jsonlist);

      List<DataProject> dataproject = [];
      List<String> category = [];
      List<String> language = [];


      for (var i in jsondata["list"]) {
        language.clear();
        category.clear();
        for (var j in i["category"]) {
          category.add(j);
        }

        for (var k in i["language"]) {
          language.add(k);
        }

        DataProject dataobj = DataProject(
            i["repository_Id"],
            i["repository_name"],
            i["created_date"],
            category,
            i["developer"],
            i["repository_ratings"],
            i["developer_reputation_score"],
            language,
            i["price"]);

        dataproject.add(dataobj);
      }


      print("__________________________________");
      print(dataproject[0]);

      return dataproject;
    }catch(e){
      print("erroe is $e");
    }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my demo"),
        centerTitle: true,
      ),
        body: Container(
          child : FutureBuilder(
            future : getDataProject(),
            builder : (BuildContext context, AsyncSnapshot snapshot){

              if(snapshot.data == null)
                {
                  return Container(
                    child: Center(
                      child: SpinKitCircle(
                        color: Colors.blue,
                        size: 70,
                      ),
                    ),
                  );
                }else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(

                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      color: Colors.blue,
                      child: Column(
                        children: <Widget>[

                          Text(snapshot.data[index].repository_name),
                          Text(snapshot.data[index].created_date),
                          Text(snapshot.data[index].developer),
                          Text(snapshot.data[index].repository_ratings),
                          Text(snapshot.data[index].developer_reputation_score),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.attach_money,
                              ),
                              Text(snapshot.data[index].price)
                            ],
                          ),


                          ListView.builder( itemCount: snapshot.data[index].language.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int indexss){
                                return Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        Text(snapshot.data[index].language[indexss])

                                      ],
                                    )
                                );

                              }
                          ),
                          ListView.builder( itemCount: snapshot.data[index].category.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int indexss){
                                return Container(
                                    child: Column(
                                      children: <Widget>[

                                        Text(snapshot.data[index].category[indexss])

                                      ],
                                    )
                                );

                              }
                          ),




                        ],
                      ),
                    );
//                    return ListTile(
//                      title: Text(snapshot.data[index].repository_name),
//                    );
                  },
                );
              }
            },
          ),
        ),

    );
  }
}



