import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/constants.dart';
import 'package:surety/helper/enum/form_enums.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/helper/extension/form_extension.dart';
import 'package:surety/local_storage_service.dart';
import 'package:surety/provider/article_provider.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/form_provider.dart';
import 'package:surety/provider/product_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/setup_locator.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  bool getData = true;
  bool alreadyShowDialog = false;
  int selectedIndex = Get.arguments ?? 0;

  List<String> history = [];
  var storageService = locator<LocalStorageService>();

  @override
  void initState() {
    if (getData) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ArticleProvider()..getAllArticles(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider()..getAllProducts(),
        ),
        ChangeNotifierProvider.value(
          value: context.read<FormProvider>()
            ..getFormById(context.read<AuthProvider>().user),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Consumer2<AuthProvider, FormProvider>(
                builder: (context, valueAuth, stateForm, _) {
              if (stateForm.dailyLogin && !alreadyShowDialog) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Alert(
                    context: context,
                    type: AlertType.none,
                    content: Column(
                      children: [
                        Image.asset(
                          "images/cup.png",
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Congratulation you get 1 point from daily login",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Get.back(),
                        color: ColorPalette.generalPrimaryColor,
                        radius: BorderRadius.circular(0.0),
                      ),
                    ],
                  ).show();
                });
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///  Header
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorPalette.generalSecondaryColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hello, ${valueAuth.user.fullName}"),
                              SizedBox(height: 5),
                              Text(
                                "Good Afternoon",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Consumer<FormProvider>(
                                builder: (context, stateForm, _) {
                              return InkWell(
                                onTap: () => Get.toNamed(
                                  Routes.userTrackingPage,
                                  arguments: stateForm.formModel,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset("images/cup.png",
                                        width: 30, height: 20),
                                    Text(
                                      "${stateForm.formModel.totalPoints}",
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.userProfileDetail);
                          },
                          child: CachedNetworkImage(
                            imageUrl: valueAuth.user.photoProfile ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              width: 50.0,
                              height: 50.0,
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
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///  Banner
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: ColorPalette.generalPrimaryColor,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(Constants.banner),
                        ),
                      ),
                    ),
                  ),

                  /// Content
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        /// mood content
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "How are you feeling today?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Consumer<FormProvider>(
                            builder: (context, stateForm, _) {
                          return Container(
                            height: 25,
                            width: double.infinity,
                            child: GridView.builder(
                              itemCount: moodStickers.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.55,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (stateForm.formModel.dailyMood == null) {
                                      context.read<FormProvider>().update(
                                            FormType.Mood,
                                            moodStickers[index].values.first,
                                            context.read<AuthProvider>().user,
                                          );
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: stateForm.formModel.mood
                                                  .firstWhereOrNull((element) =>
                                                      (element.value ==
                                                          moodStickers[index]
                                                              .values
                                                              .first) &&
                                                      element.date.isSameDate(
                                                          DateTime.now())) !=
                                              null
                                          ? ColorPalette.generalDarkPrimaryColor
                                          : null,
                                    ),
                                    child: Text(
                                      moodStickers[index].values.first,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),

                        /// Article
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Articles",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                "see all",
                                style: TextStyle(
                                  color: ColorPalette.generalPrimaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Consumer<ArticleProvider>(builder: (context, state, _) {
                          return Container(
                            width: double.infinity,
                            height: 230,
                            child: ListView.builder(
                              itemCount: state.articles.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final article = state.articles[index];
                                return InkWell(
                                  onTap: () => Get.toNamed(
                                      Routes.userArticleDetail,
                                      arguments: article),
                                  child: Container(
                                    width: 250,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all()),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  article.picture!),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          article.title ?? "-",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: article.userModel
                                                      ?.photoProfile ??
                                                  "",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 40.0,
                                                height: 40.0,
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
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.person,
                                                size: 40,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  article.userModel?.fullName ??
                                                      "-",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  article.createdAt ?? "-",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),

                        /// Products
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Products",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                "see all",
                                style: TextStyle(
                                  color: ColorPalette.generalPrimaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Consumer<ProductProvider>(
                          builder: (context, state, _) {
                            return Container(
                              width: double.infinity,
                              height: 210,
                              child: ListView.builder(
                                itemCount: state.products.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = state.products[index];
                                  return InkWell(
                                    onTap: () => Get.toNamed(
                                        Routes.userProductDetail,
                                        arguments: product),
                                    child: Container(
                                      width: 250,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            ColorPalette.generalBackgroundColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    product.picture!),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            product.title ?? "-",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "\$${product.price}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Buy',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  doSignOut(BuildContext context) async {
    EasyLoading.show(status: "Loading...");
    var result =
        await Provider.of<AuthProvider>(context, listen: false).doSignOut();
    result.fold((l) {
      EasyLoading.dismiss();
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: l,
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: ColorPalette.generalPrimaryColor,
            radius: BorderRadius.circular(0.0),
          ),
        ],
      ).show();
    }, (r) {
      EasyLoading.dismiss();
      Get.offAllNamed(Routes.login);
    });
  }
}
