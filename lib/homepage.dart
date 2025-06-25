import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'button.dart'; // Import the button.dart file
import 'category_items.dart'; // Import the categoryItems map
import 'category_item_button.dart'; // Import the CategoryItemButton widget

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _searchVisible = false;
  bool _showCategories = true;
  String _selectedCategory = 'News';
  bool _isLoading = true;

  List<String> images = [
    'assets/images/tv.jpg',
    'assets/images/tv.jpg',
    'assets/images/tv.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategoryData();
  }

  Future<void> _fetchCategoryData() async {
    await CategoryItems.fetchData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131A28), // Set background color for the entire page
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Color(0xFF131A28), // Updated app bar background color
          elevation: 0, // No shadow
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png', // Ensure correct path
              width: 40, // Adjust the width as needed
              height: 40, // Adjust the height as needed
            ),
          ),
          title: _searchVisible
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2), // Off-white color
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white), // White search icon
              onPressed: () {
                setState(() {
                  _searchVisible = !_searchVisible;
                });
              },
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white), // White menu icon
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Color(0xFF131A28), // Set the same background color as the homepage
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF131A28), // Same color as homepage
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text('About Developer', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle about developer tap
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF131A28),
                      title: Text('About Developer', style: TextStyle(color: Colors.white)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/dev.png', // Path to the developer's photo
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Md Ariful Islam is a software developer...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(10.0), // Reduced padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showCategories = true;
                                _selectedCategory = 'News';
                              });
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            child: Text('Live TV', style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(width: 10), // Add a small gap between buttons
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showCategories = false;
                                _selectedCategory = '';
                              });
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            child: Text('Radio', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200, // Adjust the height as needed
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                      ),
                      items: images.map((String imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                  image: AssetImage(imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    if (_showCategories) // Show categories if _showCategories is true
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                            ...CategoryItems.categoryItems.entries.map((entry) {
                              return CategoryButton(
                                text: entry.key,
                                onPressed: () {
                                  setState(() {
                                    _selectedCategory = entry.key;
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ]),
                ),
                if (_selectedCategory.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          var item = CategoryItems.categoryItems[_selectedCategory]![index];
                          return CategoryItemButton(
                            imagePath: item['image']!,
                            text: item['text']!,
                            videoUrl: item['videoUrl']!,
                          );
                        },
                        childCount: CategoryItems.categoryItems[_selectedCategory]!.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _calculateCrossAxisCount(context), // Dynamic cross axis count
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.0, // Adjust aspect ratio as needed
                      ),
                    ),
                  ),
                if (!_showCategories && _selectedCategory.isEmpty) // Show message if no category is selected
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Our team is working with the radio.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    // Calculate number of items per row based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
    }
    return crossAxisCount;
  }
}
