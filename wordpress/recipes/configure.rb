# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Creates the config file wp-config.php with MySQL data.
# - Creates a Cronjob.
# - Imports a database backup if it exists.

require 'uri'
require 'net/http'
require 'net/https'

uri = URI.parse("https://api.wordpress.org/secret-key/1.1/salt/")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
keys = response.body


# Create the Wordpress config file wp-config.php with corresponding values
node[:deploy].each do |application, deploy|
  Chef::Log.info("Configuring WP app #{application}...")

  if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'                                        
    Chef::Log.debug("Skipping WP Configure  application #{application} as it is not defined as php wp")
    next                                                                       
  end

  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/current/wp-config.php" do
    source "wp-config.php.erb"
    mode 0660
    group deploy[:group]
    owner deploy[:user]

    variables(
      :database   => (deploy[:database][:database] rescue nil),
      :user       => (deploy[:database][:username] rescue nil),
      :password   => (deploy[:database][:password] rescue nil),
      :host       => (deploy[:database][:host] rescue nil),
      :keys       => (keys rescue nil),
      :domain     => (deploy[:domains].first))
  end
end
