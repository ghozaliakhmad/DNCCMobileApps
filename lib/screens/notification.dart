import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('Notification', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Today', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          _notifItem('Exciting news! There\'s a fresh freelance opportunity waiting for you. Don\'t miss o...', '1h ago', true),
          _notifItem('Hey there! You\'ve got a new message waiting for you. Open it now to stay...', '2h ago', false),
          _notifItem('Great news! We\'ve just added new freelance opportunities that match your...', '3h ago', false),
        ],
      ),
    );
  }

  Widget _notifItem(String text, String time, bool isUnread) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
        child: const Icon(Icons.email, color: Colors.black54),
      ),
      title: Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
      subtitle: Text(time, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
      trailing: isUnread ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF6AB04C), shape: BoxShape.circle)) : null,
    );
  }
}