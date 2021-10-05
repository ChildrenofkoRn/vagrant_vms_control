class VM_Mapping
  def self.mapping
    vms_vagrant = VM_Vagrant.vms_list
    vms_vbox = VM_Vbox.vms_list

    vms_vagrant.each_with_object({}) do |(id, name), hash|
      box = find_vm_box(vms_vbox, id)
      box = VM_Vbox.new(**box)

      hash[id] = VM_Vagrant.new(name: name, id: id, box: box)
    end
  end

  def self.find_vm_box(boxes, id)
    box = boxes.select { |vm| /^#{id}/.match? vm[:uid] }.first
    box.nil? ? { name: nil, uid: nil } : box
  end
end
