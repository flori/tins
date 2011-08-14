# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spruz}
  s.version = "0.2.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Florian Frank}]
  s.date = %q{2011-08-14}
  s.description = %q{All the stuff that isn't good/big enough for a real library.}
  s.email = %q{flori@ping.de}
  s.executables = [%q{enum}]
  s.extra_rdoc_files = [%q{README.rdoc}, %q{lib/spruz.rb}, %q{lib/spruz/hash_symbolize_keys_recursive.rb}, %q{lib/spruz/string_underscore.rb}, %q{lib/spruz/hash_union.rb}, %q{lib/spruz/write.rb}, %q{lib/spruz/version.rb}, %q{lib/spruz/round.rb}, %q{lib/spruz/go.rb}, %q{lib/spruz/generator.rb}, %q{lib/spruz/string_camelize.rb}, %q{lib/spruz/shuffle.rb}, %q{lib/spruz/deep_dup.rb}, %q{lib/spruz/memoize.rb}, %q{lib/spruz/subhash.rb}, %q{lib/spruz/bijection.rb}, %q{lib/spruz/limited.rb}, %q{lib/spruz/attempt.rb}, %q{lib/spruz/to_proc.rb}, %q{lib/spruz/module_group.rb}, %q{lib/spruz/null.rb}, %q{lib/spruz/secure_write.rb}, %q{lib/spruz/xt.rb}, %q{lib/spruz/file_binary.rb}, %q{lib/spruz/string_version.rb}, %q{lib/spruz/once.rb}, %q{lib/spruz/xt/named.rb}, %q{lib/spruz/xt/hash_symbolize_keys_recursive.rb}, %q{lib/spruz/xt/string_underscore.rb}, %q{lib/spruz/xt/hash_union.rb}, %q{lib/spruz/xt/write.rb}, %q{lib/spruz/xt/irb.rb}, %q{lib/spruz/xt/round.rb}, %q{lib/spruz/xt/string_camelize.rb}, %q{lib/spruz/xt/shuffle.rb}, %q{lib/spruz/xt/deep_dup.rb}, %q{lib/spruz/xt/symbol_to_proc.rb}, %q{lib/spruz/xt/subhash.rb}, %q{lib/spruz/xt/attempt.rb}, %q{lib/spruz/xt/null.rb}, %q{lib/spruz/xt/secure_write.rb}, %q{lib/spruz/xt/file_binary.rb}, %q{lib/spruz/xt/string_version.rb}, %q{lib/spruz/xt/p.rb}, %q{lib/spruz/xt/partial_application.rb}, %q{lib/spruz/xt/time_dummy.rb}, %q{lib/spruz/xt/string.rb}, %q{lib/spruz/xt/full.rb}, %q{lib/spruz/xt/range_plus.rb}, %q{lib/spruz/xt/count_by.rb}, %q{lib/spruz/xt/blank.rb}, %q{lib/spruz/xt/uniq_by.rb}, %q{lib/spruz/p.rb}, %q{lib/spruz/minimize.rb}, %q{lib/spruz/partial_application.rb}, %q{lib/spruz/time_dummy.rb}, %q{lib/spruz/range_plus.rb}, %q{lib/spruz/count_by.rb}, %q{lib/spruz/uniq_by.rb}]
  s.files = [%q{.gitignore}, %q{.travis.yml}, %q{Gemfile}, %q{LICENSE}, %q{README.rdoc}, %q{Rakefile}, %q{TODO}, %q{VERSION}, %q{bin/enum}, %q{lib/spruz.rb}, %q{lib/spruz/attempt.rb}, %q{lib/spruz/bijection.rb}, %q{lib/spruz/count_by.rb}, %q{lib/spruz/deep_dup.rb}, %q{lib/spruz/file_binary.rb}, %q{lib/spruz/generator.rb}, %q{lib/spruz/go.rb}, %q{lib/spruz/hash_symbolize_keys_recursive.rb}, %q{lib/spruz/hash_union.rb}, %q{lib/spruz/limited.rb}, %q{lib/spruz/memoize.rb}, %q{lib/spruz/minimize.rb}, %q{lib/spruz/module_group.rb}, %q{lib/spruz/null.rb}, %q{lib/spruz/once.rb}, %q{lib/spruz/p.rb}, %q{lib/spruz/partial_application.rb}, %q{lib/spruz/range_plus.rb}, %q{lib/spruz/round.rb}, %q{lib/spruz/secure_write.rb}, %q{lib/spruz/shuffle.rb}, %q{lib/spruz/string_camelize.rb}, %q{lib/spruz/string_underscore.rb}, %q{lib/spruz/string_version.rb}, %q{lib/spruz/subhash.rb}, %q{lib/spruz/time_dummy.rb}, %q{lib/spruz/to_proc.rb}, %q{lib/spruz/uniq_by.rb}, %q{lib/spruz/version.rb}, %q{lib/spruz/write.rb}, %q{lib/spruz/xt.rb}, %q{lib/spruz/xt/attempt.rb}, %q{lib/spruz/xt/blank.rb}, %q{lib/spruz/xt/count_by.rb}, %q{lib/spruz/xt/deep_dup.rb}, %q{lib/spruz/xt/file_binary.rb}, %q{lib/spruz/xt/full.rb}, %q{lib/spruz/xt/hash_symbolize_keys_recursive.rb}, %q{lib/spruz/xt/hash_union.rb}, %q{lib/spruz/xt/irb.rb}, %q{lib/spruz/xt/named.rb}, %q{lib/spruz/xt/null.rb}, %q{lib/spruz/xt/p.rb}, %q{lib/spruz/xt/partial_application.rb}, %q{lib/spruz/xt/range_plus.rb}, %q{lib/spruz/xt/round.rb}, %q{lib/spruz/xt/secure_write.rb}, %q{lib/spruz/xt/shuffle.rb}, %q{lib/spruz/xt/string.rb}, %q{lib/spruz/xt/string_camelize.rb}, %q{lib/spruz/xt/string_underscore.rb}, %q{lib/spruz/xt/string_version.rb}, %q{lib/spruz/xt/subhash.rb}, %q{lib/spruz/xt/symbol_to_proc.rb}, %q{lib/spruz/xt/time_dummy.rb}, %q{lib/spruz/xt/uniq_by.rb}, %q{lib/spruz/xt/write.rb}, %q{spruz.gemspec}, %q{tests/spruz_file_binary_test.rb}, %q{tests/spruz_memoize_test.rb}, %q{tests/spruz_secure_write_test.rb}, %q{tests/spruz_test.rb}]
  s.homepage = %q{http://flori.github.com/spruz}
  s.rdoc_options = [%q{--title}, %q{Spruz - Useful stuff.}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.7}
  s.summary = %q{Useful stuff.}
  s.test_files = [%q{tests/spruz_secure_write_test.rb}, %q{tests/spruz_test.rb}, %q{tests/spruz_file_binary_test.rb}, %q{tests/spruz_memoize_test.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 0.0.11"])
      s.add_development_dependency(%q<test-unit>, ["~> 2.3"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 0.0.11"])
      s.add_dependency(%q<test-unit>, ["~> 2.3"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 0.0.11"])
    s.add_dependency(%q<test-unit>, ["~> 2.3"])
  end
end
