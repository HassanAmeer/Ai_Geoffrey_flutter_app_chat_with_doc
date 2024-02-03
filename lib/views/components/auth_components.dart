import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

enum Type { password, withoutPassword }

class CustomContainer extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final Type type;
  final TextEditingController? controller;

  const CustomContainer(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.type});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textFieldColor,
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 60,
      child: TextFormField(
        obscureText: widget.type == Type.password ? isPassword : false,
        cursorColor: Colors.grey,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.type == Type.password
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                  icon: isPassword ? const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ) : const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: AppColors.textFieldColor,
          prefixIcon: Icon(
            widget.icon,
            color: Colors.grey,
          ),
          prefixIconColor: Colors.grey,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {

  final bool loading;
  final String text;
  final Function()? onPressed;
  const CustomButton({super.key, required this.text, this.onPressed, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff324EFF),
        borderRadius: BorderRadius.circular(100),
      ),
      child: loading ? const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ) : TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

enum Status {blue, grey}
class CustomButton2 extends StatelessWidget {

  final Status color;
  final bool loading;
  final String text;
  final Function()? onPressed;
  const CustomButton2({super.key, required this.text, this.onPressed, required this.loading, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 60,
      decoration: BoxDecoration(
        color: color == Status.blue ? const Color(0xff324EFF) : const Color(0xff29374F),
        borderRadius: BorderRadius.circular(100),
      ),
      child: loading ? const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ) : TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color == Status.blue ? const Color(0xffFFFFFF) : const Color(0xff959DAE),
          ),
        ),
      ),

    );
  }
}

class CustomContainer2 extends StatelessWidget {

  final String text;
  final AssetImage icon;
  final GestureTapCallback onPressed;

  const CustomContainer2({super.key, required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: AppColors.textFieldColor,
          ),
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            ImageIcon(
              icon,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.17,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
