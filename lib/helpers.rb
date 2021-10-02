require 'json/ext'

def vms_json_loader(file)
  str = IO.read(file, encoding: 'UTF-8')
  JSON.parse(str, symbolize_names: true)
rescue Errno::ENOENT
  puts "JSON file w VMS list hasn't been created yet."
  {}
rescue JSON::ParserError
  backup_name = "#{file}.bak"
  puts "JSON file is corrupted, rename to: #{backup_name}"
  File.rename(file, backup_name)
  {}
end

def vms_json_json_save(hash, file)
  json = JSON.pretty_generate(hash)
  File.open(file, 'w') { |file| file.write json }
end
