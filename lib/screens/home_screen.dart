import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tot_app/provider/dog_provider.dart';
import 'package:tot_app/dog_model.dart';
import 'package:tot_app/screens/dog_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  var _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DogProvider>().fetchDogs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Dog> _filterDogs(List<Dog> dogs) => dogs.where((dog) => 
    dog.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
    dog.breed.toLowerCase().contains(_searchQuery.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tale of Tails', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search dogs by name or breed',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: Consumer<DogProvider>(
              builder: (context, dogProvider, child) {
                if (dogProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  );
                }

                final filteredDogs = _filterDogs(dogProvider.dogs);

                if (dogProvider.dogs.isEmpty) {
                  return _EmptyStateWidget(
                    icon: Icons.pets, 
                    message: 'No dogs found'
                  );
                }

                if (filteredDogs.isEmpty) {
                  return _EmptyStateWidget(
                    icon: Icons.search_off, 
                    message: 'No dogs match your search'
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDogs.length,
                  itemBuilder: (context, index) => _DogListItem(dog: filteredDogs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyStateWidget({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _DogListItem extends StatelessWidget {
  final Dog dog;

  const _DogListItem({required this.dog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
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
        ),
        title: Text(
          dog.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          dog.breed,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DogDetailScreen(dog: dog),
          ),
        ),
      ),
    );
  }
}