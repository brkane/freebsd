def whyrun_supported?
  true
end

action :create do
Chef::Log.debug(@current_resource.exists)
  unless @current_resource.exists && @current_resource.value == new_resource.value
    Chef::Log.debug("Updating rc.conf - Name: #{new_resource.name}, Value: #{new_resource.value}")
    rc_lines = ::File.readlines("/etc/rc.conf")
    rc_lines = find_and_replace_option rc_lines, new_resource
    write_rc_file rc_lines
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @current_resource = Chef::Resource::FreebsdRcOption.new(@new_resource.name)

  Chef::Log.debug("Checking rc.conf for option #{@new_resource.name}")
  option = ::File.open("/etc/rc.conf") {|f| f.grep option_regex(@new_resource.name)}.first
  if option
    value = option.match(/="?(.*)"?$/)
    @current_resource.value = value
    Chef::Log.debug(
      "Option found - Name: #{@current_resource.name}, Value: #{@current_resource.value}")
    @current_resource.exists(true)
  else
    Chef::Log.debug("Option not found - Name: #{@current_resource.name}")
    @current_resource.exists(false)
  end

  @current_resource
end

private

def find_and_replace_option(lines, option)
  lines = lines.reject { |line| line =~ option_regex(option.name) }
  lines << "#{option.name}=\"#{option.value}\""
end

def write_rc_file(rc_options)
  ::File.open("/etc/rc.conf", "w") do |f|
    rc_options.each do |line|
      f.puts line
    end
  end
end

def option_regex(option_name)
  ::Regexp.new "^(#{option_name})=\"?(.*)\"?"
end
