
require 'terminal-table'

module Bixby
  module RailsExt
    module ConsoleTable

      def self.to_table(rows, columns)
        table = Terminal::Table.new do |t|
          t.headings = columns.map{ |c| c.name }
          rows.each do |row|
            t << columns.map { |c| row.send(c.name.to_sym) }
          end
        end
        puts table
      end

      module Relation
        # Dump all objects in this relation as a table
        def to_table
          ConsoleTable.to_table(self.to_a, self.columns)
        end
      end # Relation

      module Base
        module ClassMethods
          # Dump the table description
          def describe
            table = Terminal::Table.new do |t|

              t.title = self.name
              t.headings = %w{Column Type SQL}

              self.columns.each { |c|
                type = [ "type=%s" % c.type ]
                type << ("limit=%s" % c.limit) if c.limit
                type << ("precision=%s" % c.precision) if c.precision
                type << ("null=%s" % c.null) if c.null
                t <<  [ c.name, type.join(", "), c.sql_type ]
              }
            end
            puts table

            assoc = self.reflections.values.map do |ref|
              "#{ref.name} (#{ref.macro})"
            end

            puts
            puts "Associations: #{assoc.join(', ')}"
            puts

          end
        end

        module InstanceMethods
          # Dump this single object as a table
          def to_table
            ConsoleTable.to_table([self], self.class.columns)
          end

          def describe
            self.class.describe
          end
        end
      end #  Base

    end
  end
end

module ActiveRecord
  class Relation
    include Bixby::RailsExt::ConsoleTable::Relation
  end
  class Base
    include Bixby::RailsExt::ConsoleTable::Base::InstanceMethods
    extend Bixby::RailsExt::ConsoleTable::Base::ClassMethods
  end
end
