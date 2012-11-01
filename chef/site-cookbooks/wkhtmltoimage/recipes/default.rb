package "libxrender1" do
  action :install
end

package "libfontconfig1" do
  action :install
end

execute "Download and install wkhtmltoimage" do
  command "mkdir /tmp/wkhtmltoimage;
    cd /tmp/wkhtmltoimage &&
    wget https://wkhtmltopdf.googlecode.com/files/wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2 &&
    tar -xf wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2 &&
    mv wkhtmltoimage-amd64 /usr/local/bin/wkhtmltoimage"
end