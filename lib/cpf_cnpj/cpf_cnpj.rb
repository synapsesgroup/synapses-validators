# -*- encoding : utf-8 -*-
# Synapses Group

module CpfCnpj

  attr_reader :number

  def initialize(number)
    @number = number
    @match = self.instance_of?(Cpf) ? @number =~ CPF_REGEX : @number =~ CNPJ_REGEX
    @plain_number = $1
    @verification_number = $2
    @number = (@match ? format_number! : nil)
  end

  def to_s
    @number || ""
  end

  def ==(value)
    self.number == value.number
  end

  def valid?
    return false unless @match
    verify_number
  end

  private
  DIVISOR = 11

  CPF_LENGTH = 11
  CPF_REGEX = /^(\d{3}\.?\d{3}\.?\d{3})-?(\d{2})$/
  CPF_ALGS_1 = [10, 9, 8, 7, 6, 5, 4, 3, 2]
  CPF_ALGS_2 = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]

  CNPJ_LENGTH = 14
  CNPJ_REGEX = /^(\d{2}\.?\d{3}\.?\d{3}\/?\d{4})-?(\d{2})$/ # <= 11.222.333/0001-XX
  CNPJ_ALGS_1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
  CNPJ_ALGS_2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]


  def verify_number
    unmasked_number = @number.gsub(/[\.\/-]/, "")
    if self.instance_of? Cpf
      return false if unmasked_number.length != 11
    elsif self.instance_of? Cnpj
      return false if unmasked_number.length != 14
    end
    return false if unmasked_number.scan(/\d/).uniq.length == 1
    first_digit = first_verification_digit
    second_digit = second_verification_digit(first_digit)
    verif = first_digit + second_digit
    verif == @verification_number
  end

  def multiply_and_sum(algs, number_str)
    multiplied = []
    number_str.scan(/\d{1}/).each_with_index { |e, i| multiplied[i] = e.to_i * algs[i] }
    multiplied.inject { |s,e| s + e }
  end

  def verification_digit(rest)
    rest < 2 ? 0 : DIVISOR - rest
  end

  def first_verification_digit
    array = self.instance_of?(Cpf) ? CPF_ALGS_1 : CNPJ_ALGS_1
    sum = multiply_and_sum(array, @plain_number)
    verification_digit(sum%DIVISOR).to_s
  end

  def second_verification_digit(first_digit)
    array = self.instance_of?(Cpf) ? CPF_ALGS_2 : CNPJ_ALGS_2
    sum = multiply_and_sum(array, @plain_number + first_digit)
    verification_digit(sum%DIVISOR).to_s
  end

  def format_number!
    if self.instance_of? Cpf
      @number =~ /(\d{3})\.?(\d{3})\.?(\d{3})-?(\d{2})/
      @number = "#{$1}.#{$2}.#{$3}-#{$4}"
    else
      @number =~ /(\d{2})\.?(\d{3})\.?(\d{3})\/?(\d{4})-?(\d{2})/
      @number = "#{$1}.#{$2}.#{$3}/#{$4}-#{$5}"
    end
  end

end