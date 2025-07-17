import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/ui/vm/flutter_helper_kit_vm.dart';
import 'package:flutter_helper_kit/widgets/custom_indicator.dart';
import 'package:flutter_helper_kit/widgets/marquee_widget.dart';
import 'package:flutter_helper_kit/widgets/rating_bar_widget.dart' hide RatingBarWidget;
import 'package:flutter_helper_kit/widgets/read_more_text.dart';
import 'package:flutter_helper_kit/widgets/rounded_checkbox_widget.dart';
import 'package:flutter_helper_kit/widgets/separated_column.dart';
import 'package:flutter_helper_kit/widgets/text_avatar.dart';
import 'package:flutter_helper_kit/widgets/text_icon_widget.dart';
import 'package:flutter_helper_kit/widgets/timer_builder.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' hide Marquee, DirectionMarguee, RoundedCheckBox, TextIcon, ReadMoreText, TrimMode;

class FlutterHelperKit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FlutterHelperKitState();
  }
}

class FlutterHelperKitState
    extends BaseVMStatefulWidget<FlutterHelperKit, FlutterHelperKitVM> {
  @override
  String setTitle() => "FlutterHelperKit";

  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      child: WidgetPaddingX(
        SeparatedColumn(
          separatorBuilder: (BuildContext context, int index) => Container(
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(vertical: 15),
          ),
          children: [
            Text("Hello").intoShapeClip(
              height: 70,
              borderRadius: 12,
              backgroundColor: Colors.green,
              borderColor: Colors.blue,
              borderWidth: 2,
            ),
            TimerBuilder.periodic(
              Duration(seconds: 5),
              builder: (context) {
                return Text(
                  'Current Time: ${DateTime.now()}',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                );
              },
            ),

            //The `ReadMoreText` widget allows you to display a portion of a long text and provide a "read more" link to expand the text. You can also collapse the text back with a "read less" link.
            ReadMoreText(
              'This is a very long text that needs to be trimmed.\nClick on the "read more" link to see the full text.\nClick on the "read less" link to collapse the text.',
              trimLines: 2,
              trimMode: TrimMode.line,
              trimCollapsedText: '...read more',
              trimExpandedText: ' read less',
              style: TextStyle(color: Colors.black),
              colorClickableText: Colors.blue,
              textAlign: TextAlign.start,
            ),

            TextIcon(
              text: 'Hello World',
              textStyle: TextStyle(color: Colors.blue, fontSize: 18),
              prefix: Icon(Icons.star, color: Colors.yellow),
              suffix: Icon(Icons.arrow_forward, color: Colors.red),
              spacing: 8,
              maxLine: 1,
              onTap: () {
                print('TextIcon tapped!');
              },
              edgeInsets: EdgeInsets.all(10),
              expandedText: true,
              useMarquee: false,
              boxDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            TextAvatar(
              text: 'Flutter Helper Kit',
              style: TextStyle(color: Colors.black),
            ),

            RoundedCheckBox(
              isChecked: true,
              borderColor: Colors.grey,
              onTap: (isChecked) {
                print('Checkbox is now: $isChecked');
              },
              text: 'Accept Terms',
            ),

            //The `RatingBarWidget` is a customizable rating bar widget for Flutter. It allows users to select a rating by tapping on icons. The widget supports half ratings, customizable icons, colors, and spacing between icons.
            RatingBarWidget(
              rating: 3.5,
              onRatingChanged: (newRating) {
                print('Rating changed: $newRating');
              },
              activeColor: Colors.yellow,
              inActiveColor: Colors.grey,
              size: 40,
              allowHalfRating: true,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              spacing: 4.0,
              disable: false,
            ),

            Marquee(
              child: Text(
                'Flutter Helper Kit example using the Marquee widget.',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              direction: Axis.horizontal,
              textDirection: TextDirection.ltr,
              animationDuration: Duration(milliseconds: 3000),
              backDuration: Duration(milliseconds: 2000),
              pauseDuration: Duration(milliseconds: 1000),
              directionMarguee: DirectionMarguee.twoDirection,
            ),

            GradientWidget(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: const Text('Gradient Text Gradient Text'),
            ),

            MultiTapDetector(
              tapCount: 2, // Double tap
              onTap: () => {
                Get.showSnackbar(
                  GetSnackBar(
                    title: "提示",
                    message: "Double tapped！",
                    duration: const Duration(seconds: 2),
                  ),
                ),
              },
              child: Container(
                height: 100,
                color: Colors.blue,
                child: const Center(child: Text('Double tap me!')),
              ),
            ),
            Blur(
              child: const Text('Blur Text',  style: TextStyle(color: Colors.black),),
            ),
            AppTextField(
              controller: TextEditingController(), // Optional
              textFieldType: TextFieldType.EMAIL,
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            AppTextField(
              controller: TextEditingController(), // Optional
              textFieldType: TextFieldType.PASSWORD,
              decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            SizeListener(
              child: Container(width: 200,height: 100,color: Colors.deepPurple,),
              onSizeChange: (size) {
                log(size.width.toString());
              },
            ),
            GradientBorder(
              gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.yellow,
                  Colors.pink,
                ],
              ),
              strokeWidth: 4.0,
              child: Container(width: 200,height: 100,color: Colors.blue,),
            ),
            AppButton(
              text: "Submit",
              color: Colors.green, // Optional
              onTap: () {
                //Your logic
              },
            ),

            // HoverWidget(
            //     opaque:true,
            //   builder: (_, isHovering) {
            //     return Container(width: 200,height: 100,color: Colors.blue,);
            //   },
            // ),


            DoublePressBackWidget(
                child: Container(width: 200,height: 100,color: Colors.blue),
                onWillPop: (){
                  showToast("DoublePressBackWidget");

                },
                message: 'Your message' // Optional
            ),

            SettingSection(
              title: Text('Account Management', style: boldTextStyle(size: 24)),
              subTitle: Text('Control your account', style: primaryTextStyle()), // Optional
              items: [
                SettingItemWidget(
                    title: 'Hibernate account',
                    subTitle: 'Temporary deactivate your account',
                    decoration: BoxDecoration(borderRadius: radius()),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded, color: context.dividerColor),
                    onTap: () {
                      //
                    }
                ),
                SettingItemWidget(
                  title: 'Close account',
                  subTitle: 'Learn about your options, and close your account if you wish',
                  decoration: BoxDecoration(borderRadius: radius()),
                  trailing: Icon(Icons.keyboard_arrow_right_rounded, color: context.dividerColor),
                  onTap: () {
                    //
                  },
                )
              ],
            ),

            PlaceHolderWidget(width: 200,height: 100,animationDuration: Duration(milliseconds: 500),color:Colors.deepPurple),


            // CustomIndicator(
            //   isActive: true,
            //   //A boolean value that determines whether the overlay indicator is shown. If set to true, the overlay indicator is displayed.
            //   opacity: 0.6,
            //   //The value should be between 0.0 and 1.0, where 0.0 is fully transparent and 1.0 is fully opaque. In the example above, it is set to 0.6.
            //   bgColor: Colors.grey,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [Text('Screen1', style: TextStyle(color: Colors.black))],
            //   ),
            // ),
          ],
        ),
      ).paddingSymmetric(horizontal: 16),
    );
  }

  @override
  FlutterHelperKitVM createViewModel() => FlutterHelperKitVM();

  @override
  void initData() {}
}
