require 'active_support'

if defined? Rails
  require 'activerecord/tablelocks/railties'
else
  ActiveSupport.on_load :active_record do
    require 'activerecord/tablelocks/activerecord'
  end
end