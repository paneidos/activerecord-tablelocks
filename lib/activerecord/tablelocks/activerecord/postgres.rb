module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      def lock_table(quoted_table_name)
        execute "LOCK TABLE #{quoted_table_name} IN EXCLUSIVE MODE"
      end
      def lock_tables(quoted_table_names)
        quoted_table_names.each do |quoted_table_name|
          lock_table quoted_table_name
        end
      end
    end
  end
end