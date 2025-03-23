import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wellfi2/components/CustomAppBar.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar('Leaderboard'),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top 3 Leaderboard Graphic
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: _buildBar(130, Colors.red, "2nd",
                          "https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg")),
                  SizedBox(width: 14),
                  Expanded(
                    child: _buildBar(200, Colors.blue, "1st",
                        "https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg"),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                      child: _buildBar(60, Colors.green, "3rd",
                          "https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg")),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: List.generate(
                7,
                (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.yellow,
                          child: Text(
                            (index + 4).toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg"),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'User ${index + 4}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Text(
                          '${(1000 - index * 50)} pts',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(int height, Color color, String text, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(image),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: height.toDouble(),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            gradient: LinearGradient(
              colors: [color.withOpacity(1), color.withOpacity(0.2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey.shade200,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
