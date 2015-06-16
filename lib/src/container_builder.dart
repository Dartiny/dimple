// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

/// [Container] builder.
class ContainerBuilder {

  bool _frozen = false;

  final Map<String, Object> _parameters = new Map<String, Object>();
  final Map<String, ServiceFactory> _factories = new Map<String, ServiceFactory>();

  /// Sets a parameter identified by [key].
  ///
  /// If parameter with a given [key] already exists it will be overridden by a new [value].
  void setParameter(String key, Object value) {
    _checkState();
    _parameters[key] = value;
  }

  /// Registers a [factory] for the service identified by [id].
  void registerService(String id, ServiceFactory factory) {
    _checkState();
    _factories[id] = factory;
  }

  /// Registers an [extension] for package services' registration.
  void registerExtension(ContainerExtension extension) {
    _checkState();
    extension.load(this);
  }

  /// Creates a container.
  Container createContainer() {
    _checkState();
    _frozen = true;

    return new _ContainerImplementation(_parameters, _factories);
  }

  void _checkState() {
    if (_frozen) {
      throw new StateError('Container already created. This instance of the ContainerBuilder cannot be used anymore.');
    }
  }
}
