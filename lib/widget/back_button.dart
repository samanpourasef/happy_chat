import 'package:flutter/material.dart';

class BackButtonRow extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const BackButtonRow({
    Key? key,
    this.text = "بازگشت",
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(text,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
          const SizedBox(width: 3),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xff2434431A),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_forward_outlined,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
