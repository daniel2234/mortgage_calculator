require 'yaml'
MESSAGES = YAML.load_file('loan_calculator_messages.yml')

def prompt(message)
  puts "==>#{message}"
end

def capitalize_full_name(name)
  name.split.map(&:capitalize).join(' ')
end

def integer?(number)
  number.to_i.to_s == number
end

def float?(number)
  number.to_f.to_s == number
end

def invalid_number?(number)
  integer?(number) || float?(number)
end

def monthly_interest_rate(interest_rate)
    number = (interest_rate.to_f / 100) / 12
    number.round(4)
end

def loan_duration_in_months(duration)
  duration = duration.to_i * 12
end

prompt(MESSAGES['welcome'])
name = ''

loop do
  name = gets.chomp
  if name.empty? || integer?(name)
    prompt(MESSAGES['valid_name'])
  else
    break
  end
end

loop do # main loop
  prompt(" #{capitalize_full_name(name)}." + MESSAGES['loan_description'])
  loan_amount = ''
  loop do
    prompt(MESSAGES['valid_loan'])
    loan_amount = gets.chomp

    if invalid_number?(loan_amount)
      break
    else
      prompt(MESSAGES['invalid_number'])
    end
  end
  annual_percentage_rate = ''
  loop do
    prompt(MESSAGES['valid_interest_rate'])
    annual_percentage_rate = gets.chomp

    if invalid_number?(annual_percentage_rate)
      break
    else
      prompt(MESSAGES['invalid_number'])
    end
  end

  loan_duration  = ''
  loop do
    prompt(MESSAGES['valid_loan_duration'])
    loan_duration = gets.chomp

    if invalid_number?(loan_duration)
      break
    else
      prompt(MESSAGES['invalid_number'])
    end
  end

  monthly_payment = loan_amount.to_i * (monthly_interest_rate(annual_percentage_rate) / (1 - (1 + monthly_interest_rate(annual_percentage_rate))**(-loan_duration_in_months(loan_duration))))

  puts "For a #{loan_amount} mortgage at #{annual_percentage_rate}.00%, #{loan_duration} years amortization, your monthly payment will be : #{monthly_payment.to_f.round(2)}"

  puts "Would you like another mortgage calculation? (Y)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
