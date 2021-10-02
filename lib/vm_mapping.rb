class VM_Mapping

  def self.mapping
    vms_vagrant = VM_Vagrant.get_vms_list
    vms_vbox = VM_Vbox.get_vms_list

    vms_vagrant.each_with_object({}) do |(id, name), hash|
      uid_vbox = vms_vbox.keys.select { |id_vbox| /^#{id}/.match? id_vbox }.first
      status = VM_Vbox.get_vm_status(uid_vbox)

      vm = VM_Vagrant.new(name: name, id: id, uid_vbox: uid_vbox, status: status)

      hash[id] = vm
    end
  end
end
