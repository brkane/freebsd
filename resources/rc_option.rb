actions :create

attribute :name, kind_of: String, name_attribute: true
attribute :value, kind_of: String

def initialize(*args)
  super

  @exists = false
end

def exists(arg=nil)
  set_or_return(
    :exists,
    arg,
    :kind_of => [ TrueClass, FalseClass ]
  )
end
