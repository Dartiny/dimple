// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

class ParameterNotFountError extends Error {

  final String parameterKey;

  ParameterNotFountError(this.parameterKey);

  String toString() {
    final key = Error.safeToString(parameterKey);

    return 'Parameter with key "$key" cannot be fount in the Service Container.';
  }
}

class ServiceNotFoundError extends Error {

  final String serviceId;

  ServiceNotFoundError(this.serviceId);

  String toString() {
    final id = Error.safeToString(serviceId);

    return 'Service identified by "$id" cannot be fount in the Service Container.';
  }
}