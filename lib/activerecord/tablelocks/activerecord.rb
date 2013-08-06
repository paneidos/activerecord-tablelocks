# Extends AR to add table locking
module ActiveRecord
  class Base
    class << self

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
  end
end