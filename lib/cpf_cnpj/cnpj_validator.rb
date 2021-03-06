# -*- coding: utf-8 -*-
# Synapses Group

class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    record.errors.add attribute, :invalid unless Cnpj.new(value).valid?
  end
end
