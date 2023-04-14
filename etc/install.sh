# 2023/04/14 Amazon Linux 2

yum update -y
amazon-linux-extras install -y epel
yum groupinstall -y "Development Tools"
yum install -y wget git tmux dstat htop monit tree colordiff
yum install -y openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

yum remove -y mariadb-libs
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install -y mysql-community-server mysql-community-devel
# chown mysql:mysql /var/lib/mysql
sudo mysqld --initialize-insecure --user=mysql
sudo mysql_secure_installation
# systemctl start mysqld

amazon-linux-extras install redis6
# systemctl start redis

amazon-linux-extras install nginx1
cp ./nginx.conf /etc/nginx/conf.d/meyasubako.conf
# Remove PrivateTmp=true from /lib/systemd/system/nginx.service
# systemctl start nginx

# https://github.com/egotter/egotter/wiki/Install-Ruby
wget http://cache.ruby-lang.org/pub/ruby/3.1/ruby-3.1.3.tar.gz
tar xvfz ruby-3.1.3.tar.gz
cd ruby-3.1.3
./configure && make && make install
yum install -y ruby-devel
gem update bundler
# bundle update --bundler

# The limits for systemd are set to maximum: /etc/systemd/system.conf.d/50-limits.conf
# cat <<EOS >>/etc/security/limits.conf
# root soft nofile 65536
# root hard nofile 65536
# * soft nofile 65536
# * hard nofile 65536
# EOS
# grep 'Max open files' /proc/[PID]/limits

echo "net.ipv4.tcp_max_syn_backlog = 512" >>/etc/sysctl.conf
echo "net.core.somaxconn = 512" >>/etc/sysctl.conf
echo "vm.overcommit_memory = 1" >>/etc/sysctl.conf
sysctl -p

echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >>/etc/rc.local

git clone https://github.com/ts-3156/meyasubako.git
chown -R ec2-user:ec2-user meyasubako
# cd meyasubako

bundle config set path '.bundle'
bundle config set without 'test development'
bundle install

curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum install -y nodejs yarn

yarn install --check-files
# Copy config/master.key and .env
RAILS_ENV=production bundle exec rails db:create db:migrate assets:precompile

bundle exec rails s -e production
# bundle exec puma -C config/puma/production.rb
cp ./puma.service /etc/systemd/system
systemctl daemon-reload
