import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance";

void main()async{
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
       inputDecorationTheme: const InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      ),
    ),
  ),
);
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

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitcoinController.text = "";

  }

  late double dolar;
  late double euro;
  late double bitcoin;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoin).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/ euro).toStringAsFixed(2);
    bitcoinController.text = (dolar * this.dolar/ bitcoin).toStringAsFixed(2);

  }
  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/ dolar).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro/ bitcoin).toStringAsFixed(2);

  }
  void _bitcoinChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text = (bitcoin * this.bitcoin/ dolar).toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin/ euro).toStringAsFixed(2);

  }


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
             dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
             euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
             bitcoin = snapshot.data!["results"]["currencies"]["BTC"]["buy"];
             return SingleChildScrollView(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                    // Text('O Preço do dola é R\$$dolar'), 
                    // Text('O Preço do euro é R\$$euro'), 
                    const Icon(Icons.percent, size: 160, color: Colors.amber,),
                     buildTextField('Reais', 'R\$', realController, _realChanged),
                       const Divider(),
                       buildTextField('Dolares', 'US\$', dolarController, _dolarChanged),
                       const Divider(),
                       buildTextField('Euros', 'Є\$', euroController, _euroChanged),  
                       const Divider(),
                       buildTextField('Bitcoin', 'BTC\$', bitcoinController, _bitcoinChanged),  
                   ],
                 ),
               ),
             );
           }
         }
       },
       ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function(String) changed){
  return TextField(
          controller: controller,
            decoration: InputDecoration(
              labelText: label,
                labelStyle: const TextStyle( 
                  // color: Colors.amber,
                  fontSize: 25,
                 ),
                  border: const OutlineInputBorder(),
                    prefixText: prefix,
                  ),
                 style: const TextStyle(
              //  color: Colors.amber,
             fontSize: 25,
            ),
            keyboardType: TextInputType.number,
            onChanged: changed ,
          );
}