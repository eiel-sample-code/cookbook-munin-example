#
# Cookbook Name:: munin
# Recipe:: http_session_count
#
# Copyright 2013, Tomohiko Himura
#
# All rights reserved
#

package "ruby" do
  action :install
end

package "rubygems" do
  action :install
end

package 'ruby-json' do
  action :install
end

gem_package "munin"

template 'http_session_count' do
  path '/etc/munin/plugins/http_session_count'
  source 'http_session_count.rb.erb'
  owner 'root'
  group 'root'
  mode 0755

  notifies :restart, 'service[munin-node]'
end
