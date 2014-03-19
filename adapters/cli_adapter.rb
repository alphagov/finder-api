class CliAdapter
  def initialize(stdout)
    @stdout = stdout
  end

  def success(data)
    stdout.puts data.fetch(:message, "")
  end

  def created(data)
    stdout.puts data.fetch(:message, "")
  end

  def params
    {}
  end

  private

  attr_reader :stdout
end
