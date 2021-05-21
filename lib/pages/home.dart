import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

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

    socketService.socket.on('active-bands', _handleActiveBands); //escuchar lo q viene con active-bands
    //socketService.socket.on('active-bands', _handleActiveBands); //mas listeners y queda ordenado
    //socketService.socket.on('active-bands', _handleActiveBands); //mas listeners y queda ordenado

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    //lo quite del initState(){} lineas 32- 35 para que quede mas facil de leer!!!
     //listar las bandas en el view de las bandas toca mapearlo primero
      this.bands = (payload as List)
        .map( (band) => Band.fromMap(band) ) //esto crea un iterable pero no es necesariamente una lista
        .toList();  //ahora si la convierto en una lista

      setState(() {});
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
      body: Column(
              children:<Widget>[
                _showGraph(),
                Expanded(
                  child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index) => _bandTile( bands[index] ) //opcional BuildContext y el int, ademas se convierte a arrow func
                  ),
                ),
              ]
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
      onDismissed: (DismissDirection direction){//Se puede reemplasar "DismissDirection direction" por "_"
        print('esta es direction para borrar: $direction');//puedo saber la dir del dismiss
        print('este es el id para borrar: ${band.id}');//este es el id de band

        // llamar el borrado en el server
        socketService.emit('delete-band', {'id': band.id } );
        print('acabe de borrar la banda :' + band.id);
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

    if( name.length > 1){
      print('este es name en addBandToList : $name');

      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.emit('add-band', { 'name': name } );
      print('acabe de votar por la banda :' + name );

      // this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 3));
      //setState(() { });
      // print('presionado boton dentro del if de addBandToList');
    }

    Navigator.pop(context);
  }

  //Mostrar la grafica:
  _showGraph(){
    
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
     });
  

  return Container(
    padding: EdgeInsets.only(left: 10.0),
    width: double.infinity,
    height: 200,
    child: PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
    )
  );

  }
}