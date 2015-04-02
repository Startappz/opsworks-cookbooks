#/usr/bin/env rake
require 'fileutils'

desc 'check literal recipe includes'
task :validate_literal_includes do
  puts "Check literal recipe includes"
  found_issue = false



  Dir['**/*.rb'].reject{|f| f['vendor']}.each do |file|
    begin
      recipes = File.read(file).scan(/(?:include_recipe\s+(['"])([\w:]+)\1)/).reject {|candidate| candidate.last.include?('#{}')}.map(&:last)
      recipes.each do |recipe|
        recipe_file = recipe.include?('::') ? recipe.sub('::', '/recipes/') + '.rb' : recipe + '/recipes/default.rb'
        unless File.exists?(recipe_file)
          puts "#{file} includes missing recipe #{recipe}"
          found_issue = true
        end
      end
    rescue => e
      warn "Exception when checking #{file}."
      raise e
    end
    exit 1 if found_issue
  end
end

desc 'check syntax of ruby files'
task :validate_syntax do
  puts "Check syntax of Ruby files"
  found_trouble = false

  Dir['**/*.rb'].reject{|f| f['vendor']}.each do |file|
    output = `ruby -c #{file}`
    if $?.exitstatus != 0
      puts output
      found_trouble = true
    end
  end
  exit 1 if found_trouble
end

desc 'check cookbooks with Foodcritic'
task :validate_best_practises do
  if RUBY_VERSION.start_with? "1.8"
    warn "Foodcritic requires Ruby 1.9+. You run 1.8. Skipping..."
  else
    puts "Check Cookbooks with Foodcritic"
    system "foodcritic -t correctness -f correctness ."
    exit 1 unless $?.success?
  end
end

desc 'Check that all cookbooks include a customize.rb'
task :validate_customize do
  errors = []
  Dir.glob("*/attributes/*.rb").map do |file|
    next if File.basename(file) == "customize.rb"

    found = false
    IO.readlines(file).each do |line|
      # loads/includes attributes
      if line.match(/include_attribute [\'\"](\w+)::(\w+)?[\'\"]/)
        if $1 == file.split('/').first && $2 == "customize"
          found = true
        end
      end
    end

    errors << file unless found
    puts "OK: #{file}" if found
  end

  if errors.any?
    errors.each { |e| warn "Does not include customize.rb: #{e}" }
    exit 1
  end
end

desc 'run all checks'
task :default => [:validate_syntax, :validate_literal_includes, :validate_best_practises, :validate_customize]
