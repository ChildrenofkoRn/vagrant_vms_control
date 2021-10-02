require_relative 'lib/helpers'
require_relative 'lib/runner'
require_relative 'lib/vm_vagrant'
require_relative 'lib/vm_vbox'
require_relative 'lib/vm_mapping'
require_relative 'lib/console_ui'

VERSION = '1.0.0'
STDOUT.sync = true
VMS_JSON_PATH = File.join(__dir__, 'vms.json')

trap "SIGINT" do
  puts "Ctrl+C => Exiting"
  exit 0
end

class VM_Control
  def initialize
    vms_init
  end

  def run_ui
    greeting

    loop do
      vm = ConsoleUI.vm_selector(@vms)
      action = ConsoleUI.action_selector(vm)

      case action
      when /^remap/
        puts 'underway!'
        # to realize
        # update_json_vms(vms)
        vm.status = VM_Vbox.get_vm_status(vm.uid_vbox)
      when /^return/
        # doing nothing, auto-return main menu
      else
        vm.send(action)
        vm.status = VM_Vbox.get_vm_status(vm.uid_vbox)
      end
    end
  end

  private

  def greeting
    puts
    puts 'Hi, dude!'
    puts 'This util for control vagrants VMs on Vbox.'
    puts "Ctrl+C => Exiting"
  end

  def vms_init
    @vms = vms_json_loader(VMS_JSON_PATH)

    if @vms.empty?
      @vms = VM_Mapping.mapping
      updater_json_vms
    else
      @vms.transform_values! do |vm|
        vm[:status] = VM_Vbox.get_vm_status(vm[:uid_vbox])
        VM_Vagrant.new(**vm)
      end
    end
  end

  def updater_json_vms
    json_hash = @vms.dup.transform_values(&:to_h)
    vms_json_json_save(json_hash, VMS_JSON_PATH)
  end
end

VM_Control.new.run_ui
