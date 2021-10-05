require 'json/ext'
require 'yaml'
require 'time'

module Loader
  module_function

  def get_os
    case Gem::Platform.local.os
    when /mswin|msys|mingw|cygwin/
      :windows
    when /darwin|mac os/
      :mac
    when /linux/
      :linux
    else
      :unknown
    end
  end

  def read_setting(filepath)
    str = IO.read(filepath, encoding: 'UTF-8')
    YAML.load(str, symbolize_names: true)
  rescue Errno::ENOENT
    puts "404: #{filepath}"
    exit 1
  end

  def load_setting(filepath)
    sets = read_setting(filepath)
    sets[:custom].nil? ? sets[get_os] : sets[:custom]
  end

  def vms_json_loader(filepath)
    str = IO.read(filepath, encoding: 'UTF-8')
    JSON.parse(str, symbolize_names: true)
  rescue Errno::ENOENT
    puts "JSON file w VMS list hasn't been created yet."
    {}
  rescue JSON::ParserError
    backup_name = "#{filepath}.bak"
    puts "JSON file is corrupted, rename to: #{backup_name}"
    File.rename(filepath, backup_name)
    {}
  end

  def vms_json_save(hash, filepath)
    json = JSON.pretty_generate(hash)
    File.open(filepath, 'w') { |file| file.write json }
  end

  def load
    root = File.expand_path('..', __dir__)
    sets = load_setting(File.join(root, 'settings.yml'))
    $vagrant      = format('"%s"', sets[:vagrant])
    $vbox         = format('"%s"', sets[:vbox])
    $terminal_enc = format('%s',   sets[:encoding])
  end
end

Loader.load
