import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PredictionChart extends StatelessWidget {
  final double rfScore;
  final double xgbScore;
  final double catScore;
  final double lgbmScore;

  const PredictionChart({
    super.key,
    required this.rfScore,
    required this.xgbScore,
    required this.catScore,
    required this.lgbmScore,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Ensemble Model Variance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    dataSets: [
                      RadarDataSet(
                        fillColor: Colors.teal.withOpacity(0.2),
                        borderColor: Colors.teal,
                        entryRadius: 3,
                        dataEntries: [
                          RadarEntry(value: rfScore),
                          RadarEntry(value: xgbScore),
                          RadarEntry(value: catScore),
                          RadarEntry(value: lgbmScore),
                        ],
                      ),
                    ],
                    radarShape: RadarShape.polygon,
                    radarBorderData: const BorderSide(
                      color: Colors.transparent,
                    ),
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    gridBorderData: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    tickCount: 5,
                    getTitle: (index, angle) {
                      switch (index) {
                        case 0:
                          return const RadarChartTitle(text: 'RF');
                        case 1:
                          return const RadarChartTitle(text: 'XGB');
                        case 2:
                          return const RadarChartTitle(text: 'Cat');
                        case 3:
                          return const RadarChartTitle(text: 'LGBM');
                        default:
                          return const RadarChartTitle(text: '');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
