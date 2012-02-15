
module RemoteExec

  module Methods

    def exec(agent, command)

      command = create_spec(command)

      ret = agent.run_cmd(command)
      if ret.success? then
        return ret
      end

      if ret.code != 404 then
        # error we can't handle, return
        return ret
      end

      # try to provision it, then try again
      pret = Provisioning.new.provision(agent, command)

      if not pret.success? then
        # failed to provision, bail out
        return pret # TODO raise err?
      end

      return agent.run_cmd(command)
    end

    # Convert various inputs to a CommandSpec wrapper
    #
    # @param [Object] command Can be a Hash/Command/String/CommandSpec
    # @return [CommandSpec]
    def create_spec(command)
      if command.kind_of? Command then
        command.to_command_spec
      elsif command.kind_of? Hash then
        CommandSpec.new(command)
      elsif command.kind_of? String then
        CommandSpec.from_json(command)
      else
        command
      end
    end

  end

  class << self
    include Methods
  end

  include Methods

end