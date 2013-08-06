require 'rails'

class Tablelocks < Rails::Railtie

  initializer 'activerecord-tablelocks' do
    ActiveSupport.on_load :active_record do
      require 'activerecord/tablelocks/activerecord'
    end
  end
end