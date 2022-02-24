import 'package:flutter/material.dart';
import 'package:wazzaf/widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('حول التطبيق')),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ListView(
              children: [
                getLogoIcon('wazzaff'),
                const SizedBox(
                  height: 16.0,
                ),
                RichText(
                  text: TextSpan(
                    text: 'تطبيق ',
                    style: Theme.of(context).textTheme.bodyText1,
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'وظفني:',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber),),
                    ],
                  ),
                ),
                Text(
                  'تطبيق يسهل على المستخدمين التواصل مع صاحب مهنة معينة.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'ويسهل على صاحب المهنة الحصول على عمل.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 48.0,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Text(
                        'إعداد الطلاب:',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'محمود راجح عمشه',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'لانا عدنان أبو نقطه',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'بإشراف:',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'الدكتور حيدر فاضل الشمري',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'والمهندس عبدو الخوري',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
