
require 'helper'

class TestDevopsAgentExec < MiniTest::Unit::TestCase

  def setup
    @bundle_path = File.expand_path(File.dirname(__FILE__)) + "/support/test_bundle"
    h = { :repo => "support", :bundle => "test_bundle", 'command' => "echo", :foobar => "baz" }
    @c = CommandSpec.new(h)

    @manager_uri = "http://localhost:3000"
    @password = "foobar"
    @root_dir = "/tmp/agent_test_temp"
    @port = 9999
    `rm -rf #{@root_dir}`
    @agent = Agent.create(@manager_uri, @password, @root_dir, @port)
  end

  def test_exec_error
    # throws the first time
    assert_throws(BundleNotFound) do
      @agent.exec(@c.to_hash)
    end
  end

  def test_exec_pass
    # copy repo to path
    `mkdir -p #{@root_dir}/repo/support`
    `cp -a #{@bundle_path} #{@root_dir}/repo/support/`
    (status, stdout, stderr) = @agent.exec(@c.to_hash)
    assert status
    assert stdout
    assert stderr
    assert(status.success?)
    assert_equal("hi\n", stdout)
    assert_equal("", stderr)
  end

end