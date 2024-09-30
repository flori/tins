# Changes

## 2024-09-30 v1.34.0

### Changes in **1.34.0**

* **Secure write functionality updated**
	+ Added support for `Pathname` objects in `secure_write`
	+ Updated `File.new` call to use `to_s` method on filename
	+ New test case added for `secure_write` with `Pathname` object
* **Refactor version comparisons in various modules**
	+ Added `Tins::StringVersion.compare` method to compare Ruby versions with operators.
	+ Replaced direct version comparisons with `compare` method in multiple modules.
* **Deprecate deep_const_get and const_defined_in? methods**
	+ Add deprecation notice for `const_defined_in?` for ruby >= 1.8
	+ Add deprecation notice for `deep_const_get` method with a new method name `const_get` for ruby >= 2.0
* **Refactor deprecation logic and tests**
	+ Update `Tins::Deprecate#deprecate` method to allow for optional `new_method` parameter.
	+ Modify `tests/deprecate_test.rb` to test deprecated methods with and without messages.
* **Prepare count_by method for deprecation**
	+ Suggest using `count` with block instead in newer Rubies
* **Prepare uniq_by / uniq_by! method for deprecation**
	+ Suggest using `uniq` / `uniq!` with block instead in newer Rubies

## 2024-04-17 v1.33.0

* **Changes for Ruby 3.3 and 3.4**
	+ Added support for Ruby **3.3**
	+ Added dependency on `bigdecimal` for upcoming Ruby **3.4**
* **Other Changes**
	+ Halting once is enough
	+ Added ruby **3.2**, removed some older ones
	+ Added test process convenience method

## 2022-11-21 v1.32.1

* Removed mutex for finalizer, allowing Ruby to handle cleanup instead.
* Significant changes:
	+ Removed `mutex` variable
	+ Updated code to rely on Ruby's built-in finalization mechanism

## 2022-11-17 v1.32.0

* **attempt** method now supports passing of previously caught exception into
  the called block to let the handling behaviour depend on it.
* Some smaller changes to make debugging on multiple Ruby releases, easier via
  all_images.
* Enable fast failing mode
* Add convenience method to create `Tins::StringVersion` objects.
* Pass previous exception to attempt block ...
  ... to allow reacting to it, logging it etc.
* Remove additional groups
* Use debug instead of byebug for development
* Ignore more hidden files in the package
* Update Ruby version to **3.1**
