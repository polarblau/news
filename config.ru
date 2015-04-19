require 'rack'
require 'rack/contrib/try_static'
# require 'middleman'

# Serve files from the build directory
use Rack::TryStatic,
  :root => 'build',
  :urls => %w[/],
  :try  =>['.html', 'index.html', '/index.html']

run lambda{ |env|
  not_found = File.expand_path("../build/404/index.html", __FILE__)
  [ 404, { 'Content-Type'  => 'text/html'}, [ File.read(not_found) ]]
}

# run Middleman::Application.server