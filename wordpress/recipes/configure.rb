# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase

# Create the Wordpress config file keys.php with corresponding values
node[:deploy].each do |application, deploy|
  Chef::Log.info("Configuring WP app #{application}...")

  if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'                                        
    Chef::Log.debug("Skipping WP Configure  application #{application} as it is not defined as php wp")
    next                                                                       
  end

  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/keys.php" do
    source "keys.php.erb"
    mode 0660
    group deploy[:group]
    owner deploy[:user]

    variables(
      # URI
      :home_url   => (deploy[:home_url] rescue nil),
      :site_url   => (deploy[:site_url] rescue nil),
      # database
      :database   => (deploy[:database][:database] rescue nil),
      :user       => (deploy[:database][:username] rescue nil),
      :password   => (deploy[:database][:password] rescue nil),
      :host       => (deploy[:database][:host] rescue nil),
      :keys       => (keys rescue nil),

      # authentication
      :auth_key         => (deploy[:authentication][:auth_key] rescue nil),
      :secret_auth_key  => (deploy[:authentication][:secret_auth_key] rescue nil),
      :logged_in_key    => (deploy[:authentication][:logged_in_key] rescue nil),
      :nonce_key        => (deploy[:authentication][:nonce_key] rescue nil),
      :auth_salt        => (deploy[:authentication][:auth_salt] rescue nil),
      :secure_auth_salt => (deploy[:authentication][:secure_auth_salt] rescue nil),
      :logged_in_salt   => (deploy[:authentication][:logged_in_salt] rescue nil),
      :nonce_salt       => (deploy[:authentication][:nonce_salt] rescue nil),

      :aws_access_key    => (deploy[:aws][:access_key] rescue nil),
      :aws_secret_key    => (deploy[:aws][:secret_key] rescue nil),
      :aws_redis_host    => (deploy[:aws][:redis_host] rescue nil),

      :domain     => (deploy[:domains].first))
  end
end
