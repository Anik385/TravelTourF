// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:travel_tour_app/services/api_service.dart';
// import 'package:travel_tour_app/constants/api_endpoints.dart';

// class TestConnectionScreen extends StatefulWidget {
//   const TestConnectionScreen({super.key});

//   @override
//   State<TestConnectionScreen> createState() => _TestConnectionScreenState();
// }

// class _TestConnectionScreenState extends State<TestConnectionScreen> {
//   bool _isTesting = false;
//   String _result = '';
//   String _selectedUrl = ApiEndpoints.baseUrl;

//   final List<String> _urls = [
//     'http://10.0.2.2:8080',
//     'http://localhost:8080',
//     'http://192.168.0.158:8080', // Replace with your actual IP
//   ];

//   Future<void> _testConnection() async {
//     setState(() {
//       _isTesting = true;
//       _result = 'Testing connection to: $_selectedUrl';
//     });

//     try {
//       final apiService = ApiService();
//       // Update base URL temporarily
//       final originalUrl = ApiEndpoints.baseUrl;

//       // Test public endpoint
//       final response = await http.get(
//         Uri.parse('$_selectedUrl/api/auth/test-public'),
//         headers: {'Accept': 'application/json'},
//       );

//       setState(() {
//         _result =
//             '''
// ✅ Connection Successful!

// URL: $_selectedUrl
// Status: ${response.statusCode}
// Response: ${response.body}

// Try login with:
// Username: admin123
// Password: admin123
//         ''';
//       });
//     } catch (e) {
//       setState(() {
//         _result =
//             '''
// ❌ Connection Failed!

// URL: $_selectedUrl
// Error: $e

// Possible Solutions:
// 1. Make sure Spring Boot is running
// 2. Check if firewall is blocking port 8080
// 3. Use correct IP address
// 4. Try different URL
//         ''';
//       });
//     } finally {
//       setState(() {
//         _isTesting = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Connection Test')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               value: _selectedUrl,
//               decoration: const InputDecoration(labelText: 'Server URL'),
//               items: _urls.map((url) {
//                 return DropdownMenuItem(value: url, child: Text(url));
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedUrl = value!;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isTesting ? null : _testConnection,
//               child: _isTesting
//                   ? const CircularProgressIndicator()
//                   : const Text('Test Connection'),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Text(
//                   _result,
//                   style: TextStyle(
//                     color: _result.contains('✅') ? Colors.green : Colors.red,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
