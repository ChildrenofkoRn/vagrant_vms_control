class VM_Vbox
  extend Runner

  VBOX_BIN = '"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"'.freeze
  VBOX_PARAMS = {
    get_list: 'list vms',
    info: 'showvminfo'
  }.freeze

  def self.get_vms_list
    params = [
      VBOX_BIN,
      VBOX_PARAMS[:get_list]
    ].join(' ')

    vms = runner(params).first.split("\n")
    vms.map! { |line| line.split(/\s+/).first(2).reverse }
    vms.to_h.transform_keys { |key| key.delete('{}') }
  end

  def self.get_vm_status(uid)
    return 'N/A' if uid.nil?

    params = [
      VBOX_BIN,
      VBOX_PARAMS[:info],
      uid
    ].join(' ')
    info = runner(params).first.split("\n")
    info.select { |line| /^State:/.match? line }.first.match(/(?:State:\s+)(.*)(?:\s+\(since)/)[1]
  end
end
