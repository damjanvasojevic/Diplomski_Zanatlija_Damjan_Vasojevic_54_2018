import 'package:flutter/material.dart';
import 'package:zanatlija_app/data/models/craft.dart';

class AnalyticsWidget extends StatelessWidget {
  final List<Craft> crafts;
  const AnalyticsWidget(this.crafts, {super.key});

  @override
  Widget build(BuildContext context) {
    final rateNumbers = crafts.where((e) => e.rate != null).toList().length;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.235,
      width: MediaQuery.of(context).size.width * 0.635,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height * 0.235,
            width: MediaQuery.of(context).size.width * 0.635,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analitika',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$rateNumbers',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 37,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Ukupno\nOcena',
                        style: TextStyle(
                            color: Color(0xff9A9898),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Nude zanat',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        crafts.length.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Traže zanat',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(1, -1),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.height * 0.1,
              alignment: const AlignmentDirectional(1.05, -1.05),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).backgroundColor,
                  ),
                  color: Theme.of(context).backgroundColor,
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(40))),
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
