# Extends AR to add table locking
module ActiveRecord
  class Base
    class << self
      attr_reader :locking_enabled

      def enable_locking(options = {})
        @locking_enabled = true
        @lock_targets = {
          :class_names => [*options[:class_names]].compact,
          :table_names => [*options[:table_names]].compact
        }
      end

      def lock_targets
        @lock_targets ||= {
          :class_names => [],
          :table_names => []
        }
      end

      def tables_to_lock
        return [] unless @locking_enabled
        [quoted_table_name,
          *@lock_targets[:table_names].map{|table_name| connection.quote_table_name(table_name) },
          *@lock_targets[:class_names].map{|class_name| class_name.constantize.quoted_table_name }].sort.uniq
      end
    end

    def add_to_transaction
      if self.class.locking_enabled
        self.class.connection.lock_tables self.class.tables_to_lock
      end
      super
    end
  end
  module ConnectionAdapters
    class AbstractAdapter
      def self.inherited(subclass)
        case subclass.name
        when "ActiveRecord::ConnectionAdapters::PostgreSQLAdapter"
          require 'activerecord/tablelocks/activerecord/postgres'
        end
      end
      def lock_table(quoted_table_name)
        logger.warn "WARNING: Locking is not supported for your database!"
      end
      def lock_tables(quoted_table_names)
        logger.warn "WARNING: Locking is not supported for your database!"
      end
    end
    if defined?(PostgreSQLAdapter)
      require 'activerecord/tablelocks/activerecord/postgres'
    end
  end
end