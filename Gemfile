source 'https://rubygems.org'

ruby '>= 3.4.0'

# Core dependencies
gem 'json', '~> 2.7'           # JSON parsing and generation
gem 'yaml', '~> 0.3'           # YAML configuration files

# Image generation
gem 'rmagick', '~> 6.0'        # ImageMagick Ruby bindings for image export
gem 'chunky_png', '~> 1.4'     # Pure Ruby PNG library (fallback option)

# CLI and argument parsing
gem 'optparse', '~> 0.5'       # Command line option parsing
gem 'thor', '~> 1.3'           # Alternative CLI framework

# Performance and parallel processing
gem 'parallel', '~> 1.24'      # Parallel processing for large grids
gem 'concurrent-ruby', '~> 1.2' # Thread-safe data structures

# Development dependencies
group :development do
  gem 'rake', '~> 13.0'        # Task management
  gem 'pry', '~> 0.14'         # Interactive debugging
  gem 'rubocop', '~> 1.50'     # Ruby style guide
end

# Testing dependencies
group :test do
  gem 'rspec', '~> 3.12'       # Testing framework
  gem 'simplecov', '~> 0.22'   # Code coverage
  gem 'benchmark-ips', '~> 2.12' # Performance benchmarking
end

# Documentation
group :development do
  gem 'yard', '~> 0.9'         # Documentation generation
  gem 'rdoc', '~> 6.5'         # Alternative documentation
end