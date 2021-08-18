// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

void main() async {
  //Stream<int>를 반환하는 countStream의 작업을 변수 stream에 담았다.
  //이때 countStream 함수의 작업을 실시하지 않는다.
  //countStream 함수의 작업은 await sumStream(stream) 호출 시 진행된다.
  //stream은 lazy 초기화와 유사한 개념이다.
  //사용할 때 작업을 실시한다.
  var stream = countStream(10);
  // stream.listen((event) => print("stream listener : $event"));
  var sum = await sumStream(stream);
  print("result sum : $sum");
}

Stream<int> countStream(int to) async* {
  for (int i = 0; i <= to; i++) {
    await Future.delayed(const Duration(seconds: 1));
    print("countStream i: $i");
    yield i;
  }
}

Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (var value in stream) {
    sum += value;
    print("sumStream sum : $sum");
  }
  return sum;
}
