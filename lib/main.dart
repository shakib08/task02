import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harry Potter Characters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CharacterListScreen(),
    );
  }
}

class CharacterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harry Potter Characters'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            List<dynamic> characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(characters[index]['image']),
                  ),
                  title: Text(characters[index]['name']),
                  subtitle: Text('Actor: ${characters[index]['actor']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CharacterDetailScreen(character: characters[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CharacterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> character;

  CharacterDetailScreen({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(character['image']),
            SizedBox(height: 20),
            Text('Actor: ${character['actor']}'),
            Text('House: ${character['house']}'),
            Text('Species: ${character['species']}'),
            Text('Gender: ${character['gender']}'),
            Text('Date of Birth: ${character['dateOfBirth']}'),
          ],
        ),
      ),
    );
  }
}

Future<List<dynamic>> fetchCharacters() async {
  final response = await http.get(Uri.parse('https://hp-api.onrender.com/api/characters'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load characters');
  }
}
