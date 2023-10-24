import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final int weekDayQuestionCount;
  final int totalCount;
  final String label;
  ChartBar(
      {required this.weekDayQuestionCount,
      required this.totalCount,
      required this.label});

  // calculate the percentage so that we can dispaly the fractionally sized box properly

  double get getPercentage {
    if (totalCount == 0) {
      return 0;
    }

    return weekDayQuestionCount / totalCount;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                weekDayQuestionCount.toString(),
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                // a containter to define the percentage of questions solved in that particular day relative to the total count

                FractionallySizedBox(
                  heightFactor: getPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: FittedBox(
              child: Text(
                label,
                style: TextStyle(fontSize: 15),
              ),
            ),
          )
        ],
      );
    });
  }
}
