$:.unshift "lib"
require "main"
require "cucumber"
require "cucumber/rake/task"
require "rspec/core/rake_task"
require "rake/clean"

CLEAN.include "log/*log", "vines/log/*log", "coverage"

task :default => [:clean, :spec, :"cucumber:ok", :"cucumber:wip", :success]

RSpec::Core::RakeTask.new :spec

namespace :cucumber do
  Cucumber::Rake::Task.new(:ok) do |t|
    t.cucumber_opts = "--tags ~@wip"
  end

  Cucumber::Rake::Task.new(:wip) do |t|
    t.cucumber_opts = "--wip --tags @wip"
  end
end

task :success do
  red    = "\e[31m"
  yellow = "\e[33m"
  green  = "\e[32m"
  blue   = "\e[34m"
  purple = "\e[35m"
  bold   = "\e[1m"
  normal = "\e[0m"
  puts "", "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}* #{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
end

task :run do
  system "cd vines; vines start -d"
  Thread.new { EM.run }
  sleep 0.01 until EM.reactor_running?
  main = Main.main "sniper@localhost", "sniper"
  until main.ui.destroyed?
    sleep 0.1
  end
  system "cd vines; vines stop"
end
