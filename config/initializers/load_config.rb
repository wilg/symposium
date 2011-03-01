# config/initializers/load_config.rb
APP_CONFIG = YAML.load_file("#{Rails.root}/config/symposium.yml")