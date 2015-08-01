// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library dimple.test.fixtures;

class SimpleService {}

class DependencyAwareService {
  var dependency1;
  var dependency2;

  DependencyAwareService(this.dependency1, [this.dependency2]);
}