class VM_Vagrant
  extend Runner

  VAGRANT_BIN = 'C:\HashiCorp\Vagrant\bin\vagrant.exe'
  ACTIONS = {
    start:   'up',
    stop:    'halt',
    pause:   'suspend',
    resume:  'resume',
  }.freeze

  def self.get_vms_list
    params = [
      VAGRANT_BIN,
      'global-status',
    ].join(' ')

    stdout = runner(params).first
    vms = stdout.split("\n").select { |line| /^\w{7}\s.*boxes/.match? line }
    vms.map { |line| line.split(/\s+/).first(2) }
  end

  ACTIONS.keys.each do |action|
    define_method action do
      action(action)
    end
  end

  attr_accessor :name, :id, :uid_vbox, :status

  def initialize(name:, id:, uid_vbox: nil, status: nil)
    @name = name
    @id = id
    @uid_vbox = uid_vbox
    @status = status
  end

  def to_h
    {
      name: name,
      id: id,
      uid_vbox: uid_vbox
    }
  end

  private

  def action(action)
    params = [
      VAGRANT_BIN,
      ACTIONS[action],
      @id,
    ].join(' ')

    # p params
    self.class.runner_pipe(params)
  end

end
