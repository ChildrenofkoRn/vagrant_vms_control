module ConsoleUI
  module_function

  def greeting
    puts "\nHi, dude!"
    puts 'This util for control vagrants VMs on Vbox.'
    puts 'Ctrl+C => Exiting'
    puts
  end

  def reader_console
    print "Your choice:\t"
    gets.encode("utf-8", $terminal_enc).chomp
  end

  def print_vms_vagrant(vms)
    template = "%2s\s\s%-12s\t%10s\t%10s\t%12s"
    header = format(template, '#', 'name', 'id', 'status', 'uptime')

    puts "\n", header
    puts '-' * 70

    vms.each_with_index do |(_id, vm), idx|
      puts format(template, idx, vm.name, vm.id, vm.status, vm.uptime)
    end
    puts
  end

  def selector(menu_size)
    # TODO: N tries?
    loop do
      input = reader_console
      number = input.to_i
      unless (/[0-9]+/.match? input) && number <= menu_size - 1
        puts "\tOops, Try again."
        next
      end
      puts
      break number
    end
  end

  def vm_selector(vms)
    print_vms_vagrant(vms)
    vm_number = selector(vms.size)
    vms.values[vm_number]
  end

  def action_selector(vm)
    puts "Actions for vm: #{vm.name}\n\n"

    actions = VM_Vagrant::ACTIONS.keys + ['remap', 'return to main menu']
    template = "%2s\s\s%-10s"
    actions.each_with_index { |action, idx| puts format(template, idx, action) }
    puts
    id = selector(actions.size)
    actions[id]
  end
end
