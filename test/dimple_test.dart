// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:dimple/dimple.dart';
import 'package:mockito/mockito.dart';

/*
 * Mocks
 */
@proxy
class MockExtension extends Mock implements ContainerExtension {}

class FooService {
  final container;

  FooService(this.container);
}

class BarService {}

/*
 * main()
 */
void main() {
  ContainerBuilder builder;
  Container container;

  setUp(() {
    builder = new ContainerBuilder()
      ..setParameter('param1', 'value1')
      ..setParameter('param2', 'value2')
      ..setParameter('overridden', 'first_value')
      ..setParameter('overridden', 'last_value')
      ..registerService('foo', (c) => new FooService(c))
      ..registerService('bar', (_) => new BarService())
      ..registerService('overriden', (c) => new FooService(c))
      ..registerService('overriden', (_) => new BarService())
    ;

    container = builder.createContainer();
  });

  tearDown(() {
    builder = null;
    container = null;
  });

  test('ContainerBuilder will be frozen after .createContainer() call.', () {
    expect(() => builder.setParameter('param', 'value'), throwsStateError);
    expect(() => builder.registerService('service', (_) => null), throwsStateError);
    expect(() => builder.registerExtension(new MockExtension()), throwsStateError);
    expect(() => builder.createContainer(), throwsStateError);
  });


  group('[Parameters]', () {
    test('.hasParameter() for nonexistent key.', () {
      expect(container.hasParameter('nonexistent'), isFalse);
    });

    test('.getParameter() for nonexistent key.', () {
      expect(() => container.getParameter('nonexisten'), throwsA(const isInstanceOf<ParameterNotFountError>()));
    });

    test('.hasParameter() for existent key.', () {
      expect(container.hasParameter('param1'), isTrue);
      expect(container.hasParameter('param2'), isTrue);
    });

    test('.getParameter() for existent key.', () {
      expect(container.getParameter('param1'), 'value1');
      expect(container.getParameter('param2'), 'value2');
    });

    test('Overriding of parameter.', () {
      expect(container.getParameter('overridden'), equals('last_value'));
    });
  });

  group('[Services]', () {
    test('.hasService() for nonexistent service.', () {
      expect(container.hasService('nonexistent'), isFalse);
    });

    test('.getService() for nonexistent service.', () {
      expect(() => container.getService('nonexistent'), throwsA(const isInstanceOf<ServiceNotFoundError>()));
    });

    test('.hasService() for existent service.', () {
      expect(container.hasService('foo'), isTrue);
      expect(container.hasService('bar'), isTrue);
    });

    test('.getService() for existent service.', () {
      final foo = container.getService('foo');
      final bar = container.getService('bar');

      expect(foo, const isInstanceOf<FooService>());
      expect(foo.container, same(container));
      expect(bar, const isInstanceOf<BarService>());

      expect(container.getService('foo'), same(foo));
      expect(container.getService('bar'), same(bar));
    });

    test('Overriding of service', () {
      expect(container.getService('overriden'), const isInstanceOf<BarService>());
    });

    test('Using ContainerExtension', () {
      final builder = new ContainerBuilder();
      final extension = new MockExtension();

      builder.registerExtension(extension);

      verify(extension.load(argThat(same(builder)))).called(1);
    });
  });
}