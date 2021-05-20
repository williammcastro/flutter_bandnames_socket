import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

 SocketService(){
  this._initConfig();
}

void _initConfig(){
  //print('dentro del initConfig');
  //Dart client1 conexion de flutter al servidor node
  this._socket = IO.io('http://192.168.1.145:3000/', <String, dynamic>{
    'transports' : ['websocket'],
    'autoConnect': true,
  });

  
  this._socket.onConnect((_) {
    print('app connected');
    this._serverStatus = ServerStatus.Online;
    notifyListeners();
  });
  this._socket.onDisconnect((_) {
    print('app disconnected');
    this._serverStatus = ServerStatus.Offline;
    notifyListeners();
  });

 
}

}