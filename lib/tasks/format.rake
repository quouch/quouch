namespace :format do
  desc 'Run Prettier on CSS files'
  task :fix, [:file_pattern] => :environment do |_t, args|
    args.with_defaults(file_pattern: '.')
    unless system("npx prettier --write #{args.file_pattern}")
      puts 'Error running Prettier'
      exit 1
    end
  end

  task :check, [:file_pattern] => :environment do |_t, args|
    args.with_defaults(file_pattern: '.')
    unless system("npx prettier --check #{args.file_pattern}")
      puts 'Error running Prettier'
      exit 1
    end
  end
end
