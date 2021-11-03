import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool back;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.back = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 110,
      width: double.infinity,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Row(
              children: [
                Expanded(
                  child: back
                      ? Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  )
                      : const SizedBox(),
                ),
                Expanded(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )),
    );
  }
}