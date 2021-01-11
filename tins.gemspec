# -*- encoding: utf-8 -*-
# stub: tins 1.26.0 ruby lib

Gem::Specification.new do |s|
  s.name = "tins".freeze
  s.version = "1.26.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florian Frank".freeze]
  s.date = "2021-01-11"
  s.description = "All the stuff that isn't good/big enough for a real library.".freeze
  s.email = "flori@ping.de".freeze
  s.extra_rdoc_files = ["README.md".freeze, "lib/dslkit.rb".freeze, "lib/dslkit/polite.rb".freeze, "lib/dslkit/rude.rb".freeze, "lib/spruz.rb".freeze, "lib/tins.rb".freeze, "lib/tins/alias.rb".freeze, "lib/tins/annotate.rb".freeze, "lib/tins/ask_and_send.rb".freeze, "lib/tins/attempt.rb".freeze, "lib/tins/bijection.rb".freeze, "lib/tins/case_predicate.rb".freeze, "lib/tins/complete.rb".freeze, "lib/tins/concern.rb".freeze, "lib/tins/count_by.rb".freeze, "lib/tins/date_dummy.rb".freeze, "lib/tins/date_time_dummy.rb".freeze, "lib/tins/deep_const_get.rb".freeze, "lib/tins/deep_dup.rb".freeze, "lib/tins/dslkit.rb".freeze, "lib/tins/duration.rb".freeze, "lib/tins/expose.rb".freeze, "lib/tins/extract_last_argument_options.rb".freeze, "lib/tins/file_binary.rb".freeze, "lib/tins/find.rb".freeze, "lib/tins/generator.rb".freeze, "lib/tins/go.rb".freeze, "lib/tins/hash_symbolize_keys_recursive.rb".freeze, "lib/tins/hash_union.rb".freeze, "lib/tins/if_predicate.rb".freeze, "lib/tins/implement.rb".freeze, "lib/tins/limited.rb".freeze, "lib/tins/lines_file.rb".freeze, "lib/tins/memoize.rb".freeze, "lib/tins/method_description.rb".freeze, "lib/tins/minimize.rb".freeze, "lib/tins/module_group.rb".freeze, "lib/tins/named_set.rb".freeze, "lib/tins/null.rb".freeze, "lib/tins/once.rb".freeze, "lib/tins/p.rb".freeze, "lib/tins/partial_application.rb".freeze, "lib/tins/proc_compose.rb".freeze, "lib/tins/proc_prelude.rb".freeze, "lib/tins/range_plus.rb".freeze, "lib/tins/require_maybe.rb".freeze, "lib/tins/responding.rb".freeze, "lib/tins/secure_write.rb".freeze, "lib/tins/sexy_singleton.rb".freeze, "lib/tins/string_byte_order_mark.rb".freeze, "lib/tins/string_camelize.rb".freeze, "lib/tins/string_underscore.rb".freeze, "lib/tins/string_version.rb".freeze, "lib/tins/subhash.rb".freeze, "lib/tins/temp_io.rb".freeze, "lib/tins/temp_io_enum.rb".freeze, "lib/tins/terminal.rb".freeze, "lib/tins/thread_local.rb".freeze, "lib/tins/time_dummy.rb".freeze, "lib/tins/to.rb".freeze, "lib/tins/to_proc.rb".freeze, "lib/tins/token.rb".freeze, "lib/tins/uniq_by.rb".freeze, "lib/tins/unit.rb".freeze, "lib/tins/version.rb".freeze, "lib/tins/write.rb".freeze, "lib/tins/xt.rb".freeze, "lib/tins/xt/annotate.rb".freeze, "lib/tins/xt/ask_and_send.rb".freeze, "lib/tins/xt/attempt.rb".freeze, "lib/tins/xt/blank.rb".freeze, "lib/tins/xt/case_predicate.rb".freeze, "lib/tins/xt/complete.rb".freeze, "lib/tins/xt/concern.rb".freeze, "lib/tins/xt/count_by.rb".freeze, "lib/tins/xt/date_dummy.rb".freeze, "lib/tins/xt/date_time_dummy.rb".freeze, "lib/tins/xt/deep_const_get.rb".freeze, "lib/tins/xt/deep_dup.rb".freeze, "lib/tins/xt/dslkit.rb".freeze, "lib/tins/xt/expose.rb".freeze, "lib/tins/xt/extract_last_argument_options.rb".freeze, "lib/tins/xt/file_binary.rb".freeze, "lib/tins/xt/full.rb".freeze, "lib/tins/xt/hash_symbolize_keys_recursive.rb".freeze, "lib/tins/xt/hash_union.rb".freeze, "lib/tins/xt/if_predicate.rb".freeze, "lib/tins/xt/implement.rb".freeze, "lib/tins/xt/irb.rb".freeze, "lib/tins/xt/method_description.rb".freeze, "lib/tins/xt/named.rb".freeze, "lib/tins/xt/null.rb".freeze, "lib/tins/xt/p.rb".freeze, "lib/tins/xt/partial_application.rb".freeze, "lib/tins/xt/proc_compose.rb".freeze, "lib/tins/xt/proc_prelude.rb".freeze, "lib/tins/xt/range_plus.rb".freeze, "lib/tins/xt/require_maybe.rb".freeze, "lib/tins/xt/responding.rb".freeze, "lib/tins/xt/secure_write.rb".freeze, "lib/tins/xt/sexy_singleton.rb".freeze, "lib/tins/xt/string.rb".freeze, "lib/tins/xt/string_byte_order_mark.rb".freeze, "lib/tins/xt/string_camelize.rb".freeze, "lib/tins/xt/string_underscore.rb".freeze, "lib/tins/xt/string_version.rb".freeze, "lib/tins/xt/subhash.rb".freeze, "lib/tins/xt/temp_io.rb".freeze, "lib/tins/xt/time_dummy.rb".freeze, "lib/tins/xt/time_freezer.rb".freeze, "lib/tins/xt/to.rb".freeze, "lib/tins/xt/uniq_by.rb".freeze, "lib/tins/xt/write.rb".freeze]
  s.files = [".gitignore".freeze, ".tool-versions".freeze, ".travis.yml".freeze, "COPYING".freeze, "Gemfile".freeze, "README.md".freeze, "Rakefile".freeze, "TODO".freeze, "VERSION".freeze, "examples/add_one.png".freeze, "examples/add_one.stm".freeze, "examples/bb3.png".freeze, "examples/bb3.stm".freeze, "examples/concatenate_compare.mtm".freeze, "examples/concatenate_compare.png".freeze, "examples/length_difference.mtm".freeze, "examples/length_difference.png".freeze, "examples/let.rb".freeze, "examples/mail.rb".freeze, "examples/minsky.rb".freeze, "examples/multiply.reg".freeze, "examples/null_pattern.rb".freeze, "examples/ones_difference-mtm.png".freeze, "examples/ones_difference-stm.png".freeze, "examples/ones_difference.mtm".freeze, "examples/ones_difference.stm".freeze, "examples/prefix-equals-suffix-reversed-with-infix.png".freeze, "examples/prefix-equals-suffix-reversed-with-infix.stm".freeze, "examples/recipe.rb".freeze, "examples/recipe2.rb".freeze, "examples/recipe_common.rb".freeze, "examples/subtract.reg".freeze, "examples/turing-graph.rb".freeze, "examples/turing.rb".freeze, "lib/dslkit.rb".freeze, "lib/dslkit/polite.rb".freeze, "lib/dslkit/rude.rb".freeze, "lib/spruz".freeze, "lib/spruz.rb".freeze, "lib/tins.rb".freeze, "lib/tins/alias.rb".freeze, "lib/tins/annotate.rb".freeze, "lib/tins/ask_and_send.rb".freeze, "lib/tins/attempt.rb".freeze, "lib/tins/bijection.rb".freeze, "lib/tins/case_predicate.rb".freeze, "lib/tins/complete.rb".freeze, "lib/tins/concern.rb".freeze, "lib/tins/count_by.rb".freeze, "lib/tins/date_dummy.rb".freeze, "lib/tins/date_time_dummy.rb".freeze, "lib/tins/deep_const_get.rb".freeze, "lib/tins/deep_dup.rb".freeze, "lib/tins/dslkit.rb".freeze, "lib/tins/duration.rb".freeze, "lib/tins/expose.rb".freeze, "lib/tins/extract_last_argument_options.rb".freeze, "lib/tins/file_binary.rb".freeze, "lib/tins/find.rb".freeze, "lib/tins/generator.rb".freeze, "lib/tins/go.rb".freeze, "lib/tins/hash_symbolize_keys_recursive.rb".freeze, "lib/tins/hash_union.rb".freeze, "lib/tins/if_predicate.rb".freeze, "lib/tins/implement.rb".freeze, "lib/tins/limited.rb".freeze, "lib/tins/lines_file.rb".freeze, "lib/tins/memoize.rb".freeze, "lib/tins/method_description.rb".freeze, "lib/tins/minimize.rb".freeze, "lib/tins/module_group.rb".freeze, "lib/tins/named_set.rb".freeze, "lib/tins/null.rb".freeze, "lib/tins/once.rb".freeze, "lib/tins/p.rb".freeze, "lib/tins/partial_application.rb".freeze, "lib/tins/proc_compose.rb".freeze, "lib/tins/proc_prelude.rb".freeze, "lib/tins/range_plus.rb".freeze, "lib/tins/require_maybe.rb".freeze, "lib/tins/responding.rb".freeze, "lib/tins/secure_write.rb".freeze, "lib/tins/sexy_singleton.rb".freeze, "lib/tins/string_byte_order_mark.rb".freeze, "lib/tins/string_camelize.rb".freeze, "lib/tins/string_underscore.rb".freeze, "lib/tins/string_version.rb".freeze, "lib/tins/subhash.rb".freeze, "lib/tins/temp_io.rb".freeze, "lib/tins/temp_io_enum.rb".freeze, "lib/tins/terminal.rb".freeze, "lib/tins/thread_local.rb".freeze, "lib/tins/time_dummy.rb".freeze, "lib/tins/to.rb".freeze, "lib/tins/to_proc.rb".freeze, "lib/tins/token.rb".freeze, "lib/tins/uniq_by.rb".freeze, "lib/tins/unit.rb".freeze, "lib/tins/version.rb".freeze, "lib/tins/write.rb".freeze, "lib/tins/xt.rb".freeze, "lib/tins/xt/annotate.rb".freeze, "lib/tins/xt/ask_and_send.rb".freeze, "lib/tins/xt/attempt.rb".freeze, "lib/tins/xt/blank.rb".freeze, "lib/tins/xt/case_predicate.rb".freeze, "lib/tins/xt/complete.rb".freeze, "lib/tins/xt/concern.rb".freeze, "lib/tins/xt/count_by.rb".freeze, "lib/tins/xt/date_dummy.rb".freeze, "lib/tins/xt/date_time_dummy.rb".freeze, "lib/tins/xt/deep_const_get.rb".freeze, "lib/tins/xt/deep_dup.rb".freeze, "lib/tins/xt/dslkit.rb".freeze, "lib/tins/xt/expose.rb".freeze, "lib/tins/xt/extract_last_argument_options.rb".freeze, "lib/tins/xt/file_binary.rb".freeze, "lib/tins/xt/full.rb".freeze, "lib/tins/xt/hash_symbolize_keys_recursive.rb".freeze, "lib/tins/xt/hash_union.rb".freeze, "lib/tins/xt/if_predicate.rb".freeze, "lib/tins/xt/implement.rb".freeze, "lib/tins/xt/irb.rb".freeze, "lib/tins/xt/method_description.rb".freeze, "lib/tins/xt/named.rb".freeze, "lib/tins/xt/null.rb".freeze, "lib/tins/xt/p.rb".freeze, "lib/tins/xt/partial_application.rb".freeze, "lib/tins/xt/proc_compose.rb".freeze, "lib/tins/xt/proc_prelude.rb".freeze, "lib/tins/xt/range_plus.rb".freeze, "lib/tins/xt/require_maybe.rb".freeze, "lib/tins/xt/responding.rb".freeze, "lib/tins/xt/secure_write.rb".freeze, "lib/tins/xt/sexy_singleton.rb".freeze, "lib/tins/xt/string.rb".freeze, "lib/tins/xt/string_byte_order_mark.rb".freeze, "lib/tins/xt/string_camelize.rb".freeze, "lib/tins/xt/string_underscore.rb".freeze, "lib/tins/xt/string_version.rb".freeze, "lib/tins/xt/subhash.rb".freeze, "lib/tins/xt/temp_io.rb".freeze, "lib/tins/xt/time_dummy.rb".freeze, "lib/tins/xt/time_freezer.rb".freeze, "lib/tins/xt/to.rb".freeze, "lib/tins/xt/uniq_by.rb".freeze, "lib/tins/xt/write.rb".freeze, "tests/annotate_test.rb".freeze, "tests/ask_and_send_test.rb".freeze, "tests/attempt_test.rb".freeze, "tests/bijection_test.rb".freeze, "tests/blank_full_test.rb".freeze, "tests/case_predicate_test.rb".freeze, "tests/concern_test.rb".freeze, "tests/count_by_test.rb".freeze, "tests/date_dummy_test.rb".freeze, "tests/date_time_dummy_test.rb".freeze, "tests/deep_const_get_test.rb".freeze, "tests/deep_dup_test.rb".freeze, "tests/delegate_test.rb".freeze, "tests/dslkit_test.rb".freeze, "tests/duration_test.rb".freeze, "tests/dynamic_scope_test.rb".freeze, "tests/expose_test.rb".freeze, "tests/extract_last_argument_options_test.rb".freeze, "tests/file_binary_test.rb".freeze, "tests/find_test.rb".freeze, "tests/from_module_test.rb".freeze, "tests/generator_test.rb".freeze, "tests/go_test.rb".freeze, "tests/hash_symbolize_keys_recursive_test.rb".freeze, "tests/hash_union_test.rb".freeze, "tests/if_predicate_test.rb".freeze, "tests/implement_test.rb".freeze, "tests/limited_test.rb".freeze, "tests/lines_file_test.rb".freeze, "tests/memoize_test.rb".freeze, "tests/method_description_test.rb".freeze, "tests/minimize_test.rb".freeze, "tests/module_group_test.rb".freeze, "tests/named_set_test.rb".freeze, "tests/named_test.rb".freeze, "tests/null_test.rb".freeze, "tests/p_test.rb".freeze, "tests/partial_application_test.rb".freeze, "tests/proc_compose_test.rb".freeze, "tests/proc_prelude_test.rb".freeze, "tests/range_plus_test.rb".freeze, "tests/require_maybe_test.rb".freeze, "tests/responding_test.rb".freeze, "tests/rotate_test.rb".freeze, "tests/scope_test.rb".freeze, "tests/secure_write_test.rb".freeze, "tests/sexy_singleton_test.rb".freeze, "tests/string_byte_order_mark_test.rb".freeze, "tests/string_camelize_test.rb".freeze, "tests/string_underscore_test.rb".freeze, "tests/string_version_test.rb".freeze, "tests/subhash_test.rb".freeze, "tests/temp_io_test.rb".freeze, "tests/test_helper.rb".freeze, "tests/time_dummy_test.rb".freeze, "tests/time_freezer_test.rb".freeze, "tests/to_test.rb".freeze, "tests/token_test.rb".freeze, "tests/uniq_by_test.rb".freeze, "tests/unit_test.rb".freeze, "tins.gemspec".freeze]
  s.homepage = "https://github.com/flori/tins".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "Tins - Useful stuff.".freeze, "--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Useful stuff.".freeze
  s.test_files = ["tests/annotate_test.rb".freeze, "tests/ask_and_send_test.rb".freeze, "tests/attempt_test.rb".freeze, "tests/bijection_test.rb".freeze, "tests/blank_full_test.rb".freeze, "tests/case_predicate_test.rb".freeze, "tests/concern_test.rb".freeze, "tests/count_by_test.rb".freeze, "tests/date_dummy_test.rb".freeze, "tests/date_time_dummy_test.rb".freeze, "tests/deep_const_get_test.rb".freeze, "tests/deep_dup_test.rb".freeze, "tests/delegate_test.rb".freeze, "tests/dslkit_test.rb".freeze, "tests/duration_test.rb".freeze, "tests/dynamic_scope_test.rb".freeze, "tests/expose_test.rb".freeze, "tests/extract_last_argument_options_test.rb".freeze, "tests/file_binary_test.rb".freeze, "tests/find_test.rb".freeze, "tests/from_module_test.rb".freeze, "tests/generator_test.rb".freeze, "tests/go_test.rb".freeze, "tests/hash_symbolize_keys_recursive_test.rb".freeze, "tests/hash_union_test.rb".freeze, "tests/if_predicate_test.rb".freeze, "tests/implement_test.rb".freeze, "tests/limited_test.rb".freeze, "tests/lines_file_test.rb".freeze, "tests/memoize_test.rb".freeze, "tests/method_description_test.rb".freeze, "tests/minimize_test.rb".freeze, "tests/module_group_test.rb".freeze, "tests/named_set_test.rb".freeze, "tests/named_test.rb".freeze, "tests/null_test.rb".freeze, "tests/p_test.rb".freeze, "tests/partial_application_test.rb".freeze, "tests/proc_compose_test.rb".freeze, "tests/proc_prelude_test.rb".freeze, "tests/range_plus_test.rb".freeze, "tests/require_maybe_test.rb".freeze, "tests/responding_test.rb".freeze, "tests/rotate_test.rb".freeze, "tests/scope_test.rb".freeze, "tests/secure_write_test.rb".freeze, "tests/sexy_singleton_test.rb".freeze, "tests/string_byte_order_mark_test.rb".freeze, "tests/string_camelize_test.rb".freeze, "tests/string_underscore_test.rb".freeze, "tests/string_version_test.rb".freeze, "tests/subhash_test.rb".freeze, "tests/temp_io_test.rb".freeze, "tests/test_helper.rb".freeze, "tests/time_dummy_test.rb".freeze, "tests/time_freezer_test.rb".freeze, "tests/to_test.rb".freeze, "tests/token_test.rb".freeze, "tests/uniq_by_test.rb".freeze, "tests/unit_test.rb".freeze, "tests/if_predicate_test.rb".freeze, "tests/string_camelize_test.rb".freeze, "tests/case_predicate_test.rb".freeze, "tests/sexy_singleton_test.rb".freeze, "tests/hash_union_test.rb".freeze, "tests/date_dummy_test.rb".freeze, "tests/string_byte_order_mark_test.rb".freeze, "tests/deep_dup_test.rb".freeze, "tests/generator_test.rb".freeze, "tests/ask_and_send_test.rb".freeze, "tests/hash_symbolize_keys_recursive_test.rb".freeze, "tests/memoize_test.rb".freeze, "tests/find_test.rb".freeze, "tests/extract_last_argument_options_test.rb".freeze, "tests/null_test.rb".freeze, "tests/temp_io_test.rb".freeze, "tests/proc_prelude_test.rb".freeze, "tests/token_test.rb".freeze, "tests/bijection_test.rb".freeze, "tests/p_test.rb".freeze, "tests/dynamic_scope_test.rb".freeze, "tests/lines_file_test.rb".freeze, "tests/count_by_test.rb".freeze, "tests/responding_test.rb".freeze, "tests/time_freezer_test.rb".freeze, "tests/attempt_test.rb".freeze, "tests/concern_test.rb".freeze, "tests/implement_test.rb".freeze, "tests/dslkit_test.rb".freeze, "tests/range_plus_test.rb".freeze, "tests/deep_const_get_test.rb".freeze, "tests/named_set_test.rb".freeze, "tests/proc_compose_test.rb".freeze, "tests/minimize_test.rb".freeze, "tests/subhash_test.rb".freeze, "tests/delegate_test.rb".freeze, "tests/time_dummy_test.rb".freeze, "tests/limited_test.rb".freeze, "tests/duration_test.rb".freeze, "tests/method_description_test.rb".freeze, "tests/to_test.rb".freeze, "tests/file_binary_test.rb".freeze, "tests/partial_application_test.rb".freeze, "tests/date_time_dummy_test.rb".freeze, "tests/expose_test.rb".freeze, "tests/rotate_test.rb".freeze, "tests/module_group_test.rb".freeze, "tests/unit_test.rb".freeze, "tests/string_underscore_test.rb".freeze, "tests/named_test.rb".freeze, "tests/from_module_test.rb".freeze, "tests/string_version_test.rb".freeze, "tests/require_maybe_test.rb".freeze, "tests/uniq_by_test.rb".freeze, "tests/secure_write_test.rb".freeze, "tests/blank_full_test.rb".freeze, "tests/scope_test.rb".freeze, "tests/annotate_test.rb".freeze, "tests/go_test.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<gem_hadar>.freeze, ["~> 1.11.0"])
    s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.1"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<sync>.freeze, [">= 0"])
  else
    s.add_dependency(%q<gem_hadar>.freeze, ["~> 1.11.0"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.1"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<sync>.freeze, [">= 0"])
  end
end
