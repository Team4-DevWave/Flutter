// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   IO.Socket socket;
//   TextEditingController messageController = TextEditingController();
//   List<String> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize mock server
//     MockSocketServer mockServer = MockSocketServer();
//     mockServer.on('connection', (client) {
//       print('Client connected');
//       client.emit('message', 'Welcome to the chat!');
//     });

//     // Connect to mock server
//     socket = IO.io('http://localhost', <String, dynamic>{
//       'transports': ['websocket'],
//       'extraHeaders': {'mock': 'true'}, // Add this header for mock server
//     });

//     // Listen for 'message' event from server
//     socket.on('message', (data) {
//       setState(() {
//         messages.add(data.toString());
//       });
//     });
//   }

//   @override
//   void dispose() {
//     socket.dispose();
//     super.dispose();
//   }

//   void sendMessage(String message) {
//     socket.emit('message', message);
//     setState(() {
//       messages.add('Me: $message');
//     });
//     messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Socket.IO Mock Example'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(messages[index]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(hintText: 'Enter message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     String message = messageController.text;
//                     if (message.isNotEmpty) {
//                       sendMessage(message);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }