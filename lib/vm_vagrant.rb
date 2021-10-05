class VM_Vagrant
  extend Runner

  VAGRANT_BIN = $vagrant.freeze
  ACTIONS = {
    start:   'up',
    stop:    'halt',
    pause:   'suspend',
    resume:  'resume',
  }.freeze

  def self.vms_list
    params = [
      VAGRANT_BIN,
      'global-status'
    ].join(' ')

    stdout = runner(params).first
    vms = stdout.split("\n").select { |line| /^\w{7}\s.*boxes/.match? line }
    vms.map { |line| line.split(/\s+/).first(2) }
  end

  ACTIONS.each_key do |action|
    define_method action do
      action(action)
    end
  end

  attr_accessor :name, :id, :box

  def initialize(name:, id:, box:)
    @name = name
    @id = id
    @box = box
  end

  def update_status
    @box.update_status
  end

  def uptime
    @box.uptime
  end

  def status
    @box.status
  end

  def to_h
    {
      name: name,
      id: id,
      box: @box.to_h
    }
  end

  private

  def action(action)
    params = [
      VAGRANT_BIN,
      ACTIONS[action],
      @id
    ].join(' ')

    self.class.runner_pipe(params)
  end
end
