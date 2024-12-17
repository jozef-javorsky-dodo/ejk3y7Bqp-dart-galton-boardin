import 'dart:io';
import 'dart:math';

const defaultRows = 9;
const defaultBalls = 256;
const ballsLimit = 10000;
const rowsLimit = 50;

int getRows() {
  final input = stdin.readLineSync();
  final parsed = int.tryParse(input ?? '');
  return parsed?.clamp(1, rowsLimit) ?? defaultRows;
}

int getBalls() {
  final input = stdin.readLineSync();
  final parsed = int.tryParse(input ?? '');
  return parsed?.clamp(1, ballsLimit) ?? defaultBalls;
}

List<int> galtonBoard(int rows, int balls) {
  final bins = List<int>.filled(rows + 1, 0);
  final random = Random();
  for (var i = 0; i < balls; i++) {
    final binIndex =
        List.generate(rows, (_) => random.nextInt(2)).reduce((a, b) => a + b);
    bins[binIndex]++;
  }
  return bins;
}

Map<String, double> calculateStatistics(List<int> bins) {
  final totalBalls = bins.reduce((a, b) => a + b);
  final mean =
      bins.asMap().entries.map((e) => e.key * e.value).reduce((a, b) => a + b) /
          totalBalls;
  final variance = bins
          .asMap()
          .entries
          .map((e) => e.value * pow(e.key - mean, 2))
          .reduce((a, b) => a + b) /
      totalBalls;
  final stdDev = sqrt(variance);
  return {'mean': mean, 'variance': variance, 'stdDev': stdDev};
}

void printBins(List<int> bins) {
  print('\nDistribution:');
  bins.asMap().forEach((i, count) => print('Bin $i: ${'~' * count}'));
}

void printStats(Map<String, double> stats) {
  print('\nMean: ${stats['mean']!.toStringAsFixed(2)}');
  print('Variance: ${stats['variance']!.toStringAsFixed(2)}');
  print('Standard Deviation: ${stats['stdDev']!.toStringAsFixed(2)}');
}

void main() {
  stdout.write(
      'Enter the number of rows (1-$rowsLimit, default: $defaultRows): ');
  final rows = getRows();
  stdout.write(
      'Enter the number of balls (1-$ballsLimit, default: $defaultBalls): ');
  final balls = getBalls();
  final result = galtonBoard(rows, balls);
  printBins(result);
  printStats(calculateStatistics(result));
}
