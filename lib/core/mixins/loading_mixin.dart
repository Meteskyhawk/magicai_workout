import 'package:flutter/material.dart';

mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Widget buildLoadingOverlay({required Widget child}) {
    return Stack(
      children: [
        child,
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
