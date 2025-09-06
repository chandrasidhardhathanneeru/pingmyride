import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class ViewAccountsPage extends StatefulWidget {
  const ViewAccountsPage({super.key});

  @override
  State<ViewAccountsPage> createState() => _ViewAccountsPageState();
}

class _ViewAccountsPageState extends State<ViewAccountsPage> {
  List<Map<String, dynamic>> _allAccounts = [];
  UserRole? _filterRole;
  bool _isLoading = true;
  bool _showTestAccountsOnly = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    setState(() {
      _isLoading = true;
    });

    if (_showTestAccountsOnly) {
      // Load pre-defined test accounts
      _allAccounts = DatabaseService.getAllTestAccounts();
    } else {
      // For now, we'll show the test accounts since we don't have 
      // a method to fetch all users from Firestore yet
      _allAccounts = DatabaseService.getAllTestAccounts();
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredAccounts {
    if (_filterRole == null) {
      return _allAccounts;
    }
    return _allAccounts.where((account) => account['role'] == _filterRole).toList();
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.pinkAccent;
      case UserRole.driver:
        return Colors.green;
      case UserRole.student:
        return const Color(0xFF2ECC71);
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.driver:
        return Icons.directions_bus;
      case UserRole.student:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('View All Accounts'),
        backgroundColor: const Color(0xFF0E1112),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<UserRole?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (UserRole? role) {
              setState(() {
                _filterRole = role;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Roles'),
              ),
              ...UserRole.values.map((role) => PopupMenuItem(
                value: role,
                child: Row(
                  children: [
                    Icon(_getRoleIcon(role), color: _getRoleColor(role), size: 20),
                    const SizedBox(width: 8),
                    Text(role.displayName),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle for test accounts
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Switch(
                  value: _showTestAccountsOnly,
                  onChanged: (value) {
                    setState(() {
                      _showTestAccountsOnly = value;
                    });
                    _loadAccounts();
                  },
                  activeColor: const Color(0xFF2ECC71),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Show Test Accounts Only',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Filter info
          if (_filterRole != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getRoleColor(_filterRole!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getRoleColor(_filterRole!).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(_getRoleIcon(_filterRole!), color: _getRoleColor(_filterRole!), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Showing ${_filterRole!.displayName} accounts only',
                    style: TextStyle(color: _getRoleColor(_filterRole!)),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filterRole = null;
                      });
                    },
                    child: const Text('Clear Filter'),
                  ),
                ],
              ),
            ),

          // Accounts list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2ECC71)),
                  )
                : _filteredAccounts.isEmpty
                    ? const Center(
                        child: Text(
                          'No accounts found',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredAccounts.length,
                        itemBuilder: (context, index) {
                          final account = _filteredAccounts[index];
                          final role = account['role'] as UserRole;
                          
                          return Card(
                            color: const Color(0xFF0E1112),
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getRoleColor(role).withOpacity(0.2),
                                child: Icon(
                                  _getRoleIcon(role),
                                  color: _getRoleColor(role),
                                ),
                              ),
                              title: Text(
                                account['username'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    account['email'] as String,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(role).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      role.displayName,
                                      style: TextStyle(
                                        color: _getRoleColor(role),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.key, color: Colors.white54, size: 16),
                                  const SizedBox(height: 4),
                                  Text(
                                    account['password'] as String,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2ECC71),
        onPressed: () {
          Navigator.pushNamed(context, '/create-account');
        },
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
