import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;

 SocketService(){
  this._initConfig();
}

void _initConfig(){

print('este es _serverStatus: $_serverStatus');
  
  //Dart client1
  IO.Socket socket = IO.io('http://192.168.1.145:3000/', <String, dynamic>{
    'transports' : ['websocket'],
    'autoConnect': true,
  });

  // //Dart client2
  // IO.Socket socket = IO.io('http://192.168.1.145:3000', 
  // IO.OptionBuilder()
  //     .setTransports(['websocket']) // for Flutter or Dart VM
  //     .build());
  // print('despues de IO:Socket...este es socket: $socket');

  //Conexion1
  socket.onConnect((_) {
    print('app connected');
  });
  socket.onDisconnect((_) => print('app disconnected'));

  // // Conexion 2
  // socket.on('connect', (_) {
  //   print('connectada la vaina');
  // });
  // socket.on('disconnect', (_) => print('disconnect'));



}

}