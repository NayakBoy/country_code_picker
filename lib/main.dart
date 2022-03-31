import 'dart:ui';

import 'package:flutter/material.dart';

import 'constant_file.dart';
import 'country.dart';

void main()
{
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Hero(),
        ),
      ),
    );
  }


}

class Hero extends StatefulWidget {
  const Hero({Key? key}) : super(key: key);

  @override
  State<Hero> createState() => _HeroState();
}

class _HeroState extends State<Hero> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          SearchDialogBox(context,(Country country){
            showSnackBar(context, "Selection country code is ${country.name} = ${country.phCode}");
          });
        },
        child: Text('Search'),
      ),
    );
  }

  void SearchDialogBox(BuildContext context,Function action) {
    var tempList = countryList;
    var textFieldController = TextEditingController();
    var dialog =  StatefulBuilder(
       builder: (context, setState) => Dialog(
         child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
             child: Container(
               decoration: BoxDecoration(
                   borderRadius: const BorderRadius.all(Radius.circular(5)),
                   color: Theme
                       .of(context)
                       .primaryColor),
               child: Container(
                 padding: const EdgeInsets.all(20),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     TextFormField(
                       controller: textFieldController,
                       cursorColor: Colors.black,
                       onChanged: (value){

                         if(value.isNotEmpty)
                         {
                           setState(() {

                             tempList = countryList.where((Country element) =>(element.name.toLowerCase().contains(value) || element.phCode.toLowerCase().contains(value)) ).toList();
                             return;
                           });

                         }

                       },
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Colors.white,
                         // labelText: LocaleKeys.secure_key.!tr(),
                         labelStyle: const TextStyle(color: Colors.black54),
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(5)),
                       ),
                     ),
                     Expanded(
                       child: ListView.builder(itemCount:tempList.length,itemBuilder: (context, count) {
                         return ListTile(
                           leading: Text(tempList[count].phCode),
                           title: Text(tempList[count].name),
                           onTap: () {
                             action(tempList[count]);
                             Navigator.of(context).pop();
                             },
                         );
                       }),
                     )
                   ],
                 ),
               ),
             )),
       )
     );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void showSnackBar(BuildContext context, String msg) {      //<- Show snack bar.
    var snackBar = SnackBar(
      content: Text(msg),
      // action: SnackBarAction(
      //   label: "UNDO",
      //   textColor: Colors.red,
      //   onPressed: () {
      //     debugPrint("Yes it's undo it!");
      //   },
      // ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

