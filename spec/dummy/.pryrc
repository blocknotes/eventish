# frozen_string_literal: true

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem 'rails', '~> 7.0.0'
  gem 'sqlite3'
  gem 'eventish', path: '../../'
end

puts '> Load main...'
load 'main.rb'
puts 'done.'
