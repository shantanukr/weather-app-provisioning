# Install Python 3, pip3, Nginx
package 'python3'
package 'python3-pip'
package 'nginx'

# Create the application directory
directory '/opt/weather-app' do
    recursive true
end

# Download the Flask app (e.g., app.py) into the app directory
remote_file '/opt/weather-app/app.py' do
    source 'https://github.com/shantanukr/weather-app-provisioning/app.py'
    action :create
end

remote_file '/opt/weather-app/requirements.txt' do
  source 'https://github.com/shantanukr/weather-app-provisioning/requirements.txt'
  action :create
end

remote_file '/opt/weather-app/wsgl.py' do
  source 'https://github.com/shantanukr/weather-app-provisioning/wsgl.py'
  action :create
end

# Create a systemd service file for the Flask app using a template
template '/etc/systemd/system/flask.service' do
  source 'flask.service.erb'
  mode '0644'
end

# Create an Nginx site configuration file from a template
template '/etc/nginx/sites-available/weather_app' do
  source 'nginx.conf.erb'
  mode '0644'
end

# Create the .env file using a template with the secret key
template '/opt/weather_app/.env' do
  source '.env.erb'
  mode '0644'
  variables({
    secret_key: node['weather_app']['secret_key']
  })
end



# Enable the Nginx site by linking it from sites-available to sites-enabled
link '/etc/nginx/sites-enabled/weather_app' do
  to '/etc/nginx/sites-available/weather_app'
  notifies :restart, 'service[nginx]', :immediately  # Restart Nginx when the link is created
end

# Remove the default Nginx site if it exists to avoid port conflicts
execute 'remove default nginx site' do
  command 'rm -f /etc/nginx/sites-enabled/default'
  only_if { ::File.exist?('/etc/nginx/sites-enabled/default') }
end

# Ensure the Nginx service is enabled and started
service 'nginx' do
  action [:enable, :start]
end

# Reload systemd manager configuration to acknowledge new service files
execute 'reload systemd' do
  command 'systemctl daemon-reexec'
end

# Enable and start the Flask systemd service
service 'flask' do
  action [:enable, :start]
end
