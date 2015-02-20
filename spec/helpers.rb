module Helpers
  def create_argv repo_name
    CLAide::ARGV.new([repo_name])
  end

  def create_argv_with_url repo_name, repo_url
    CLAide::ARGV.new([repo_name, repo_url])
  end

  def call_so command
    resp = `#{command}`
    resp[0..resp.length-2]
  end

  def root_dir
    so_user = call_so 'id -un'
    "/Users/#{so_user}"
  end
end