#
# Cookbook Name:: cron_set
# Recipe:: default
#
if node[:name] == 'solo' 
  cron "Echo my name" do 
    minute '*/1' 
    user 'deploy'
    command "echo Amit" 
  end 
end