import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Kelimeler.dart';
import 'detaysayfa.dart';

void main() async {

await WidgetsFlutterBinding.ensureInitialized();
 await  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  var tfCont = TextEditingController();
  var refTest = FirebaseDatabase.instance.ref().child("kelimeler");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ? TextField(
          controller: tfCont,
          decoration: InputDecoration(
            hintText: "Arama için birşey yazın.",
          ),
          onChanged: (aramaSonucu)
          {
            setState(() {
              aramaKelimesi = tfCont.text;
            });
          //  print(aramaKelimesi);
          },


        ):Text(" Sözlük Uygulaması"),
        actions: [
          aramaYapiliyorMu ?

          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: ()
            {
              setState(() {
                aramaYapiliyorMu = false;
                aramaKelimesi="";
              });
            },
          ) :
          IconButton(
            icon: Icon(Icons.search),
            onPressed: ()
            {
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
          ),
        ],
      ),
      body:StreamBuilder<DatabaseEvent>(
        stream : refTest.onValue,
        builder: (context,event)
        {
          if(event.hasData)
          {
            List? kelimeListesi = <Kelimeler>[];
              var gelenDegerler = event.data!.snapshot.value as dynamic;

            if(gelenDegerler != null)
            {
              final _resultList = Map<String, dynamic>.from(gelenDegerler as LinkedHashMap);
              for (var key in _resultList.keys) {

                Map<String, dynamic> map2 = Map.from(_resultList[key]);

                if(aramaYapiliyorMu)
                  {
                    if(map2["ingilizce"].toString().contains(aramaKelimesi))
                      {
                        kelimeListesi.add(Kelimeler(map2["ingilizce"],map2["turkce"]));
                      };
                  }
                else
                {
                  kelimeListesi.add(Kelimeler(map2["ingilizce"],map2["turkce"]));
                }

              }
            }





            return ListView.builder(
                itemCount:kelimeListesi.length,
                itemBuilder: (context,indeks)
                {
                  var kelime = kelimeListesi[indeks];
                  return GestureDetector(
                    onTap: ()
                    {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => detaySayfa(ingilizce: kelime.ingilizce, turkce: kelime.turkce,)));
                    },
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(kelime.ingilizce, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(kelime.turkce),

                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          else return Center();
        },

      ),


    );
  }
}
