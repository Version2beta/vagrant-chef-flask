# Cookbook Name:: configure
# Recipe:: default
#
# Copyright 2013, Example Com
#
#

# execute 'DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade'

package "python"
package "git"
include_recipe "nginx_conf"
python_pip "ipython" do
  action :install
end
python_pip "flask" do
  action :install
end
python_pip "Frozen-Flask" do
  action :install
end
python_pip "markdown2" do
  action :install
end
python_pip "pygments" do
  action :install
end
python_pip "PyYAML" do
  action :install
end
python_pip "boto" do
  action :install

directory "/home/vagrant/blog/" do
  owner "vagrant"
  group "vagrant"
end

directory "/home/vagrant/.ssh" do
  owner "vagrant"
  mode 00700
  recursive true
end

directory "/home/vagrant/.aws" do
  owner "vagrant"
  mode 00700
  recursive true
end

directory "/home/vagrant/bin" do
  owner "vagrant"
  group "vagrant"
end

remote_file "/home/vagrant/bin/vcprompt" do
  source "https://raw.github.com/djl/vcprompt/master/bin/vcprompt"
  action :create_if_missing
  owner "vagrant"
  group "vagrant"
  mode 00755
end

cookbook_file "/home/vagrant/.profile" do
  source "bash_profile"
  owner "vagrant"
  group "vagrant"
  mode 00755
end

cookbook_file "/home/vagrant/.vimrc" do
  source "vimrc"
  owner "vagrant"
  group "vagrant"
  mode 00755
end

gitbag = data_bag_item("git", "ssh_keys")
ssh_public = gitbag["_default"]["public_key"]
ssh_private = gitbag["_default"]["private_key"]
known_hosts = gitbag["_default"]["known_hosts"]
awsbag = data_bag_item("aws", "aws_keys")
access_key = awsbag["_default"]["access_key"]
secret_key = awsbag["_default"]["secret_key"]

file "/home/vagrant/.ssh/id_rsa.pub" do
  content ssh_public
  owner "vagrant"
  group "vagrant"
  mode 00600
end

file "/home/vagrant/.ssh/id_rsa" do
  content ssh_private
  owner "vagrant"
  group "vagrant"
  mode 00600
end

file "/home/vagrant/.ssh/known_hosts" do
  content known_hosts
  owner "vagrant"
  group "vagrant"
  mode 00600
end

file "/home/vagrant/.aws/access_key" do
  content access_key
  owner "vagrant"
  group "vagrant"
  mode 00600
end

file "/home/vagrant/.aws/secret_key" do
  content secret_key
  owner "vagrant"
  group "vagrant"
  mode 00600
end

cookbook_file "/home/vagrant/.gitconfig" do
  source "gitconfig"
  owner "vagrant"
  group "vagrant"
  mode 00755
end

git "/home/vagrant/blog" do
  repository "git@github.com:Version2beta/version2beta.git"
  revision "master"
  user "vagrant"
  group "vagrant"
  action :sync
end

directory "/var/www/" do
  owner "www-data"
  group "www-data"
  owner 00777
end

link "/var/www/blog" do
  to "/home/vagrant/blog"
end

nginx_conf_file "dev.version2beta.com" do
  root "/var/www/blog"
end

