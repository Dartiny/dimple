// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

/// The interface implemented by service container classes.
///
/// Use the [ContainerBuilder] to create a [Container].
abstract class Container {

  /// Returns true if the given service is defined.
  bool hasService(String id);

  /// Returns the associated service.
  ///
  /// Returns `null` when the service is not defined and [required] is `false`.
  ///
  /// Throws [ServiceNotFoundError] when the service is [required] and is not defined.
  /// Throws [ServiceCircularReferenceError] when a circular reference is detected.
  Object getService(String id, {bool required: true});

  /// Returns the value of parameter by parameter's [key].
  ///
  /// Trows [ParameterNotFoundError] if the parameter is not defined and [fallback] is not set.
  bool hasParameter(String key);

  /// Checks if a parameter exists.
  Object getParameter(String key, {Object fallback: const NullParameter()});
}


