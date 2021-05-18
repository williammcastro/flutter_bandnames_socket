import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_service.dart';

//import 'package:socket_io_client/socket_io_client.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
      print('este es: $socketService.toString()');
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text('Server Status'),
            ElevatedButton(
              onPressed: (){
                print('boton conectar presionado');
                var socket2 = new SocketService();
                print('este es socket2: $socket2');
              }, 
              child: Text('Boton conectar')
            )
          ],
        ),
      );

      
  }
}