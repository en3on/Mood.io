module Animation
  def self.welcome_screen()
    puts `clear`
    puts
    puts ("                           _   _____ ____  ".colorize(:light_cyan))
    sleep 0.2
    puts ("                          | | |_   _/ __ \\ ".colorize(:light_cyan))
    sleep 0.2
    puts (" _ __ ___   ___   ___   __| |   | || |  | |".colorize(:light_cyan))
    sleep 0.2
    puts ("| '_ ` _ \\ / _ \\ / _ \\ / _` |   | || |  | |".colorize(:light_cyan))
    sleep 0.2
    puts ("| | | | | | (_) | (_) | (_| |_ _| || |__| |".colorize(:light_cyan)) 
    sleep 0.2
    puts ("|_| |_| |_|\\___/ \\___/ \\__,_(_)_____\\____/ ".colorize(:light_cyan))
    sleep 0.2
    2.times { puts } 
    sleep 0.5
    welcome_function()
    2.times { puts }
    sleep 1.5
    display_title_options
    puts
    sleep 1
  end

  def self.welcome_function()
    message = "Welcome to mood.IO by Adam Ladell and David Bui"

    words = message.split(' ')

    # Go through each letter and print/ colorize it according to the rules for the overall word
    words.each { |word|
      letters = word.split('')
      
      letters.each { |letter|
        print(letter.colorize(
          case word
          when "Welcome"
            :red
          when "mood.IO"
            :light_cyan
          when "Adam"
            :light_magenta
          when "Ladell"
            :light_magenta
          when "David"
            :blue
          when "Bui"
            :blue
          else
            :default
          end
        ))
        sleep 0.01
      }
      print ' '
    }

  end

  def self.display_title_options()
    options = ["Press 1 to Log In", "Press 2 to Sign Up", "Press 3 to Exit"]

    words = []

    # Go through each letter and print/ colorize it according to the rules for the overall word
    options.each_with_index { |option|
      words << option.split(' ')
    }

      words.each { |word_arr|
        word_arr.each { |word|
          letters = word.split('')
          letters.each { |letter|
            print(letter.colorize(
              case word
              when "Press"
                :red
              when "1"
                :light_green
              when "2"
                :light_green
              when "3"
                :light_green
              when "Log"
                :light_cyan
              when "In"
                :light_cyan
              when "Sign"
                :light_cyan
              when "Up"
                :light_cyan
              when "Exit"
                :light_cyan
              else
                :default
              end
            ))
            sleep 0.01
          }
          sleep 0.02
          print(' ')
        }
        puts
      }
          
  end

  # Shutdown the program using a cool looking animation!
  def self.shutdown
    puts `clear`
    puts("Thanks for using".colorize(:red))
    puts ("                           _   _____ ____  ".colorize(:light_cyan))
    sleep 0.2
    puts ("                          | | |_   _/ __ \\ ".colorize(:light_cyan))
    sleep 0.2
    puts (" _ __ ___   ___   ___   __| |   | || |  | |".colorize(:light_cyan))
    sleep 0.2
    puts ("| '_ ` _ \\ / _ \\ / _ \\ / _` |   | || |  | |".colorize(:light_cyan))
    sleep 0.2
    puts ("| | | | | | (_) | (_) | (_| |_ _| || |__| |".colorize(:light_cyan)) 
    sleep 0.2
    puts ("|_| |_| |_|\\___/ \\___/ \\__,_(_)_____\\____/ ".colorize(:light_cyan))
    puts
    puts
    sleep 0.2
    puts(" _")
    sleep 0.2
    puts("|_)")
    sleep 0.2
    puts("|_)\\/")
    sleep 0.2
    puts("   /")
    sleep 0.2
    puts()
    sleep 0.2
    puts()
    sleep 0.2
    puts(" /\\ _| _.._ _  |  _. _| _ ||".colorize(:light_magenta))
    sleep 0.2
    puts("/--\(_|(_|| | | |_(_|(_|(/_||".colorize(:light_magenta))
    sleep 0.2
    puts
    sleep 0.2
    puts(" _            _".colorize(:blue))
    sleep 0.2
    puts("| \\ _.  o _| |_)   o".colorize(:blue))
    sleep 0.2
    puts("|_/(_|\\/|(_| |_)|_||".colorize(:blue))
    sleep 0.5
    puts
    exit
  end
end
