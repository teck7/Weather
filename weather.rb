require 'date'
require 'terminal-table'
require 'colorize'

# I want to enter in the temperatures for every day in a week,
# and have them presented nicely in a table in both Celsius and Fahrenheit

# Add in fancy progress bar for user to visualise his/her input progress
class ProgressBar

  def initialize(title = "Progress", total = 7, increment = 1, progress = 0)
     @title = title
     @total = total
     @increment = increment
     @progress = progress
   end

   def increment()
     @progress = @progress + @increment
     output_progress()
   end

   def output_progress
     progress_bar_remaining = ("~~~" * (@total-@progress)).colorize(:red)
     progress_bar_completed = ("~~~" * @progress).colorize(:cyan)
     progress_bar_total =  progress_bar_completed + progress_bar_remaining
     puts "Your Input #{@title} (#{@progress}/#{@total}) #{progress_bar_total}"
     puts "\n"
   end

end

# An array of strings of abbreviated day names in English.
# The first is “Sun”.
abbr_daynames = Date::ABBR_DAYNAMES
# where ABBR_DAYNAMES = %w(Sun Mon Tue Wed Thu Fri Sat)
# where %w() is a short form for describing an array

# Temperature record array holder
@temperature_record = []

# Create new instance object for progress bar
progress = ProgressBar.new()

# Go through each day, and ask the user for
# the temperature on that day
abbr_daynames.each do |day_name|
  # Add in increments with each day
  progress.increment
  #Ask the user for temperature on the day for each day
  puts "Hi, what was the temperature on #{day_name} in Celcius?"
  # Ask for user input
  temp_in_celcius = gets.chomp
  @temperature_record.push({
    # Collect days as hash{key|value}
    day: day_name,

    # Collect user input in celcius as hash{key|value}
    celcius: temp_in_celcius,

    # Convert use input into fahrenheit as hash{key|value}
    fahrenheit: ((temp_in_celcius.to_i * 9) / 5) + 32
    })
end

# Present the days with temperature (in Celsius and Fahrenheit)
# alongside in a table
def print_temp_table()

  #Allocate an array holder to collect all relevant user input data
  rows = []

  # Allocate top row for heading
  rows << ["Day", "Cel.", "Fahr."]

  # Add in a line
  rows << :separator

  # Put all data into temp_data obtained via temperature record array holder
  @temperature_record.each do |temp_data|

    # Push all data into row array holder
    rows << [
      #  Define local variable for each array's key
      #  array[:id] is for accessing a value from a Hash
      #  by using :id as a key
      temp_data[:day],

      # Using temperature_as_color method to colorize data
      temperature_as_color(temp_data[:celcius], :celcius),
      temperature_as_color(temp_data[:fahrenheit], :fahrenheit)
    ]
  end

  table = Terminal::Table.new :title => "Melbourne Weekly Weather", :rows => rows
end

# Define a method to return coloured string depending on tempeature
# Set default temperature type :celcius
def temperature_as_color(temp_val, temp_unit)

  # Set variable for 1st argv i.e. temp_val
  temp = temp_val.to_i

  # colourize if id: is fahrenheit
  if temp_unit == :fahrenheit

    # 1st Nested IF statement
    if temp < 60
      return "#{temp}".colorize(:cyan)

    elsif temp > 84
      return "#{temp}".colorize( :background => :red)

    else
      return "#{temp}".on_blue.underline

    end # End of 1st Nested IF statement

  else temp_unit == :celcius

    # 2nd Nested IF statement
    # colourize if default id: is celsius
    if temp < 15
      return "#{temp}".colorize(:cyan)

    elsif temp > 29
      return "#{temp}".colorize( :background => :red)

    else
      return "#{temp}".on_blue.underline

    end # En of 2nd Nested IF statement

  end # End of IF Statement

end # End of temperature_as_color method

# Define a method to sort temperature ranking
def find_high_low_temperature()

  # Sort the array from highest to lowest
  # Use sort_by to sort values from low to high
  # Then use reverse to reverse the sorted values (i.e. gives high to low)
  #  array[:id] is for accessing a value from a Hash
  sorted_temperature_record = @temperature_record.sort_by{|k,v| k[:celcius]}.reverse

  # print highest by targeting index[0] from the array (i.e. first in array)
  puts " The hottest day this week is on #{sorted_temperature_record[0][:day]}\
 with a temperature of #{sorted_temperature_record[0][:celcius]}\
 degree celcius."

  # print lowest by targeting index[-1] from the array (i.e. last in array)
  puts " The coldest day this week is on #{sorted_temperature_record[-1][:day]}\
 with a temperature of #{sorted_temperature_record[-1][:celcius]}\
 degree celcius."

end

# Additional method to clear console
def clearConsole()
    system "clear" or system "cls"
end

clearConsole()
puts print_temp_table()
puts find_high_low_temperature()
