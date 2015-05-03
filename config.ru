require 'rack'
require 'rack/contrib/try_static'

# Serve files from the build directory
use Rack::TryStatic,
  :root => 'build',
  :urls => %w[/],
  :try  =>['.html', 'index.html', '/index.html']

run lambda{ |env|
  not_found = File.expand_path("../build/404.html", __FILE__)
  [ 404, { 'Content-Type'  => 'text/html'}, [ File.read(not_found) ]]
}