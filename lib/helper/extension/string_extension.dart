extension StringExtension on String{

  String getExtension(){
    print(this.split(".").last);
    return this.split(".").last;
  }
}