// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dartiny_di;

/// Abstract error.
abstract class _Error extends Error {

  String get message;

  String get _errorName => runtimeType.toString();
  String get _prefix => '$_errorName:';

  @override
  String toString() {
    return message == null
        ? _errorName
        : '$_prefix $message';
  }
}

/// This error is thrown when a non-existent service is requested.
class ServiceNotFoundError extends _Error {

  final String id;
  final String sourceId;

  ServiceNotFoundError(this.id, {this.sourceId});

  String get _id => Error.safeToString(id);
  String get _sourceId => Error.safeToString(sourceId);

  String get message {
    return sourceId != null
        ? 'The service $_sourceId has dependency on a non-existent service $_id.'
        : 'You have requested a non-existent service $_id.';
  }
}

/// This error is thrown when a circular reference is detected.
class ServiceCircularReferenceError extends _Error {

  final String id;
  final List<String> path;

  ServiceCircularReferenceError(this.id, this.path);

  String get _id => Error.safeToString(id);
  String get _path => Error.safeToString(path.join(' -> '));

  String get message => 'Circular reference detected for service $_id, path: $_path.';
}

/// This error is thrown when a non-existent parameter is used.
class ParameterNotFoundError extends _Error {

  final String key;
  final String sourceId;

  ParameterNotFoundError(this.key, {this.sourceId});

  String get _key => Error.safeToString(key);
  String get _sourceId => Error.safeToString(sourceId);

  String get message {
    return sourceId != null
        ? 'The service $_sourceId has dependency on a non-existent parameter $_key.'
        : 'You have requested a non-existent parameter $_key.';
  }
}