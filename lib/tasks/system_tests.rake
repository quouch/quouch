# Rails has issues if I use the word `test` in the namespace.
namespace :system do
  desc 'Run system tests'
  task :desktop do
    Rake::Task['test:system'].invoke
  end

  desc 'Run system tests as a mobile device [iPhone SE]'
  task :ios do
    ENV['MOBILE'] = 'true'
    ENV['SCREEN_TYPE'] = 'iphone_se'
    Rake::Task['test:system'].invoke
  end

  desc 'Run system tests as a mobile device [iPhone 12 Pro]'
  task :android do
    ENV['MOBILE'] = 'true'
    ENV['SCREEN_TYPE'] = 'pixel_7'
    Rake::Task['test:system'].invoke
  end
end

desc 'Default task'
task system: 'system:desktop'
