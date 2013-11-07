#
# Cookbook Name:: munin
# Recipe:: default
#
# Copyright 2013, Tomohiko Himura
#
# All rights reserved
#

include_recipe 'yum::epel'

# setup munin
package "httpd" do
  action :install
end

service "httpd" do
  action [:enable, :start]
end

package "munin" do
  action :install
end

template "munin.conf" do
  path "/etc/httpd/conf.d/munin.conf"
  source "munin.conf.erb"
  owner "root"
  group"root"
  mode 0644

  notifies :reload, 'service[httpd]'
end

node[:munin][:users].each do |u|
  htpasswd "/etc/munin/munin-htpasswd" do
    user u[:user]
    password u[:password]
  end
end

service 'crond' do
  supports :status => true, :restart => true
  action [:enable, :start]
end

# setup munin-node
package "munin-node" do
  action :install
end

service "munin-node" do
  supports :status => true, :restart => true
  action [:enable, :start]
end
