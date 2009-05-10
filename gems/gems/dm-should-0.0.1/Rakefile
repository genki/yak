require 'pathname'
require 'rubygems'

ROOT    = Pathname(__FILE__).dirname.expand_path
JRUBY   = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO    = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])

require ROOT + 'lib/dm-should/version'

AUTHOR = 'Yukiko kawamoto'
EMAIL  = 'yu0420 [a] gmail [d] com'
GEM_NAME = 'dm-should'
GEM_VERSION = DataMapper::Should::VERSION
GEM_DEPENDENCIES = [['dm-core', GEM_VERSION]]
GEM_CLEAN = %w[ log pkg coverage ]
GEM_EXTRAS = { :has_rdoc => true, :extra_rdoc_files => %w[ README.rdoc LICENSE] }

PROJECT_NAME = GEM_NAME
PROJECT_URL  = "http://github.com/yukiko/#{GEM_NAME}"
PROJECT_DESCRIPTION = PROJECT_SUMMARY = 'DataMapper plugin for propeties with specifications'

[ ROOT, ROOT.parent ].each do |dir|
  Pathname.glob(dir.join('tasks/**/*.rb').to_s).each { |f| require f }
end

namespace :readme do
  desc "mkdir doc"
  task :docdir do
    mkdir "doc" unless File.directory? "doc"
  end

  desc "generate doc/tree.txt"
  task :tree => :docdir do
    sh "tree lib > doc/tree.txt"
  end

  desc "generate doc/readme.spec.txt" 
  task :specdoc => :docdir do
    sh "spec spec/README* -fs > doc/readme.spec.txt"
  end

  desc "generate doc/specdoc.html"
  task :specrdoc => :specdoc do
    sh "rdoc -1 --quiet doc/readme.spec.txt > doc/specdoc.html"
  end

  desc "generate doc/readme.raw.txt"
  task :raw => [:tree, :specdoc] do
    tree = File.readlines("doc/tree.txt").map {|line| "  #{line}" }.join("")
    specdoc = File.read("doc/readme.spec.txt")
    File.open("doc/readme.raw.txt", "w") do |f|
      f << <<-DOC 
= dm-should
== Current Tree
#{tree}
== Current SpecDoc
#{specdoc}
      DOC
    end
  end

  desc "generate doc/index.html"
  task :local => :raw do
    sh "rdoc -1 --quiet doc/readme.raw.txt > doc/index.html"
  end

  desc "generate README" 
  task :gen => :raw do
    sh "cat doc/readme.raw.txt > README.rdoc"
  end

end
