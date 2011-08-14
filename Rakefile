# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'spruz'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://flori.github.com/#{name}"
  summary     'Useful stuff.'
  description 'All the stuff that isn\'t good/big enough for a real library.'
  bindir      'bin'
  executables << 'enum'
  test_dir    'tests'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', '.rvmrc'
  readme      'README.rdoc'
  development_dependency 'test-unit', '~>2.3'

  install_library do
    libdir = CONFIG["sitelibdir"]
    cd 'lib' do
      for file in Dir['**/*.rb']
        dst = File.join(libdir, file)
        mkdir_p File.dirname(dst)
        install file, dst
      end
    end
    install 'bin/enum', File.join(CONFIG['bindir'], 'enum')
  end
end
