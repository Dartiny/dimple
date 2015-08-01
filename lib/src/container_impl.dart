// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

class _ContainerImpl implements Container {

  final Map<String, Object> _parameters;
  final Map<String, ServiceFactory> _factories;
  final Map<String, Object> _services = new Map<String, Object>();
  final List<String> _loading = new List<String>();

  _ContainerImpl(this._parameters, this._factories);

  Object getParameter(String key, {Object fallback: const NullParameter()}) {
    if (!hasParameter(key)) {
      if (fallback is NullParameter) {
        throw new ParameterNotFoundError(key, sourceId: (_loading.isNotEmpty ? _loading.last : null));
      }

      return fallback;
    }

    return _parameters[key.toLowerCase()];
  }

  bool hasParameter(String key) {
    return _parameters.containsKey(key.toLowerCase());
  }

  bool hasService(String id) {
    var _id = id.toLowerCase();

    return _factories.containsKey(_id) || _id == 'service_container';
  }

  Object getService(String id, {bool required: true}) {
    if (!hasService(id)) {
      if (required) {
        throw new ServiceNotFoundError(id, sourceId: (_loading.isNotEmpty ? _loading.last : null));
      }

      return null;
    }

    var _id = id.toLowerCase();

    if (_id == 'service_container') {
      return this;
    }

    if (!_services.containsKey(_id)) {
      _services[_id] = _createService(_id, _factories[_id]);
    }

    return _services[_id];
  }

  Object _createService(String id, ServiceFactory factory) {
    try {
      // Check circular references.
      if (_loading.isNotEmpty && _loading.contains(id)) {
        _loading.add(id); // Adds id to create full dependencies path in the error.
        throw new ServiceCircularReferenceError(_loading.first, _loading.toList());
      }

      _loading.add(id);
      return  factory(this);

    } finally {
      _loading.removeLast();
    }
  }
}