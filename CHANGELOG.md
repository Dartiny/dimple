# Changelog

## 0.1.0
  * (BC) `ContainerExtension` replaced by `ServiceProvider`.
  * (BC) Interface of `ContainerBuilder` was changed.
  * Errors' description was improved.
  * Added the detection of circular references.
  * Now container can return itself: `container.getService('service_container')`.

## 0.1.0-beta.1
  * Supports of parameters.
  * Support of `fallback` for optional parameters.
  * Support of optional services.
  * Support of `ContainerExtension` to provide a batch of services for your application's module.