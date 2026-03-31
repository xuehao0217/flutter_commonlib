import 'package:common_core/net/base_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseEntity', () {
    test('isSuccess when errorCode is 0', () {
      const e = BaseEntity(errorCode: 0, errorMsg: '', data: null);
      expect(e.isSuccess(), isTrue);
    });

    test('not success when errorCode non-zero', () {
      const e = BaseEntity(errorCode: 1, errorMsg: 'err', data: null);
      expect(e.isSuccess(), isFalse);
    });
  });
}
