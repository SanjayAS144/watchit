import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final Map<String, String> movieData;

  StatsGrid(this.movieData);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.25,
      child: Column(
        children: [
          Flexible(
            child: Row(
              children: [
                _buildStateCard(
                    'Release Date', movieData['release'], Colors.red),
                _buildStateCard(
                    'Run Time', '${movieData['runTime']} min', Colors.green),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: [
                _buildStateCard(
                    'Revenue', '\$ ${movieData['revenue']}', Colors.orange),
                _buildStateCard(
                    'Budget', '\$ ${movieData['budget']}', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildStateCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                letterSpacing: 1.6,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 1.5,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
