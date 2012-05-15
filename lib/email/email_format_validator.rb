# -*- coding: utf-8 -*-
# Synapses Group

class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless EmailFormatValidator::validate_email(value)
      object.errors.add attribute, :not_formatted
    end
  end

  def self.validate_email(email)
    email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end


