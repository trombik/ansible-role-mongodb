require "spec_helper"
require "serverspec"

package = "mongodb"
service = "mongodb"
config  = "/etc/mongodb.conf"
user    = "mongodb"
group   = "mongodb"
ports   = [27_017]
log_dir = "/var/log/mongodb"
db_dir  = "/var/lib/mongodb"
extra_packages = []
users = [
  { name: "root", db: "admin", roles: [{ role: "userAdminAnyDatabase", db: "admin" }] },
  { name: "foo", db: "admin", roles: [{ role: "read", db: "admin" }] }
]

case os[:family]
when "freebsd"
  service = "mongod"
  config = "/usr/local/etc/mongodb.conf"
  db_dir = "/var/db/mongodb"
  package = "databases/mongodb40"
  extra_packages = %w[databases/mongodb40-tools databases/pymongo]
end

extra_packages.each do |p|
  describe package p do
    it { should be_installed }
  end
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("mongodb") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file "#{log_dir}/mongod.log" do
  it { should exist }
  it { should be_file }
  case os[:family]
  when "ubuntu"
    it { should be_mode 644 }
  else
    it { should be_mode 600 }
  end
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/mongod") do
    it { should be_file }
    its(:content) { should match(/Managed by ansible/) }
  end
when "ubuntu"
  describe file("/etc/default/mongodb") do
    it { should be_file }
    its(:content) { should match(/Managed by ansible/) }
    its(:content) { should match(/DAEMON_OPTS="--journal"/) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

users.each do |u|
  mongo_cmd = "JSON.stringify(db.getUser('#{u[:name]}'))"
  describe command "mongo --quiet -u root -p AdminPassWord --eval #{Shellwords.escape(mongo_cmd)} admin" do
    its(:exit_status) { should eq 0 }
    case os[:family]
    when "freebsd"
      its(:stderr) do
        pending "https://github.com/bitcoin/bitcoin/pull/16059"
        should eq ""
      end
    else
      its(:stderr) { should eq "" }
    end
    its(:stdout_as_json) { should include("user" => u[:name]) }
    its(:stdout_as_json) { should include("db" => u[:db]) }
    u[:roles] .each do |role|
      its(:stdout_as_json) { should include("roles" => include("role" => role[:role], "db" => role[:db])) }
    end
  end
end
