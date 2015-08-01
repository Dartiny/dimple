// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

/// [Container] builder.
class ContainerBuilder {

  Map<String, Object> _parameters;
  Map<String, ServiceFactory> _factories;
  Set<ServiceProvider> _providers;

  ContainerBuilder() {
    _init();
  }

  /// Sets a parameter identified by [key].
  ///
  /// If parameter with a given [key] already exists it will be overridden by a new [value].
  void setParameter(String key, Object value) {
    _parameters[key.toLowerCase()] = value;
  }

  /// Registers a [factory] for the service identified by [id].
  void addService(String id, ServiceFactory factory) {
    _factories[id.toLowerCase()] = factory;
  }

  /// Registers an [ServiceProvider] for package services' registration.
  void register(ServiceProvider provider) {
    _providers.add(provider);
  }

  /// Creates a container and resets the builder.
  Container build() {
    _loadProviders();

    var container = new _ContainerImpl(_parameters, _factories);
    _init();

    return container;
  }

  void _loadProviders() {
    for (var provider in _providers) {
      provider.register(this);
    }
  }

  void _init() {
    _parameters = new Map<String, Object>();
    _factories = new Map<String, ServiceFactory>();
    _providers = new Set<ServiceProvider>();
  }
}
