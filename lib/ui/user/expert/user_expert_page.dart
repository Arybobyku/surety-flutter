import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/extension/form_extension.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/expert_provider.dart';
import 'package:surety/provider/form_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/button_rounded.dart';

class UserExpertPage extends StatefulWidget {
  const UserExpertPage({Key? key}) : super(key: key);

  @override
  State<UserExpertPage> createState() => _UserExpertPageState();
}

class _UserExpertPageState extends State<UserExpertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.generalBackgroundColor,
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ExpertProvider()..getAllExperts(),
          )
        ],
        child: SafeArea(
          child: Column(
            children: [
              ///  Header
              Consumer<AuthProvider>(
                  builder: (context, valueAuth, _) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorPalette.generalSecondaryColor,
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Image.asset("images/expert.png",height: 30),
                              Text("Experts",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Experts",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Consumer<FormProvider>(
                              builder: (context, stateForm, _) {
                                return InkWell(
                                  onTap: () => Get.toNamed(
                                      Routes.userTrackingPage,
                                      arguments: stateForm.formModel),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset("images/cup.png",
                                            width: 30, height: 20),
                                        Text(
                                          "${stateForm.formModel.totalPoints ?? "-"}",
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(width: 10),
                        ],
                      ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text("Our Expert"),
                      ),
                      SizedBox(height: 20),
                      Consumer<ExpertProvider>(builder: (context, state, _) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.experts.length,
                          itemBuilder: (context, index) {
                            final user = state.experts[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: "${user.photoProfile}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(
                                      Icons.person,
                                      size: 50,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => Get.toNamed(
                                          Routes.userFriendsDetailPage,
                                          arguments: user),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text: "${user.fullName}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              children: [
                                                WidgetSpan(
                                                  child: SizedBox(width: 5),
                                                ),
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.stars_sharp,
                                                    size: 16,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "Expert",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (user.bio != null)
                                            Text(
                                              "${user.bio}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ButtonRounded(
                  onPressed: () {
                    Get.toNamed(Routes.webView,
                        arguments:
                            "https://docs.google.com/forms/d/e/1FAIpQLSfJyouWxQ7_hXOGVRq1TY_XnItCWQuWg8XUtbpp4JtSW3y_Mw/viewform");
                  },
                  text: "Noticing Changes? Take Quiz",
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
