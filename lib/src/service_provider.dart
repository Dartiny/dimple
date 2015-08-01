// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

/// Dimple service provider interface.
abstract class ServiceProvider {

  /// Registers services on the given container.
  ///
  /// This method should only be used to configure services and parameters.
  /// It should not get services.
  void register(ContainerBuilder builder);
}