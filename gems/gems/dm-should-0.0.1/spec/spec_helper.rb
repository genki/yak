require 'pathname'
require "pp"
require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'
require 'dm-aggregates'

ROOT = Pathname(__FILE__).dirname.parent.expand_path

require ROOT + 'lib/dm-should'
require ROOT + 'spec/fixture/models'

DataMapper.setup(:default, 'sqlite3::memory:')

Spec::Runner.configure do |c|
  c.include(Module.new do
    DS = DataMapper::Should
  end)
end
