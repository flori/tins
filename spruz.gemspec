# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spruz}
  s.version = "0.2.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Florian Frank}]
  s.date = %q{2011-07-15}
  s.description = %q{All the stuff that isn't good/big enough for a real library.}
  s.email = %q{flori@ping.de}
  s.executables = [%q{enum}]
  s.extra_rdoc_files = [%q{README}]
  s.files = [%q{tests}, %q{tests/test_spruz_memoize.rb}, %q{tests/test_spruz.rb}, %q{LICENSE}, %q{Rakefile}, %q{spruz.gemspec}, %q{lib}, %q{lib/spruz.rb}, %q{lib/spruz}, %q{lib/spruz/hash_symbolize_keys_recursive.rb}, %q{lib/spruz/string_underscore.rb}, %q{lib/spruz/hash_union.rb}, %q{lib/spruz/write.rb}, %q{lib/spruz/version.rb}, %q{lib/spruz/round.rb}, %q{lib/spruz/go.rb}, %q{lib/spruz/generator.rb}, %q{lib/spruz/string_camelize.rb}, %q{lib/spruz/shuffle.rb}, %q{lib/spruz/deep_dup.rb}, %q{lib/spruz/memoize.rb}, %q{lib/spruz/subhash.rb}, %q{lib/spruz/bijection.rb}, %q{lib/spruz/limited.rb}, %q{lib/spruz/attempt.rb}, %q{lib/spruz/to_proc.rb}, %q{lib/spruz/module_group.rb}, %q{lib/spruz/null.rb}, %q{lib/spruz/xt.rb}, %q{lib/spruz/once.rb}, %q{lib/spruz/xt}, %q{lib/spruz/xt/named.rb}, %q{lib/spruz/xt/hash_symbolize_keys_recursive.rb}, %q{lib/spruz/xt/string_underscore.rb}, %q{lib/spruz/xt/hash_union.rb}, %q{lib/spruz/xt/write.rb}, %q{lib/spruz/xt/irb.rb}, %q{lib/spruz/xt/round.rb}, %q{lib/spruz/xt/string_camelize.rb}, %q{lib/spruz/xt/shuffle.rb}, %q{lib/spruz/xt/deep_dup.rb}, %q{lib/spruz/xt/symbol_to_proc.rb}, %q{lib/spruz/xt/subhash.rb}, %q{lib/spruz/xt/attempt.rb}, %q{lib/spruz/xt/null.rb}, %q{lib/spruz/xt/p.rb}, %q{lib/spruz/xt/partial_application.rb}, %q{lib/spruz/xt/time_dummy.rb}, %q{lib/spruz/xt/string.rb}, %q{lib/spruz/xt/full.rb}, %q{lib/spruz/xt/range_plus.rb}, %q{lib/spruz/xt/count_by.rb}, %q{lib/spruz/xt/blank.rb}, %q{lib/spruz/xt/uniq_by.rb}, %q{lib/spruz/p.rb}, %q{lib/spruz/minimize.rb}, %q{lib/spruz/partial_application.rb}, %q{lib/spruz/time_dummy.rb}, %q{lib/spruz/range_plus.rb}, %q{lib/spruz/count_by.rb}, %q{lib/spruz/uniq_by.rb}, %q{bin}, %q{bin/enum}, %q{README}, %q{VERSION}, %q{install.rb}]
  s.homepage = %q{http://flori.github.com/spruz}
  s.rdoc_options = [%q{--title}, %q{Spruz}, %q{--main}, %q{README}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Useful stuff.}
  s.test_files = [%q{tests/test_spruz_memoize.rb}, %q{tests/test_spruz.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
