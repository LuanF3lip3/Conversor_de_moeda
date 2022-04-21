import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance";

void main()async{
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

Future<Map> getMap() async {
 http.Response response = await http.get(Uri.parse(request));
 return  jsonDecode(response.body);
}

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 68, 44, 44),
     appBar: AppBar(
       title: const Text("\$Conversor\$",
       style: TextStyle(
         color: Colors.black,
       ),),
       backgroundColor: Colors.amber,
       centerTitle: true,
       toolbarHeight: 60,
     ),
     body: FutureBuilder<Map>(
       future: getMap(),
       builder: (context, snapshot) {
         switch (snapshot.connectionState){
           case ConnectionState.none:
           case ConnectionState.waiting:
           return const Center(
             child: Text("Carregando dados...",
             style: TextStyle(
               color:Colors.yellow,
               fontSize: 25,
             ),
             textAlign: TextAlign.center,
             ),
             );
           default:
           if(snapshot.hasError){
             return const Center(
             child: Text("Algo deu errado :(",
             style: TextStyle(
               color:Colors.red,
               fontSize: 25,
             ),
             textAlign: TextAlign.center,
             ),
           );
           }else {
             return Container(color: Colors.green,);
           }
         }
       },
       ),
    );
  }
}