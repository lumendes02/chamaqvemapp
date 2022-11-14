import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableImage extends StatelessWidget {
  const SelectableImage({
    Key? key,
    required this.isSelected,
    required this.imageAsset,
    required this.onTap,
  }) : super(key: key);
  final bool isSelected;
  final String imageAsset;
  final void Function(String imageAsset) onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(imageAsset),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 3,
                  color: isSelected ? Colors.purple : Colors.transparent)),
          child: Image.network(imageAsset),
        ),
      ),
    );
  }
}
