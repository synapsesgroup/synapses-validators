# -*- coding: utf-8 -*-
# Synapses Group

class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    record.errors.add attribute, :invalid unless Cpf.new(value).valid?
  end
end
