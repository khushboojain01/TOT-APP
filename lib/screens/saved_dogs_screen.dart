import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tot_app/provider/dog_provider.dart';
import 'package:tot_app/dog_model.dart';
import 'package:tot_app/screens/dog_detail_screen.dart';

class SavedDogsScreen extends StatefulWidget {
  const SavedDogsScreen({super.key});

  @override
  _SavedDogsScreenState createState() => _SavedDogsScreenState();
}

class _SavedDogsScreenState extends State<SavedDogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DogProvider>(context, listen: false).loadSavedDogs();
    });
  }

  void _showDeleteConfirmation(Dog dog) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Saved Dog'),
        content: Text('Are you sure you want to remove "${dog.name}" from your saved dogs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (dog.id != null) {
                Provider.of<DogProvider>(context, listen: false).removeSavedDog(dog.id!);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Dogs', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<DogProvider>(
        builder: (context, dogProvider, child) {
          if (dogProvider.savedDogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 100, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text(
                    'No saved dogs yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: dogProvider.savedDogs.length,
            itemBuilder: (context, index) {
              Dog dog = dogProvider.savedDogs[index];
              return _buildSavedDogCard(dog);
            },
          );
        },
      ),
    );
  }

  Widget _buildSavedDogCard(Dog dog) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: _buildDogAvatar(dog),
        title: Text(
          dog.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          dog.breed,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: const Color.fromARGB(255, 128, 32, 25)),
          onPressed: () => _showDeleteConfirmation(dog),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DogDetailScreen(dog: dog, isSaved: true),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDogAvatar(Dog dog) {
    return Hero(
      tag: 'dog_image_${dog.name}',
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[200],
        backgroundImage: dog.imageUrl != null && dog.imageUrl!.isNotEmpty
            ? CachedNetworkImageProvider(dog.imageUrl!)
            : null,
        child: dog.imageUrl == null || dog.imageUrl!.isEmpty
            ? Icon(Icons.pets, color: Colors.grey[600])
            : null,
      ),
    );
  }
}