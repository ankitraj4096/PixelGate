import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/images/images_bloc.dart';
import '../blocs/images/images_event.dart';
import '../blocs/images/images_state.dart';
import '../models/image_model.dart'; // Make sure this path is correct
import 'login_screen.dart';

// --- MAIN HOME SCREEN WIDGET (Unchanged) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ImagesBloc>().add(FetchImages());
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _refreshImages() async {
    context.read<ImagesBloc>().add(FetchImages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Gallery',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: _AppDrawer(onLogout: _logout),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.2],
          ),
        ),
        child: BlocBuilder<ImagesBloc, ImagesState>(
          builder: (context, state) {
            if (state is ImagesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ImagesLoaded) {
              return RefreshIndicator(
                onRefresh: _refreshImages,
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(12, kToolbarHeight + 40, 12, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: state.images.length,
                  itemBuilder: (context, index) {
                    final image = state.images[index];
                    return _ImageGridTile(image: image);
                  },
                ),
              );
            }

            if (state is ImagesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('Error Loading Images', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(state.error, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: _refreshImages, child: const Text('Retry')),
                  ],
                ),
              );
            }

            return const Center(child: Text('Welcome! Pull down to load images.'));
          },
        ),
      ),
    );
  }
}

// **MODIFIED WIDGET**: The App Drawer now has the requested gradient and padding.
class _AppDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const _AppDrawer({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // **CHANGE 1**: Gradient now matches the home screen (blue to white at 20%).
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.2],
          ),
        ),
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white, // Icon stays white on the blue background
                    size: 80,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User',
                    style: TextStyle(
                      color: Colors.black, // Text stays white
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // **CHANGE 2**: Increased bottom padding for the logout button.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: ListTile(
                // **CHANGE 3**: Changed colors to be visible on the white background.
                leading: Icon(Icons.logout, color: Colors.grey.shade800),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.grey.shade800,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onLogout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- EXTRACTED WIDGET FOR A SINGLE IMAGE TILE (Unchanged) ---
class _ImageGridTile extends StatelessWidget {
  const _ImageGridTile({required this.image});

  final ImageModel image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(3, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              image.downloadUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 32));
              },
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.6],
                    colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    image.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${image.id}  -  ${image.width}x${image.height}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
