# AWS OpsWorks Recipe for Swagger to be executed during the Configure lifecycle phase

# Create the Swagger home template with the correct api_url 
node[:deploy].each do |application, deploy|
  Chef::Log.info("Configuring Swagger app #{application}...")

  if defined?(deploy[:application_type]) && deploy[:application_type] != 'node'                                        
    Chef::Log.debug("Skipping Swagger Configure  application #{application} as it is not defined as node")
    next                                                                       
  end

  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/home.js" do
    source "home.js.erb"
    mode 0660
    group deploy[:group]
    owner deploy[:user]

    variables(:api_url    => (deploy[:api_url] rescue nil))
  end
end
