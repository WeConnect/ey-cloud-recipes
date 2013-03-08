#
# Cookbook Name:: cron_set
# Recipe:: default
#
if node[:environment][:name] == "WeConnect_development"
  app_env = 'staging'
elsif node[:environment][:name] == "WeConnect_preproduction"
  app_env = 'pre_production'
elsif node[:environment][:name] == "WeConnect"
  app_env = 'production'
end

if ['solo','app_master'].include?(node[:instance_role])
  cron "Chef Name: Move Out - EST" do
    minute "5"
    hour "21"
    user 'deploy'
    command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} time_zone='Eastern Time (US & Canada)' bundle exec rake move_outs:update_status --trace"
  end

  cron "Chef Name: Move In - EST" do
    minute "10"
    hour "21"
    user 'deploy'
    command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} time_zone='Eastern Time (US & Canada)' bundle exec rake move_ins:update_status --trace"
  end

  cron "Chef Name: Unconfirmed MIMO mailer - EST" do
    minute "15"
    hour "21"
    user 'deploy'
    command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} time_zone='Eastern Time (US & Canada)' bundle exec rake unconfirmed_mimo_mailer:deliver --trace"
  end

  cron "Chef Name: Move Out - PST" do
    minute "5"
    hour "0"
    user 'deploy'
    command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} time_zone='Pacific Time (US & Canada)' bundle exec rake move_outs:update_status --trace"
  end

  cron "Chef Name: Move In - PST" do
    minute "10"
    hour "0"
    user 'deploy'
    command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} time_zone='Pacific Time (US & Canada)' bundle exec rake move_ins:update_status --trace"
  end

  cron "Chef Name: Unconfirmed MIMO mailer - PST" do
    minute "15"
    hour "0"
    user 'deploy'
    command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} time_zone='Pacific Time (US & Canada)' bundle exec rake unconfirmed_mimo_mailer:deliver --trace"
  end

  if ['WeConnect'].include?(node[:environment][:name])
    cron "Chef Name: Pending Invoices Email" do
      minute "55"
      hour "23"
      user 'deploy'
      command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} bundle exec rake invoices:email_urls --trace"
    end

    cron "Chef Name: Invoice Sync Email" do
      minute "0"
      hour "2"
      user 'deploy'
      command "cd /data/WeConnect/current/ && RAILS_ENV=#{app_env} bundle exec rake invoices:sync_with_qb --trace"
    end    
  end
end