# Synapses Validators

## Authors

* Tiago Machado (tiago@synapses.com.br)
* João Lucas (joaolucas@synapses.com.br)

Based on Brazilian Rails (https://github.com/tapajos/brazilian-rails)

## How to use

Include "synapses-validators" in yor gemfile.

```ruby
gem 'synapses-validators'
```

Go to your models, and set your validators.

### CPF

```ruby
validates :cpf, :presence => true, :uniqueness => true, :cpf => true, :if => :is_person_br?
```

Or

```ruby
act_as_cpf :cpf
```

### CNPJ

```ruby
validates :cnpj, :presence => true, :uniqueness => true, :cnpj => true, :if => :is_business_br?
```

Or

```ruby
act_as_cnpj :cpf
```

### Email

```ruby
  validates :email,
            :presence => true,
            :uniqueness => true,
            :length => {:within => 5..50},
            :email_format => true
```


### I18n

The error messages is localized. So, you must have this lines in your locale files:

```ruby
  activerecord:
    errors:
      messages:
        invalid: inválido
        not_formatted: não está no formato correto
```

### TODO

* Implement tests.


## License

Synapses Validators is licensed for use under the terms of the MIT License.