import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/admin.dart';

class AdminExpertPage extends StatefulWidget {
  const AdminExpertPage({Key? key}) : super(key: key);

  @override
  State<AdminExpertPage> createState() => _AdminExpertPageState();
}

class _AdminExpertPageState extends State<AdminExpertPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: context.read<AdminProvider>()..getExperts())
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Consumer<AdminProvider>(builder: (context, state, _) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.listExperts.length,
                      itemBuilder: (context, index) {
                        final user = state.listExperts[index];
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
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${user.fullName}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (user.expertise != null)
                                      Text(
                                        user.expertise!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return ColorPalette.generalPrimaryColor;
                                      }
                                      return user.allow
                                          ? ColorPalette.generalSecondaryColor
                                          : ColorPalette.generalPrimaryColor;
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  if(user.allow){
                                    context.read<AdminProvider>().disAllowExpert(user);
                                  }else{
                                    context.read<AdminProvider>().allowExpert(user);
                                  }
                                },
                                child: Text(
                                  user.allow ? "Allowed" : "Not Allowed",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
