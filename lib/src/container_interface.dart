// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of dimple;

abstract class Container {

  bool hasService(String id);

  Object getService(String id, {bool required: true});

  bool hasParameter(String key);

  Object getParameter(String key, {Object fallback: const NullParameter()});
}


