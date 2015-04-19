dev = OpenStruct.new({
  :ssh_user    => "polarbla@polarblau.com",
  :local_root  => "./build/",
  :remote_root => "public_html/PATH",
  :public_url  => "http://www.polarblau.com/PATH/"
})

desc "Deploy 'deploy' dir to #{dev.ssh_user}:#{dev.remote_root}"
task :deploy do
  Dir.chdir(".") do
    puts "Building static files"
    system("bundle exec middleman build")
    puts
    puts "Deploying: #{Dir.pwd} -> #{dev.ssh_user}:#{dev.remote_root}"
    puts
    system("rsync -cvr --delete --exclude-from ./deploy_excludes.txt #{dev.local_root} #{dev.ssh_user}:#{dev.remote_root}")
    puts
    puts "Done."
  end
end

desc "Update bourbon and neat and fetch latest normalize.css"
task :update do
  puts "Updating bourbon ..."
  system "bourbon update --path source/stylesheets/vendor"
  puts "Updating neat ..."
  # neat doesn't currently support the --path flag so we'll use a
  # subshell instead:
  system "(cd source/stylesheets/vendor && neat update)"
  puts "Updating normalize.css ..."
  system "curl -o source/stylesheets/vendor/_normalize.scss https://raw.github.com/necolas/normalize.css/master/normalize.css"
end

