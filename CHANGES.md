# Changes

## 2025-01-04 v1.38.0

* Improved Tins::Limited concurrency handling:
  * Added `execute` method for task submission with a block
  * Changed `process` method to manage thread execution and queue management
  * Introduced `stop` method to signal processing termination
  * Modified test cases in `limited_test.rb` to accommodate new functionality
  * Added `ensure` clause to decrement counter and signal continuation after
    block execution
* Added support for Ruby **3.4** Alpine image:
  * Updated `.all_images.yml` to include Ruby **3.4**-alpine environment
  * Added `ruby:3.4-alpine` to the list of supported images
  * Now uses **3.4** instead of **3.3**, **3.2**, and **3.1** for ruby versions

## 2024-12-13 v1.37.1

* Renamed `ZERO` and `BINARY` constants to `ZERO_RE` and `BINARY_RE` to avoid
  collisions with Logger/File constants.

## 2024-10-19 v1.37.0

* Add support for module prepended blocks in **Tins::Concern**:
  * Added `prepend_features` method to Tins concern
  * Updated ConcernTest to test prepend feature
  * Raise StandardError for duplicate block definitions for included and 
    prepended blocks
* Added `class_methods` method to Tins concern:
  * Added `class_methods` method to lib/tins/concern.rb
    - Creates or retrieves ClassMethods module for defining class-level methods
  * Updated tests in `tests/concern_test.rb`
    - Added test for new `baz1` and `baz2` methods
      + Tested availability of `bar`, `baz1`, and `baz2` methods on A

## 2024-10-11 v1.36.1

* Fixed a typo in the code

## 2024-10-11 v1.36.0

### Significant Changes

* Refactor bfs method in `hash_bfs.rb`:
  + Rename `include_nodes` variable to `visit_internal`
  + Update test cases in `hash_bfs_test.rb` to use new method signature
  + Update method signature and docstring to reflect new behavior
* Update hash conversion logic:
  + Rename method parameter from `v` to `object`
  + Use `object` instead of `v` consistently throughout the method
  + Add documentation for new method name and behavior

## 2024-10-10 v1.35.0

### New Features
* Implemented breadth-first search in hashes using the `Tins::HashBFS` module.
  + Added tests for the `Tins::HashBFS` module.

### Refactoring and Cleanup
* Reformatted code.
* Removed TODO note from the `TODO` file.
* Cleaned up test requirements:
  - Added `require 'tins'` to `tests/test_helper.rb`.
  - Removed unnecessary `require 'tins'` lines from test files.
* Refactored BASE16 constants and alphabet:
  + Added `BASE16_LOWERCASE_ALPHABET` constant.
  + Added `BASE16_UPPERCASE_ALPHABET` constant.

### Tool Updates
* Updated bundler command to use full index:
  - Added `--full-index` flag to `bundle install`.
  - Replaced `bundle update` with `bundle install --full-index`.

## 2024-09-30 v1.34.0

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
