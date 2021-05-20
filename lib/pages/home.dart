import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands =  [
    Band(id: '1', name: 'Metallica', votes: 5 ),
    Band(id: '2', name: 'Heroes', votes: 1 ),
    Band(id: '3', name: 'Queen', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 4 )
  ];

  @override
  void initState() { 

    final socketService = Provider.of<SocketService>(context, listen: false );

    socketService.socket.on('active-bands', ( payload ) { //escuchar lo q viene con active-bands
      //listar las bandas en el view de las bandas toca mapearlo primero
      this.bands = (payload as List)
        .map( (band) => Band.fromMap(band) ) //esto crea un iterable pero no es necesariamente una lista
        .toList();  //ahora si la convierto en una lista

      setState(() {});

    });
    super.initState();
  }

@override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false );
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Band Names', style: TextStyle( color: Colors.black87))),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin:EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online ) 
            ? Icon(Icons.check_circle, color: Colors.blue[300]) 
            : Icon(Icons.check_circle, color: Colors.red,) ),
            
          
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => _bandTile( bands[index] ) //opcional BuildContext y el int, ademas se convierte a arrow func
       ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand
      ),
    );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);


    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction){
        print('esta es direction para borrar: $direction');
        print('este es el id para borrar: ${band.id}');
        // llamar el borrado en el server
      },
      background: Container (
        padding: EdgeInsets.only( right: 10.0  ),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text('Delete band', style: TextStyle(color: Colors.white)),
        )
      ),
          child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0,2)),
            backgroundColor: Colors.blue[100],
            ),
          title: Text(band.name),
          trailing: Text('${band.votes}', style: TextStyle(fontSize: 20),),
          onTap: () {
            socketService.emit('vote-band', {'id': band.id } );
            print('acabe de votar por la banda :' + band.id);
          },
        ),
    );
  }



  addNewBand(){

    final textController = new TextEditingController();

    if (Platform.isAndroid){
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text('New Band Name'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () { 
                  addBandToList( textController.text ); 
                } 
              )
            ],
          );
        }
      );
    }

    if (Platform.isIOS){
      showCupertinoDialog(
        context: context, 
        builder: ( _ ) {
          return CupertinoAlertDialog(
            title: Text('New Band Name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList( textController.text )
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context)
              )

            ],
          );
        }
      );
    }
    


    }




  void addBandToList( name ){
    print('este es name en adbantdolist : $name');

    if( name.length > 1){
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 3));
      setState(() { });
      print('presionado boton dentro del if de addBandToList');
    }

    Navigator.pop(context);
  }
}