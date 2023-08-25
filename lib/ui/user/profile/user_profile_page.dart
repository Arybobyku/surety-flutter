import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/routes.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthProvider>(builder: (context, valueAuth, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                ///  Header
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorPalette.generalSecondaryColor,
                  ),
                  child: Row(
                    children: [
                      CachedNetworkImage(
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
                      SizedBox(width: 10),
                      Expanded(child: Text("${valueAuth.user.fullName}")),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () => Get.toNamed(Routes.userProfileDetail),
                        child: Icon(Icons.edit),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  showBottomModel(BuildContext context, UserModel user) {
    // showMaterialModalBottomSheet(
    //   context: context,
    //   expand: false,
    //   closeProgressThreshold: 230,
    //   builder: (context) {
    //     return SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             SizedBox(height: 10),
    //             Container(
    //               height: 3,
    //               width: 80,
    //               decoration: BoxDecoration(
    //                   color: ColorPalette.generalDarkGrey,
    //                   borderRadius: BorderRadius.circular(10)),
    //             ),
    //             SizedBox(height: 20),
    //             Text(
    //               "Ubah Profile",
    //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //             ),
    //             SizedBox(height: 30),
    //             InputFieldRounded(
    //               label: "Nama Lengkap",
    //               hint: '',
    //               initialValue: user.namaLengkap,
    //               onChange: (val) {
    //                 user.namaLengkap = val;
    //               },
    //               secureText: false,
    //             ),
    //             InputFieldRounded(
    //               label:"Tempat Lahir",
    //               hint: '',
    //               initialValue: user.tempatLahir,
    //               onChange: (val) {
    //                 user.tempatLahir = val;
    //               },
    //               secureText: false,
    //             ),
    //             ButtonRounded(
    //               text: "Update",
    //               onPressed: () {
    //                 doChangeProfile(context, user);
    //               },
    //             ),
    //             SizedBox(height: 30),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

// doChangeProfile(BuildContext context, UserModel user) async {
//   EasyLoading.show(status: "Loading");
//   var result = await Provider.of<AuthProvider>(context, listen: false)
//       .doUpdateProfile(user);
//   result.fold(
//     (l) {
//       EasyLoading.dismiss();
//       Alert(
//         context: context,
//         type: AlertType.error,
//         title: "Error Update",
//         desc: l,
//         buttons: [
//           DialogButton(
//             child: Text(
//               "Close",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () => Navigator.pop(context),
//             color: ColorPalette.generalPrimaryColor,
//             radius: BorderRadius.circular(0.0),
//           ),
//         ],
//       ).show();
//     },
//     (r) {
//       EasyLoading.dismiss();
//       Alert(
//         context: context,
//         type: AlertType.success,
//         title: "Berhasil",
//         desc: "Berhasil update profile",
//         buttons: [
//           DialogButton(
//             child: Text(
//               "Close",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () => Navigator.pop(context),
//             color: ColorPalette.generalPrimaryColor,
//             radius: BorderRadius.circular(0.0),
//           ),
//         ],
//       ).show();
//     },
//   );
// }
}
