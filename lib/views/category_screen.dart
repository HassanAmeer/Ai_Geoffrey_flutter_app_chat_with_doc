import 'package:ask_geoffrey/categorieslist.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/views/new_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.textFieldColor,
        title: const Text("Categories"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8.0),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: ListView.builder(
          itemCount: categoris.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: ExpansionTile(
                title: Text(categoris[index].name, style: const TextStyle(
                  color: Colors.white
                ),),
                backgroundColor: AppColors.textFieldColor,
                collapsedBackgroundColor: AppColors.textFieldColor,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                textColor: Colors.white,
                children: categoris[index]
                    .items
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(3.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => NewChatScreen(
                                prompt: e,
                              ),
                            );
                          },
                          child: Text(e),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
