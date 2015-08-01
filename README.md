Dimple
======

A simple Dependency Injection and Service Container

*(Inspired by [Pimple][1], simple dependency injection container for PHP)*.

[![Pub version](https://img.shields.io/pub/v/dimple.svg)](https://pub.dartlang.org/packages/dimple)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Dartiny/dimple/blob/master/LICENSE)
[![Coverage Status](https://coveralls.io/repos/Dartiny/dimple/badge.svg)](https://coveralls.io/r/Dartiny/dimple)

Usage
-----

To create a container use a `ContainerBuilder`:

```dart
var builder = new ContainerBuilder();

// Define some services:
builder
	..addService(/* ... */)
	..addService(/* ... */);
	
// Create the a `Container` instance:
var container = new ContainerBuilder().build();
```

As many other dependency injection containers, Dimple manages two different kind of data: **services** and **parameters**.

### Defining Services

A service is an object that does something as part of a larger system. Examples of services: a database connections pool, a templating engine, or a mailer. Almost any global object can be a service.

Services are defined by a functions that return an instance of an object:

```dart
builder
  ..addService('mailer', (Container c) {
    return new Mailer(
      c.getService('mailer.transport')
    );
  })
  ..addService('mailer.transport', (_) => new SendmailTransport('/usr/bin/sendmail'))
;  
```

Notice that the function has access to the current container instance, allowing references to other services or parameters.

As objects are only created when you get them, the order of the definitions does not matter.

Using the defined services is also very easy:

```dart
// Build container once:
Container container = builder.build();

// Use the service:
var mailer = container.getService('mailer');

// the above call is roughly equivalent to the following code:
// var transport = new SendmailTransport();
// var mailer    = new Mailer(transport);
```

### Defining Parameters

Defining a parameter allows to ease the configuration of your container from the outside and to store global values:

```dart
builder.setParameter('mailer.sendmail_path', '/usr/bin/sendmail');
```

If you change `mailer.transport` service definition like below:

``` dart
builder.addService('mailer.transport', (c) {
  return new SendmailTransport(c.getParameter('mailer.sendmail_path'));
});
```

You can now easily change the path to the sendmail by overriding the `mailer.sendmail_path` parameter instead of redefining the service definition.

### Modifying Services after Definition

*TODO: Not implemented yet*

### Extending a Container

If you use the same libraries over and over, you might want to reuse some services from one project to the next one; package your services into a **provider** by implementing `ServiceProvider` interface:

```dart
class AcmeServiceProvider implements ServiceProvider {

  void register(ContainerBuilder builder) {
    // Register some services and parameters by the builder.
  }
}
```

Then, register the provider on a `ContainerBuilder`:

```dart
builder.register(new AcmeServiceProvider());
```

\* *See API documentation for more details.*

[1]: http://pimple.sensiolabs.org/ "Pimple website"