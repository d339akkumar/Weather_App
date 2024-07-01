import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(5.0), // Rounded corners
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          hintText: 'Enter city name',
          border: InputBorder.none, // Remove TextField default border
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
