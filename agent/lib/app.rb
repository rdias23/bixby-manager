
require File.dirname(__FILE__) + "/cli"

class App

    include CLI

    def load_agent
        uri = @argv.empty? ? nil : @argv.shift
        root_dir = @config[:directory]

        agent = Agent.create(uri, root_dir)
        if not agent.new? and agent.mac_changed? then
            # loaded from config and mac has changed
            agent.deregister_agent()
            agent = Agent.create(uri, root_dir, false)
        end
        if agent.new? then
            agent.register_agent()
            agent.save_config()
        end
        agent
    end

    def run!

        agent = load_agent()

        require AGENT_ROOT + "/lib/server"
        Server.agent = agent
        Server.run!

    end

end
