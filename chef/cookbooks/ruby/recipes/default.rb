
version='10.14.0'
omnibus_url = 'http://s3.amazonaws.com/opscode-full-stack/ubuntu-11.04-i686/chef-full_0.10.4-4_i386.deb'
omnibus_package = "#{Chef::Config[:file_cache_path]}/chef-full_0.10.4-4_i386.deb"
Chef::Log.info(omnibus_url)
Chef::Log.info(omnibus_package)


execute "download_omnibus_chef" do
	cwd Chef::Config[:file_cache_path]
	command "wget -c #{omnibus_url}"
	creates omnibus_package	
end


dpkg_package "chef" do
	source omnibus_package
end
