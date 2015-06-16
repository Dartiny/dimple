// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:dimple/dimple.dart' show ParameterNotFoundError, ServiceNotFoundError;

void main() {
  group('Errors', () {
    test('ParameterNotFound string representation.', () {
      expect(
        new ParameterNotFoundError('some_param').toString(),
        equals('Parameter with key "some_param" cannot be found in the Service Container.')
      );
    });

    test('ServicerNotFound string representation.', () {
      expect(
          new ServiceNotFoundError('some_service').toString(),
          equals('Service identified by "some_service" cannot be found in the Service Container.')
      );
    });
  });
}