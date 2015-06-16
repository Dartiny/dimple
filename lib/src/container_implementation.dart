// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

class _ContainerImplementation implements Container {

  final Map<String, Object> _parameters;
  final Map<String, ServiceFactory> _factories;
  final Map<String, Object> _instances = new Map<String, Object>();

  _ContainerImplementation(this._parameters, this._factories);

  Object getParameter(String key, {Object fallback: const NullParameter()}) {
    if (!hasParameter(key)) {
      if (fallback is NullParameter) {
        throw new ParameterNotFoundError(key);
      } else {
        return fallback;
      }
    }

    return _parameters[key];
  }

  bool hasParameter(String key) {
    return _parameters.containsKey(key);
  }

  bool hasService(String id) {
    return _factories.containsKey(id);
  }

  Object getService(String id, {bool required: true}) {
    if (!hasService(id)) {
      if (required) {
        throw new ServiceNotFoundError(id);
      } else {
        return null;
      }
    }

    if (!_instances.containsKey(id)) {
      final factory = _factories[id];
      _instances[id] = factory(this);
    }

    return _instances[id];
  }
}