require 'csv'
require 'pry'
require 'date'
require 'digest'
require 'colorize'

require './database/account_class'

class Journal
  attr_accessor(:journal_entries_arr, :mood_list, :current_account)
  def initialize
    @journal_entries_arr = []
    @mood_list = []
    @current_account = nil
  end
  
  def title
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
    puts
    puts
    sleep 0.5
    welcome_function()
    puts
    puts 
    sleep 1.5
    display_title_options
    puts
    sleep 1

    while true 
      print("Selection: ")
      input = gets.strip

      case input
      when "1"
        log_in_screen
      when "2"
        register_screen
      when "3"
        shutdown()
      else
        puts("Please enter a valid option!".colorize(:red))
      end
    end
  end
  
  def log_in_screen()
    while true
      puts `clear`
      lineWidth = 100
      puts
      puts ("mood.IO".center(lineWidth))
      puts
      print ("Username: ".colorize(:light_cyan))
      username = gets().strip
      puts
      print ("Password: ".colorize(:light_cyan))
      password = gets().strip
      puts

      if File.exists?("database/journals/#{username}.csv")
        correct_password = File.read("database/passwords/#{username}.txt")
        if Digest::SHA2.hexdigest(password) == correct_password
          @current_account = username
          puts("Welcome,".colorize(:red) + " #{username}!".colorize(:light_cyan))
          read_journal_entries_to_array
          read_mood_list_from_file
          main_menu
        end
      end
      puts("Incorrect username or password!".colorize(:red))
      sleep 2
    end
  end

def register_screen()
  lineWidth = 150
  puts `clear`
  puts
  puts ("mood.IO".colorize(:light_cyan).center(lineWidth))
  puts
  while true
    print("Enter username: ")
    username = gets.strip
    puts
    print("Enter password: ")
    password = gets.strip
    puts
    print("Enter password again: ")
    password_again = gets.strip
    puts

    if password == password_again
      if File.exists?("database/journals/#{username}.csv")
        puts("Username is taken!".colorize(:red))
      else

        File.new("database/journals/#{username}.csv"   , "w")
        File.new("database/passwords/#{username}.txt"  , "w")
        File.new("database/moods/#{username}.txt"      , "w")
        File.open("database/passwords/#{username}.txt" , "w") do |file|
          file.print(Digest::SHA2.hexdigest(password))
        end

        puts("Account Created!")
        sleep 2
        title
      end
    else
      puts("Passwords don't match!")
    end
  end
end

  def main_menu
    input = ""
    while input != "7" 
      puts `clear`
      puts("Welcome".colorize(:red) + " to " + "mood.IO".colorize(:light_cyan))
      puts("Please select an option: ")
      puts

      puts("[1]".colorize(:light_cyan) + " Add Journal Entry")
      puts("[2]".colorize(:light_cyan) + " View Journal Entries")
      puts("[3]".colorize(:light_cyan) + " Delete Journal Entry")
      puts("[4]".colorize(:light_cyan) + " Add or Delete Moods")
      puts("[5]".colorize(:light_cyan) + " Show the most used moods")
      puts("[6]".colorize(:light_cyan) + " Filter entries by mood")
      puts("[7]".colorize(:light_cyan) + " Exit")
      puts

      input = gets.strip

      case input
      when "1"
        if @mood_list.length > 0
          # Open interface to allow user to input journal entry and save entry to a var 'journal'
          journal = get_journal_entry(@mood_list)
          # Add the journal var to the journal_entries_array that was definied in 'initialize'
          add_journal_entry_to_arr(journal)
          # Write the entire journal_entries_arr to disk
          save_journal_entries_arr_to_disk()
        else
          puts("There are no moods! Please add some custom moods...".colorize(:red))
          sleep 2
        end
      when "2"
        # If there are no journal entries, display an error
        if @journal_entries_arr.length > 0
          # Present user with a menu to view all titles of entries. User can then select an entry to view
          input = display_list_of_entries(@journal_entries_arr)
          # Display content of selected entry
          show_content_of_entry(input, @journal_entries_arr) if input != nil
        else
          puts("There are no entries!".colorize(:red))
          sleep 1
        end
      when "3"
        # Display journal entry titles to user and allow them to delete a specific entry
        remove_journal_entry()
      when "4"
        custom_mood()
      when "5"
        get_most_used_moods() 
        puts("Press enter to return...")
        gets
      when "6"
        filter_entries_by_mood()
      when "7"
        shutdown()
      else
        puts("Please enter a valid option!")
        sleep 1
      end
    end
  end

  def get_journal_entry(mood_list)
    puts `clear`
    puts("NEW JOURNAL ENTRY")
    puts
    puts
    # Get title for journal entry
    print("Title: ")
    title = gets.strip()

    puts()
    puts("Journal Entry: (Type EXIT on a new line, to finish entry)")
    puts

    input = ''

    lines = []

    # Let user enter a multiline journal entry and store each line to an array 'lines'
    # If user enters the word EXIT on a new line, the while loop is exited
    while input != "EXIT"
      input = gets.strip
      lines << input
    end

    puts

    # Dispaly list of moods for the user to choose from for the entry
    view_mood_list(mood_list)
    puts

    # Remove the 'EXIT' line from the array
    lines.pop

    # For each line, remove any commas found
    lines.each { |line|
      line.tr!(',', '')
    }
    
    valid_input = false
    while !valid_input
      print("Choose a mood for this entry (Enter mood number): ")
      input = gets.strip()

      if input.count('0-9') == input.length
        if input.to_i <= mood_list.length && input.to_i > 0
          mood = mood_list[input.to_i - 1]
          break
        end
      end

      puts("Please enter a valid number!")
      puts
      view_mood_list(mood_list)
    end
    
    today = Time.now

    hour = today.hour
    minute = today.min
    day = today.day
    month = today.month

    return {
      title: title,
      content: lines,
      mood: mood,
      date: "#{day}/#{month} @ #{hour}:#{minute}"
    }

  end


  def add_journal_entry_to_arr(journal_entry)
    content = journal_entry[:content].join(';')
    csv_text = "title,content,mood,date\n#{journal_entry[:title]},#{content},#{journal_entry[:mood]},#{journal_entry[:date]}"
    csv_entry = CSV.parse(csv_text, :headers => true)

    csv_entry.each { |row|
      @journal_entries_arr << row.to_hash
    }
  end

  def custom_mood()
    puts `clear`
    view_mood_list(@mood_list)
    puts
    valid_inputs = ["1", "2", "3"] 

    puts("[1] Add Mood")
    puts("[2] Delete Mood")
    puts("[3] Return to Main Menu")
    puts

    user_input = gets.strip

    while !valid_inputs.include?(user_input)
      puts("Please enter a valid number!")
      user_input = gets.strip
    end

    case user_input
    when "1"
      puts `clear`
      puts "Type your mood:"
      puts
      mood_input = gets().strip

      !@mood_list.include?(mood_input.capitalize) ? @mood_list << mood_input.capitalize : (puts("That mood already exists!")
                                                                                           sleep 2
                                                                                          )
    when "2"
      puts `clear`
      view_mood_list(@mood_list)
      puts
      puts "Type a mood that you want to delete:"
      puts

      valid_input = false

      while !valid_input
        delete_mood_input = gets().strip
        if delete_mood_input.count('0-9') == delete_mood_input.length
          if delete_mood_input.to_i <= @mood_list.length
            @mood_list.delete_at(delete_mood_input.to_i - 1)
            break
          end
        end

        puts("Please enter a valid number!")

      end

    when "3" 
      return
    end

    write_mood_list_to_file
  end

  def save_journal_entries_arr_to_disk()
    File.open("database/journals/#{@current_account}.csv", "w") do |file|
      file.puts("title,content,mood,date")
      @journal_entries_arr.each { |journal|
        file.puts(journal)
      }
    end

  end

  def read_journal_entries_to_array()
    @journal_entries_arr = []

    File.open("database/journals/#{@current_account}.csv").each_with_index { |row, index|
      if index != 0
        @journal_entries_arr << eval(row) 
      end
    }
  end

  def display_list_of_entries(journal_entries_arr)
    puts `clear`
    journal_entries_arr.each_with_index { |journal, index|
      puts("#{index + 1}. #{journal['title']}         #{journal['date']}")
    }
    puts
    puts("Type EXIT to return to main menu")
    print("Please enter the number of the journal entry you would like to view: ")
    while true
      input = gets.strip

      if input.count('0-9') == input.length
        if input.to_i <= journal_entries_arr.length
          return input.to_i
        end
      elsif input.upcase == "EXIT"
        return
      end

      puts("Please enter a valid number!")
    end
  end

  def show_content_of_entry(user_selection, journal_entries_arr)
    journal = journal_entries_arr[user_selection - 1]

    lines = journal['content'].split(';')

    puts `clear`
    puts journal['title']
    puts

    lines.each { |line|
      puts line
    }

    puts
    puts
    puts("Mood: #{journal['mood']}")
    puts
    puts "Press enter to return to main menu..."
    gets
  end


  def view_mood_list(mood_list_arr)
      mood_list_arr.each_with_index do |moodli, index|
          puts "#{index + 1}: #{moodli}"
      end
  end

  def write_mood_list_to_file()
    File.open("database/moods/#{@current_account}.txt", "w") do |file|
      @mood_list.each { |mood|
        file.puts(mood.strip)
      }
    end 
  end

  def read_mood_list_from_file()
    @mood_list = []
    
    file = File.open("database/moods/#{@current_account}.txt", "r")
    file.each_line { |line|
      @mood_list << line.strip
    }

    file.close

  end

  def get_most_used_moods()
    mood_hash = {}

    puts `clear`

    @journal_entries_arr.each { |journal|
      if mood_hash[journal['mood']] == nil
        mood_hash[journal['mood']] = 1
      else
        mood_hash[journal['mood']] += 1
      end
    }

    sorted_mood_hash = mood_hash.sort_by { |mood, count| count}.reverse

    sorted_mood_hash.each { |mood, count|
      puts("#{mood}: #{count}")
    }
  end

  def remove_journal_entry()
    puts `clear`

    @journal_entries_arr.each_with_index { |journal, index|
      puts("#{index + 1}. #{journal['title']}      @ #{journal['date']}")
    }

    puts()

    valid_input = false
    while true
      puts("Type EXIT to return to main menu")
      print("Enter number of entry to remove: ")
      entry_to_delete = gets.strip
      if entry_to_delete.count('0-9') == entry_to_delete.length
        if entry_to_delete.to_i <= @journal_entries_arr.length
          break
        end
      elsif entry_to_delete.upcase == "EXIT"
        return
      end

      puts("Please enter a valid number!")

    end

    @journal_entries_arr.delete_at(entry_to_delete.to_i - 1)

    save_journal_entries_arr_to_disk

  end

  def filter_entries_by_mood()
    puts `clear`

    mood_list = []

    @journal_entries_arr.each { |journal|
      mood_list << journal['mood'] if !mood_list.include?(journal['mood'])
    }

    view_mood_list(mood_list)
    puts
    print("Select the mood you'd like to filter (Type EXIT to return): ")
    input = gets.strip

    valid_input = false



    while !valid_input
      if input.count('0-9') == input.length
        if input.to_i <= mood_list.length
          selected_mood = mood_list[input.to_i - 1]
          break
        end
      elsif input.upcase == "EXIT"
        return
      end
      
      puts("Please enter a valid mood!")
      print("Select the mood you'd like to filter (Type EXIT to return): ")
      input = gets.strip
    end

    filtered_array = []

    @journal_entries_arr.each { |journal|
      filtered_array << journal if journal['mood'] == selected_mood
    }

    selected_entry = display_list_of_entries(filtered_array)
    show_content_of_entry(selected_entry, filtered_array) if selected_entry != nil
  end

  def shutdown
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

  def welcome_function()
    message = "Welcome to mood.IO by Adam Ladell and David Bui"

    words = message.split(' ')

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

end

def display_title_options()
  options = ["Press 1 to Log In", "Press 2 to Sign Up", "Press 3 to Exit"]

  words = []

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



def main()

  journal_app = Journal.new

  journal_app.title()

  journal_app.read_mood_list_from_file()

  journal_app.read_journal_entries_to_array

  journal_app.main_menu()

end


main()

