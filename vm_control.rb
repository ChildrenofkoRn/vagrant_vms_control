require_relative 'lib/loader'
require_relative 'lib/runner'
require_relative 'lib/vm_vagrant'
require_relative 'lib/vm_vbox'
require_relative 'lib/vm_mapping'
require_relative 'lib/console_ui'

$stdout.sync = true
VERSION = '1.1.0'

trap "SIGINT" do
  puts "Ctrl+C => Exiting"
  exit 0
end

class VM_Control
  VMS_JSON_PATH = File.join(__dir__, 'vms.json')

  def initialize
    ConsoleUI.greeting
    vms_init
  end

  def run_ui
    loop do
      vm = ConsoleUI.vm_selector(@vms)
      action = ConsoleUI.action_selector(vm)

      case action
      when /^remap/
        puts 'underway!'
        # to realize
        # update_json_vms(vms)
        vm.update_status
      when /^return/
        # doing nothing, auto-return main menu
      else
        vm.public_send(action)
        vm.update_status
      end
    end
  end

  private

  def vms_init
    @vms = Loader.vms_json_loader(VMS_JSON_PATH)

    if @vms.empty?
      @vms = VM_Mapping.mapping
      updater_json_vms
    else
      @vms.transform_values! do |vm|
        vm[:box] = VM_Vbox.new(**vm[:box])
        VM_Vagrant.new(**vm)
      end
    end
  end

  def updater_json_vms
    json_hash = @vms.dup.transform_values(&:to_h)
    Loader.vms_json_save(json_hash, VMS_JSON_PATH)
  end
end

VM_Control.new.run_ui
