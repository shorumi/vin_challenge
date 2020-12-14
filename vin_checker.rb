# frozen_string_literal: true

class VinValidation
  TRANSLITERATE_CHARS = '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'

  def initialize(vin)
    @vin = vin
  end

  def call
    valid_vin?
  end

  private

  attr_reader :vin

  def valid_vin?
    return VinMessages.vin_size_error_msg(vin) unless vin.size == 17

    if calculate_check_digit_to_s == vin[8]
      VinMessages.valid_vin_msg(vin)
    else
      VinMessages.invalid_vin_msg(vin, calculate_check_digit)
    end
  end

  def calculate_check_digit_to_s
    calculate_check_digit.to_s
  end

  def calculate_check_digit
    map = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'X']
    weights = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]
    sum = 0
    invalid_characters_hash = {}

    vin.split('').each_with_index do |char, i|
      begin
        sum += transliterate(char) * weights[i]
      rescue NoMethodError
        invalid_characters_hash.merge!(invalid_chars?(char))
        next
      end
    end

    return invalid_characters_hash unless invalid_characters_hash.empty?

    map[sum % 11]
  end

  def transliterate(char)
    TRANSLITERATE_CHARS.split('').index(char) % 10
  end

  def invalid_chars?(char)
    return if TRANSLITERATE_CHARS.include?(char)

    invalid_chars = {}
    key = vin.index(char)

    invalid_chars[key + 1] = char
    invalid_chars
  end
end

class VinMessages
  class << self
    CHANGE_INVALID_VIN_CHARATER_DIC = { 'I' => '1', 'O' => '0', 'Q' => '9' }.freeze

    def valid_vin_msg(vin)
      puts "Provided VIN: #{vin}\n" \
      "Check Digit: VALID\n" \
      'This looks like a VALID VIN!'
    end

    def suggest_possible_valid_vin(vin)
      vin.gsub(/[IOQ]/, CHANGE_INVALID_VIN_CHARATER_DIC)
    end

    def invalid_vin_msg(vin, invalid_characters_hash)
      return invalid_check_digit_msg(vin, invalid_characters_hash) unless invalid_characters_hash.is_a?(Hash)

      suggested_vin = suggest_possible_valid_vin(vin)

      puts "Provided VIN: #{vin}\n" \
      "Check Digit: INVALID\n" \
      "Suggested VIN(s):\n" \
      "* #{suggested_vin}\n"
      vin_invalid_characters(invalid_characters_hash)
    end

    def vin_size_error_msg(vin)
      puts "Provided VIN: #{vin}\n" \
      "Invalid VIN size, current size: #{vin.size}, it should has 17 digits"
    end

    def invalid_check_digit_msg(vin, calculate_check_digit_to_s)
      puts "Provided VIN: #{vin}\n" \
      "Invalid VIN check digit, current check digit: #{vin[8]}, expected check digit #{calculate_check_digit_to_s}"
    end

    def vin_invalid_characters(invalid_characters_hash)
      puts 'Invalid character(s):'
      invalid_characters_hash.each_pair { |key, value| puts "* Position: #{key} value is #{value}" }
    end
  end
end

if ARGV.empty?
  puts 'Please, provide a VIN as a script argument'
  exit
end

vin_input = ARGV[0]

VinValidation.new(vin_input).call

# Valid VINs for testing
# 2NKWL00X16M149834
# 1XPBDP9X1FD257820
# 1XKYDPPX4MJ442156
# 3HSDJAPRSFN657165
# JBDCUB16657005393
# With X as check digit
# 1M8GDM9AXKP042788

# Invalid VINs
# INKDLUOX33R385016
# 1M8GDM9A0KP042788
