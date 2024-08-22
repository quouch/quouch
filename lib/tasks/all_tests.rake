namespace :test do
  desc 'Run all tests'
  task all: :environment do
    Rails.logger.info 'Running model tests'
    Rake::Task['test:models'].invoke

    Rails.logger.info 'Running controller tests'
    Rake::Task['test:controllers'].invoke

    Rails.logger.info 'Running mailer tests'
    Rake::Task['test:mailers'].invoke

    Rails.logger.info 'Running helpers tests'
    Rake::Task['test:helpers'].invoke

    Rails.logger.info 'Running integration tests'
    Rake::Task['test:integration'].invoke

    Rails.logger.info 'Running system tests'
    Rake::Task['test:system'].invoke
  end

  namespace :system do
    desc 'Run system tests'
    task all: :environment do
      Rake::Task['test:system'].invoke
    end

    desc 'Run system tests as a mobile device [iPhone SE]'
    task ios: :environment do
      ENV['MOBILE'] = 'true'
      ENV['SCREEN_TYPE'] = 'iphone_se'
      Rake::Task['test:system'].invoke
    end

    desc 'Run system tests as a mobile device [iPhone 12 Pro]'
    task android: :environment do
      ENV['MOBILE'] = 'true'
      ENV['SCREEN_TYPE'] = 'pixel_7'
      Rake::Task['test:system'].invoke
    end
  end
end
