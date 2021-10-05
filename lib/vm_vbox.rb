class VM_Vbox
  extend Runner

  VBOX_BIN = $vbox.freeze
  VBOX_PARAMS = {
    get_list: 'list vms',
    info: 'showvminfo'
  }.freeze

  def self.vms_list
    params = [
      VBOX_BIN,
      VBOX_PARAMS[:get_list]
    ].join(' ')

    vms = runner(params).first.split("\n")
    vms.map! do |line|
      line.match(/"(?<name>[^"]+)"\s+{(?<uid>[\w-]+)}/)
          .named_captures.transform_keys(&:to_sym)
    end
  end

  def self.get_info(uid)
    params = [
      VBOX_BIN,
      VBOX_PARAMS[:info],
      uid
    ].join(' ')
    runner(params).first.split("\n")
  end

  attr_accessor :name, :uid, :status, :timing

  def initialize(name:, uid:)
    @name = name
    @uid = uid
    update_status
  end

  def update_status
    return if empty?

    info = self.class.get_info(@uid)
    status_str = info.select { |line| /^State:/.match? line }.first
    matched = status_str.match(/(?:State:\s+)(?<status>.*)\s+\(since\s(?<since>[^)]+)\)?/)
    @status = matched[:status]
    @timing = matched[:since]
  end

  def running?
    @status == 'running'
  end

  def empty?
    uid.nil?
  end

  def uptime
    return '' unless running?

    seconds = Time.now - Time.iso8601(@timing) - Time.now.gmt_offset
    time = Time.at(seconds).utc.strftime('%H:%M:%Ss')
    hours = seconds.div(24 * 60 * 60)
    hours.zero? ? time : format("%sd\s%s", hours, time)
  end

  def to_h
    { uid: @uid, name: @name }
  end
end
