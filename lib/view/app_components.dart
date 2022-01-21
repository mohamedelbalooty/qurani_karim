import 'package:flutter/material.dart';
import 'package:qurany_karim/utils/constants/colors.dart';

AppBar buildDefaultAppBar({@required String title}) => AppBar(
  automaticallyImplyLeading: true,
  title: Text(title),
);

class BuildDefaultButton extends StatelessWidget {
  final double height, width, radius;
  final color;
  final String title;
  final Function onClick;

  const BuildDefaultButton(
      {@required this.title,
      @required this.onClick,
      this.height = 50.0,
      this.width = double.infinity,
        this.color = thirdColor,
      this.radius = 25.0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1.5, 1.5),
              blurRadius: 2,
              spreadRadius: 2
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}

BorderRadius defaultBorderRadius() => const BorderRadius.all(Radius.circular(10.0),);

LinearGradient defaultGradient() => LinearGradient(
    colors: [Colors.purple.shade400, Colors.indigoAccent.shade400],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft);

SizedBox bigVerticalSpace() => const SizedBox(height: 30);
SizedBox mediumVerticalSpace() => const SizedBox(height: 20);
SizedBox minimumVerticalSpace() => const SizedBox(height: 10);

SizedBox mediumHorizontalSpace() => const SizedBox(width: 20);
SizedBox minimumHorizontalSpace() => const SizedBox(width: 10);


void namedNavigator(BuildContext context, String routeName){
  Navigator.pushNamed(context, routeName);
}
void replacementNamedNavigator(BuildContext context, String routeName){
  Navigator.pushReplacementNamed(context, routeName);
}
void materialNavigator(BuildContext context, Widget screen){
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen),);
}