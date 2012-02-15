
require 'helper'

class TestProvisioning < MiniTest::Unit::TestCase

  def setup

    WebMock.reset!

    @manager_uri = "http://localhost:3000"
    @password = "foobar"
    @root_dir = "/tmp/agent_test_temp"
    @port = 9999
    `rm -rf #{@root_dir}`

    @agent = Agent.create(@manager_uri, @password, @root_dir, @port)

    BaseModule.manager_uri = @manager_uri
    @api_url = @manager_uri + "/api"

  end

  def test_list_files

    stub_request(:post, @api_url).to_return(:status => 200, :body => '{}')
    Agent.stubs(:create).returns(@agent)

    cmd = CommandSpec.new({ :repo => "support", :bundle => "test_bundle", :command => "echo" })
    ret = Provisioning.list_files(cmd)

    assert_requested(:post, @manager_uri + "/api", :times => 1) { |req|
      req.body == '{"operation":"provisioning:list_files","params":{"repo":"support","bundle":"test_bundle","command":"echo"}}'
    }

  end

  def test_download_files

    path = File.expand_path(File.dirname(__FILE__)) + "/support/test_bundle/bin"

    stub_request(:post, @api_url).to_return(:status => 200, :body => '{}')
    Agent.stubs(:create).returns(@agent)

    sha = Digest::SHA1.new

    cmd = CommandSpec.new({ :repo => "support", :bundle => "test_bundle", :command => "echo" })
    files = [
      { "file" => "bin/echo", "sha1" => sha.hexdigest(File.read("#{path}/echo")) },
      { "file" => "bin/cat", "sha1" => sha.hexdigest(File.read("#{path}/cat")) }
    ]

    body1 = '{"operation":"provisioning:fetch_file","params":[{"repo":"support","bundle":"test_bundle","command":"echo"},"bin/echo"]}'
    body2 = '{"operation":"provisioning:fetch_file","params":[{"repo":"support","bundle":"test_bundle","command":"echo"},"bin/cat"]}'

    req1 = stub_request(:post, @api_url).with(:body => body1).to_return(:status => 200, :body => File.new("#{path}/echo"))
    req2 = stub_request(:post, @api_url).with(:body => body2).to_return(:status => 200, :body => File.new("#{path}/cat"))

    Provisioning.download_files(cmd, files)

    assert_requested(req1)
    assert_requested(req2)

    file1 = File.join(@root_dir, "repo", "support", "test_bundle", "bin", "echo")
    file2 = File.join(@root_dir, "repo", "support", "test_bundle", "bin", "cat")

    # verify that files got created and with correct permissions
    [ file1, file2 ].each do |file|
      assert File.exists? file
      assert_equal 33261, File.stat(file).mode
    end

    assert_equal sha.hexdigest(File.read("#{path}/echo")), sha.hexdigest(File.read(file1))
    assert_equal sha.hexdigest(File.read("#{path}/cat")), sha.hexdigest(File.read(file2))

  end

end