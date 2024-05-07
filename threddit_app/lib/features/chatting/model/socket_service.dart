import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class SocketService {
   IO.Socket? socket;

  void initSocket() async {
     String? token = await getToken();
     String socketUrl = "http://${AppConstants.local}:3005";
  
    socket = IO.io(socketUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      
      "query":"token=$token",
      
    },
    
    );
    socket?.connect();
    socket?.onConnect((data) {
      //print("Connected");
      socket?.on("message", (msg) {
        print(msg);
        //implement updating the screen
      });
    });
    print(socket?.connected);
  }
}
