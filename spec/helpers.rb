module Helpers
  def create_argv repo_name
    CLAide::ARGV.new([repo_name])
  end

  def create_argv_with_url repo_name, repo_url
    CLAide::ARGV.new([repo_name, repo_url])
  end
end