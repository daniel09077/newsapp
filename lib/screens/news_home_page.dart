import 'package:flutter/material.dart';
import 'package:news_app/models/news_item.dart'; // Import NewsItem model
import 'package:news_app/widgets/filter_chip_widget.dart'; // Import FilterChipWidget
import 'package:news_app/screens/login_page.dart'; // Import LoginPage for logout
import 'package:news_app/models/user_role.dart'; // Import UserRole
import 'package:news_app/screens/add_news_page.dart'; // Import the new AddNewsPage
import 'package:news_app/screens/news_detail_page.dart'; // Import the new NewsDetailPage
import 'package:news_app/utils/app_constants.dart'; // Import AppConstants
import 'package:news_app/models/user_profile.dart'; // Import UserProfile

class NewsHomePage extends StatefulWidget {
  final UserProfile userProfile; // Updated to receive UserProfile

  const NewsHomePage({super.key, required this.userProfile});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  // State for selected filter
  String _selectedFilter = 'All'; // Default to 'All' for initial display

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();
  // State for the current search query
  String _searchQuery = '';

  // Mock News Data (replace with actual data fetching later)
  final List<NewsItem> _allNews = [
    NewsItem(
      title: 'Registration Deadline Extended',
      content: 'The registration deadline for all students has been extended to January 20th, 2025. Please ensure all outstanding fees are paid.',
      category: AppConstants.categoryAdministration,
      date: DateTime(2025, 1, 15),
    ),
    NewsItem(
      title: 'New Library Hours Announced',
      content: 'Starting next week, the main library will operate from 8 AM to 8 PM on weekdays and 10 AM to 4 PM on Saturdays. Sundays remain closed.',
      category: AppConstants.categoryAdministration,
      date: DateTime(2025, 1, 10),
    ),
    NewsItem(
      title: 'Department of Engineering Workshop on AI',
      content: 'A hands-on workshop on Artificial Intelligence and Machine Learning will be held on February 5th in the Engineering complex, Room 301. Limited seats available, register early!',
      category: AppConstants.categoryDepartment,
      date: DateTime(2025, 1, 20),
    ),
    NewsItem(
      title: 'Student Union Elections Nominations Open',
      content: 'Nominations for the upcoming Student Union elections are now officially open. Interested candidates can pick up nomination forms from the Dean of Students office starting January 25th. Deadline for submission is February 10th.',
      category: AppConstants.categoryStudentBody,
      date: DateTime(2025, 1, 18),
    ),
    NewsItem(
      title: 'Inter-Departmental Sports Festival Kick-off',
      content: 'The annual inter-departmental sports festival will commence on March 1st with an opening ceremony at the main sports complex. Register your teams for football, basketball, volleyball, and track events now!',
      category: AppConstants.categoryStudentBody,
      date: DateTime(2025, 1, 12),
    ),
    NewsItem(
      title: 'Academic Calendar Update for New Session',
      content: 'The updated academic calendar for the new session 2024/2025 is now available on the university portal. Students are advised to review important dates including holidays and examination periods.',
      category: AppConstants.categoryAdministration,
      date: DateTime(2025, 1, 7),
    ),
    NewsItem(
      title: 'Department of Science Research Symposium',
      content: 'The annual Department of Science research symposium will be held on March 10th at the main auditorium. This year\'s theme is "Innovations in Sustainable Technologies." All students and faculty are encouraged to attend and present their research.',
      category: AppConstants.categoryDepartment,
      date: DateTime(2025, 2, 1),
    ),
    NewsItem(
      title: 'Career Fair 2025: Connect with Top Employers',
      content: 'Kaduna Polytechnic is hosting its annual Career Fair on February 28th at the Multi-Purpose Hall. Over 50 companies will be present, offering internship and job opportunities. Bring your CVs!',
      category: AppConstants.categoryAdministration,
      date: DateTime(2025, 2, 15),
    ),
    NewsItem(
      title: 'New Cafeteria Menu Launched',
      content: 'The student cafeteria has launched a new menu with healthier and more diverse options. Feedback forms are available at the counter.',
      category: AppConstants.categoryStudentBody,
      date: DateTime(2025, 2, 10),
    ),
    NewsItem(
      title: 'Department of Business Studies Seminar Series',
      content: 'The Department of Business Studies will host a weekly seminar series every Tuesday at 2 PM in Lecture Hall B, starting February 20th. Guest speakers will cover various aspects of modern business practices.',
      category: AppConstants.categoryDepartment,
      date: DateTime(2025, 2, 12),
    ),
    NewsItem(
      title: 'Security Advisory: Be Vigilant on Campus',
      content: 'Students are advised to remain vigilant and report any suspicious activities to campus security immediately. Ensure doors and windows are locked, especially at night.',
      category: AppConstants.categoryAdministration,
      date: DateTime(2025, 2, 5),
    ),
    NewsItem(
      title: 'Student Innovation Challenge Announced',
      content: 'The annual Student Innovation Challenge is now accepting applications. Form teams and submit your innovative ideas for a chance to win prizes and mentorship. Deadline: March 20th.',
      category: AppConstants.categoryStudentBody,
      date: DateTime(2025, 2, 20),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add a listener to the search controller to update the search query
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  // Function to add a new news item to the list
  void _addNewNewsItem(NewsItem newsItem) {
    setState(() {
      _allNews.insert(0, newsItem); // Add new news to the top of the list
    });
  }

  // Filtered news list based on selected category, user's department, AND search query
  List<NewsItem> get _filteredNews {
    // Start with news filtered by user's assigned department
    List<NewsItem> departmentFilteredNews = _allNews.where((news) {
      // News is relevant if it's Administration, Student Body, or matches the user's specific department
      return news.category == AppConstants.categoryAdministration ||
             news.category == AppConstants.categoryStudentBody ||
             news.category == widget.userProfile.department;
    }).toList();

    // Then, apply the selected filter chip
    if (_selectedFilter == 'All') {
      // If 'All' is selected, also consider the search query
      if (_searchQuery.isEmpty) {
        return departmentFilteredNews;
      } else {
        final lowerCaseQuery = _searchQuery.toLowerCase();
        return departmentFilteredNews.where((news) {
          return news.title.toLowerCase().contains(lowerCaseQuery) ||
                 news.content.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      }
    } else {
      // If a specific filter is selected, apply both category and search filters
      final categoryAndDepartmentFilteredNews = departmentFilteredNews.where((news) => news.category == _selectedFilter).toList();
      if (_searchQuery.isEmpty) {
        return categoryAndDepartmentFilteredNews;
      } else {
        final lowerCaseQuery = _searchQuery.toLowerCase();
        return categoryAndDepartmentFilteredNews.where((news) {
          return news.title.toLowerCase().contains(lowerCaseQuery) ||
                 news.content.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80, // Adjust height for better spacing
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kaduna Polytechnic',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              // Display logged-in user's department and role from UserProfile
              'Student News Hub (${widget.userProfile.department} - ${widget.userProfile.role == UserRole.admin ? "Admin" : "Student"})',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          // Notifications button
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle notifications tap
              },
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              label: const Text('Notifications', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200], // Light grey background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                elevation: 0, // No shadow
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          // Add News button (Visible only to Admins)
          if (widget.userProfile.role == UserRole.admin) // Conditional rendering based on role
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to AddNewsPage
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddNewsPage(
                        onAddNews: _addNewNewsItem, // Pass the callback function
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add News', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                  elevation: 0, // No shadow
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              // Simulate logout by navigating back to the login page
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage(onLoginSuccess: (userProfile) {
                  // This callback will be triggered if the user logs in again
                  // You might want to refresh the main app state here if needed
                })),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Urgent Announcements Banner
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.red[50], // Light red background
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Urgent Announcements: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Registration Deadline Extended to January 20th',
                            style: TextStyle(
                              color: Colors.blue[700], // Blue for the link
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Search Bar
            TextField(
              controller: _searchController, // Assign the controller
              decoration: InputDecoration(
                hintText: 'Search news, announcements...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  borderSide: BorderSide.none, // No border line
                ),
                filled: true,
                fillColor: Colors.grey[200], // Light grey background
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              // No need for onChanged here, as the listener handles it
            ),
            const SizedBox(height: 20),

            // 4. Filter by Text
            const Text(
              'Filter by:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            // 5. Filter Buttons (Chips)
            Wrap(
              spacing: 8.0, // Space between chips
              runSpacing: 8.0, // Space between rows of chips
              children: [
                FilterChipWidget(
                  label: 'All',
                  count: _filteredNews.length, // Count based on currently filtered news
                  isSelected: _selectedFilter == 'All',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? 'All' : '';
                    });
                  },
                ),
                FilterChipWidget(
                  label: AppConstants.categoryAdministration, // Using constant
                  count: _filteredNews.where((news) => news.category == AppConstants.categoryAdministration).length, // Using constant
                  isSelected: _selectedFilter == AppConstants.categoryAdministration, // Using constant
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? AppConstants.categoryAdministration : ''; // Using constant
                    });
                  },
                  icon: Icons.business,
                ),
                FilterChipWidget(
                  label: AppConstants.categoryDepartment, // Using constant
                  count: _filteredNews.where((news) => news.category == AppConstants.categoryDepartment).length, // Using constant
                  isSelected: _selectedFilter == AppConstants.categoryDepartment, // Using constant
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? AppConstants.categoryDepartment : ''; // Using constant
                    });
                  },
                  icon: Icons.school,
                ),
                FilterChipWidget(
                  label: AppConstants.categoryStudentBody, // Using constant
                  count: _filteredNews.where((news) => news.category == AppConstants.categoryStudentBody).length, // Using constant
                  isSelected: _selectedFilter == AppConstants.categoryStudentBody, // Using constant
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? AppConstants.categoryStudentBody : ''; // Using constant
                    });
                  },
                  icon: Icons.people,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 6. Total Announcements Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Announcements',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_filteredNews.length}', // Display count of filtered news
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.description, // Or a custom icon for announcements
                    size: 60,
                    color: Colors.blue[100], // Light blue icon
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 7. News List
            ListView.builder(
              shrinkWrap: true, // Important to make ListView work inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
              itemCount: _filteredNews.length,
              itemBuilder: (context, index) {
                final news = _filteredNews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell( // Make the card tappable
                    onTap: () {
                      // Navigate to NewsDetailPage when card is tapped
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(newsItem: news),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            news.content,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                            maxLines: 3, // Show a few lines of content
                            overflow: TextOverflow.ellipsis, // Add ellipsis if content overflows
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                news.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${news.date.day}/${news.date.month}/${news.date.year}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
