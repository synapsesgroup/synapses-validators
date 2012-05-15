# -*- encoding : utf-8 -*-
# Synapses Group

module CpfCnpjActiveRecord
  def self.included(base)
    base.extend ClassMethods
  end
  module ClassMethods
    def act_as_cpf(*args)
      init(args, 'Cpf')
    end

    def act_as_cnpj(*args)
      init(args, 'Cnpj')
    end

    def init(args, klass)
      unless args.size.zero?
        args.each do |name|
          add_composed_class(name, klass)
          module_eval create_code(name.to_s, klass)
        end
      end
    end

    def add_composed_class(name, klass)
      options = {:class_name => klass, :mapping => [name.to_s, "number"], :allow_nil => true}
      constructor = Proc.new { |number| eval(klass).new(number) }
      converter   = Proc.new { |value| eval(klass).new(value) }
      begin
        composed_of name, options.merge( { :constructor => constructor, :converter => converter } )
      rescue Exception
        composed_of name, options { eval(klass).new(name[:number]) }
      end
    end

    def create_code(name, klass)
      str = <<-CODE
        validate :#{name}_valid?
        def #{name}_valid?
          value = read_attribute('#{name}')
          if !value.nil? && value.strip != '' && !#{name}.nil? && !#{name}.valid?
            self.errors.add('#{name}', :invalid)
          end
        end
        def #{name}=(value)
          if value.blank?
            write_attribute('#{name}', nil)
          elsif value.kind_of?(#{eval(klass)})
            write_attribute('#{name}', value.number)
          else
            begin
              c = #{eval(klass)}.new(value)
              c.valid? ? write_attribute('#{name}', c.number) : write_attribute('#{name}', value)
            rescue
              @#{name} = value
            end
          end
        end
      CODE
    end
  end
end