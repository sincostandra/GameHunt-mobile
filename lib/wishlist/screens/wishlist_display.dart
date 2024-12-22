import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gamehunt/widgets/left_drawer.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:http/http.dart' as http;

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<dynamic> wishlist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/wishlist/get-wishlist/');
      setState(() {
        wishlist = response['wishlist'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String id, int index) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
        'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/wishlist/delete-wishlist-flutter/$id/',
        {},
      );

      if (response['status'] == 'success') {
        final removedItem = wishlist[index];
        
        // Remove from data first
        setState(() {
          wishlist.removeAt(index);
        });

        // Then animate the removal
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _buildWishlistCard(removedItem, isAnimating: true),
            ),
          ),
          duration: const Duration(milliseconds: 300),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Update _buildAnimatedWishlistCard to use key
  Widget _buildAnimatedWishlistCard(dynamic wishlistItem, Animation<double> animation) {
    return SizeTransition(
      key: ValueKey(wishlistItem['id']), // Add key
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: _buildWishlistCard(wishlistItem, isAnimating: true),
      ),
    );
  }

  Widget _buildWishlistEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Your Wishlist is Empty',
            style: TextStyle(
              fontSize: 22,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add some games to your wishlist to get started!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistCard(dynamic wishlistItem, {bool isAnimating = false}) {
    return Card(
      elevation: isAnimating ? 0 : 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wishlistItem['game__name'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.developer_board,
              label: 'Developer',
              value: wishlistItem['game__developer'],
            ),
            _buildDetailRow(
              icon: Icons.category,
              label: 'Genre',
              value: wishlistItem['game__genre'],
            ),
            _buildDetailRow(
              icon: Icons.price_change,
              label: 'Price',
              value: 'Rp ${wishlistItem['game__harga']}',
            ),
            _buildDetailRow(
              icon: Icons.star_rate,
              label: 'Ratings',
              value: wishlistItem['game__ratings'].toString(),
            ),
            _buildDetailRow(
              icon: Icons.store,
              label: 'Store',
              value: wishlistItem['game__toko1'],
            ),
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Address',
              value: wishlistItem['game__alamat1'],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => removeFromWishlist(
                    wishlistItem['id'], wishlist.indexOf(wishlistItem)),
                icon: const Icon(Icons.delete),
                label: const Text('Remove from Wishlist'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF44336);

    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      drawer: const LeftDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlist.isEmpty
              ? _buildWishlistEmptyState()
              : AnimatedList(
                  key: _listKey,
                  initialItemCount: wishlist.length,
                  itemBuilder: (context, index, animation) {
                    return _buildAnimatedWishlistCard(
                        wishlist[index], animation);
                  },
                ),
    );
  }
}
