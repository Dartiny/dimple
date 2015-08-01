// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:dimple/dimple.dart';
import 'fixtures.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

/*
 * Mocks
 */
@proxy
class MockServiceProvider extends Mock implements ServiceProvider {}

Container _createContainer() {
  var builder = new ContainerBuilder();

  builder
    ..setParameter('lib_name', 'dimple')
    ..setParameter('LIB_FUNCTION', 'service container')
    ..addService('simple', (_) => new SimpleService())
    ..addService('UPPERCASE', (_) => new SimpleService())
    ..addService('dependency_aware',
      (c) => new DependencyAwareService(c.getService('simple'), c.getParameter('lib_name')))
    ..addService('with_missing_parameter', (c) => new DependencyAwareService(c.getParameter('missing_parameter')))
    ..addService('missing_dependency_aware', (c) => new DependencyAwareService(c.getService('missing_service')))
    ..addService('direct_circular', (c) {
      return new DependencyAwareService(c.getService('direct_circular'));
    })
    ..addService('indirect_circular', (c) {
      return new DependencyAwareService(c.getService('indirect_circular_aware'));
    })
    ..addService('indirect_circular_aware', (c) {
      return new DependencyAwareService(c.getService('indirect_circular'));
    })
  ;

  return builder.build();
}

/*
 * main()
 */
void main() {
  group('Container', () {
    Container container;

    setUp(() => container = _createContainer());
    tearDown(() => container = null);

    test('.hasParameter()', () {
      expect(container.hasParameter('lib_name'), isTrue);
      expect(container.hasParameter('lib_function'), isTrue);

      expect(container.hasParameter('LIB_NAME'), isTrue);
      expect(container.hasParameter('LIB_FUNCTION'), isTrue);

      expect(container.hasParameter('missing_parameter'), isFalse);
    });

    group('.getParameter()', () {
      test('For existing parameter.', () {
        expect(container.getParameter('lib_name'), 'dimple');
        expect(container.getParameter('lib_function'), 'service container');

        expect(container.getParameter('LIB_NAME'), 'dimple');
        expect(container.getParameter('LIB_FUNCTION'), 'service container');
      });

      test('For missing parameter without fallback.', () {
        expect(() => container.getParameter('missing_parameter'),
        throwsA(
            allOf(
                const isInstanceOf<ParameterNotFoundError>(),
                predicate((e) => e.message == 'You have requested a non-existent parameter "missing_parameter".'),
                predicate((e) => e.toString() == 'ParameterNotFoundError: You have requested a non-existent parameter "missing_parameter".')
            )
        )
        );
      });

      test('For missing parameter with fallback.', () {
        expect(container.getParameter('missing_parameter', fallback: null), isNull);
        expect(container.getParameter('missing_parameter', fallback: 'alternative'), 'alternative');
      });
    });

    test('.hasService()', () {
      expect(container.hasService('service_container'), isTrue, reason: 'Container should to have a reference to itself.');
      expect(container.hasService('simple'), isTrue);
      expect(container.hasService('uppercase'), isTrue);

      expect(container.hasService('SERVICE_CONTAINER'), isTrue, reason: 'Container should to have a reference to itself.');
      expect(container.hasService('SIMPLE'), isTrue);
      expect(container.hasService('UPPERCASE'), isTrue);

      expect(container.hasService('missing_service'), isFalse);
    });

    group('.getService()', () {
      test('To get a container itself.', () {
        expect(container.getService('service_container'), same(container));
      });

      test('For service without dependencies.', () {
        var service = container.getService('simple');

        expect(service, const isInstanceOf<SimpleService>());
        expect(container.getService('simple'), same(service));
        expect(container.getService('SIMPLE'), same(service));
      });

      test('For service with dependencies.', () {
        DependencyAwareService service = container.getService('dependency_aware');

        expect(service.dependency1, same(container.getService('simple')));
        expect(service.dependency2, same(container.getParameter('lib_name')));
      });

      test('For missing service (when service is required).', () {
        expect(() => container.getService('missing_service'),
        throwsA(
            allOf(
                const isInstanceOf<ServiceNotFoundError>(),
                predicate((e) => e.message == 'You have requested a non-existent service "missing_service".'),
                predicate((e) => e.toString() == 'ServiceNotFoundError: You have requested a non-existent service "missing_service".')
            )
        )
        );
      });

      test('For missing service (when service is not required).', () {
        expect(container.getService('missing_service', required: false), isNull);
      });

      test('For service depends on missing parameter.', () {
        expect(() => container.getService('with_missing_parameter'),
        throwsA(
            allOf(
                const isInstanceOf<ParameterNotFoundError>(),
                predicate(
                        (e) => e.message == 'The service "with_missing_parameter" has dependency on a non-existent parameter "missing_parameter".'
                )
            )
        )
        );
      });

      test('For service depends on missing service.', () {
        expect(() => container.getService('missing_dependency_aware'),
        throwsA(
            allOf(
                const isInstanceOf<ServiceNotFoundError>(),
                predicate(
                        (e) => e.message == 'The service "missing_dependency_aware" has dependency on a non-existent service "missing_service".'
                )
            )
        )
        );
      });

      test('For service with circular dependency.', () {
        expect(() => container.getService('direct_circular'),
        throwsA(
            allOf(
                const isInstanceOf<ServiceCircularReferenceError>(),
                predicate((e) => e.message == 'Circular reference detected for service "direct_circular", path: "direct_circular -> direct_circular".')
            )
        )
        );

        expect(() => container.getService('indirect_circular'),
        throwsA(
            allOf(
                const isInstanceOf<ServiceCircularReferenceError>(),
                predicate((e) => e.message == 'Circular reference detected for service "indirect_circular", path: "indirect_circular -> indirect_circular_aware -> indirect_circular".')
            )
        )
        );
      });
    });
  });

  group('ContainerBuilder', () {
    test('Registration of ServiceProvider', () {
      var builder = new ContainerBuilder();
      var provider = new MockServiceProvider();
      builder
        ..register(provider)
        ..build();

      verify(provider.register(argThat(same(builder)))).called(1);
    });
  });

}

