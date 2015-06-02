include_recipe 'freebsd::default'

freebsd_rc_option "test_option" do
  action :create
  value "test_value"
end
