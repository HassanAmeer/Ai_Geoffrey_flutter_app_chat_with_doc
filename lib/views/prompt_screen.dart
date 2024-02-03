import 'package:ask_geoffrey/categorieslist.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/views/new_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PromptsScreen extends StatefulWidget {
  const PromptsScreen({Key? key}) : super(key: key);

  @override
  State<PromptsScreen> createState() => _PromptsScreenState();
}

class _PromptsScreenState extends State<PromptsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.textFieldColor,
        title: const Text('All-Prompts'),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
         color: AppColors.backgroundColor
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              promptList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget promptList() {
    return Expanded(
      child: ListView.builder(
          itemCount: prompts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                  //color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    width: 2,
                    color: AppColors.textFieldColor,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => NewChatScreen(
                        prompt: prompts[index].prompt,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        height: 45.h,
                        //width: 45.w,
                        decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Image.asset("assets/images/splash_logo.png"),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        prompts[index].name,
                        style: const TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
