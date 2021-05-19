import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_service.dart';

//import 'package:socket_io_client/socket_io_client.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    //socketService.socket.emit('event','hola');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text('Server Status : ${ socketService.serverStatus }')
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: (){
            //tarea
            //socketService.socket.emit('nuevo-mensaje', { //otra forma mas explicita
            socketService.emit('nuevo-mensaje', {  //forma mas reducida
              'nombre': 'William', 
              'mensaje':'hola desde flutter'});

          },
        ),
      );
  }
}