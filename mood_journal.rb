require 'csv'
require 'pry'
require 'date'
require 'digest'
require 'colorize'

require './database/account_class'
require './lib/animations'

class Journal

  attr_accessor(:journal_entries_arr, :mood_list, :current_account)
  def initialize
    @journal_entries_arr = []
    @mood_list = []
    @current_account = nil
  end

  def title
    Animation::welcome_screen()

    while true 
      print("Selection: ")
      input = gets.strip

      case input
      when "1"
        log_in_screen
      when "2"
        register_screen
      when "3"
        Animation::shutdown()
      else
        puts("Please enter a valid option!".colorize(:red))
      end
    end
  end

  
  def log_in_screen()
    while true
      puts `clear`
      puts
      puts ("mood.IO".center(150))
      puts("Type EXIT to return to previous menu")
      puts
      print ("Username: ".colorize(:light_cyan))
      username = gets().strip
      title if username.upcase == "EXIT"
      puts
      print ("Password: ".colorize(:light_cyan))
      password = gets().strip
      puts


      # Check if user account exists 
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
    while true
      puts `clear`
      puts ("mood.IO".colorize(:light_cyan).center(150))
      puts
      puts("Type EXIT to return to previous menu")
      puts
      print("Enter username: ")
      username = gets.strip
      title if username.upcase == "EXIT"
      puts
      print("Enter password: ")
      password = gets.strip
      puts
      print("Enter password again: ")
      password_again = gets.strip
      puts

      # Check if the passwords match
      if password == password_again
        # Check if a user with chosen username exists
        if File.exists?("database/journals/#{username}.csv")
          puts("Username is taken!".colorize(:red))
          sleep 1.2
        else

          # Create user files

          File.new("database/journals/#{username}.csv"   , "w")
          File.new("database/passwords/#{username}.txt"  , "w")
          File.new("database/moods/#{username}.txt"      , "w")
          File.open("database/passwords/#{username}.txt" , "w") do |file|
            file.print(Digest::SHA2.hexdigest(password))
          end

          puts("Account Created!".colorize(:light_cyan))
          sleep 2
          @current_account = username
          main_menu
        end
      else
        puts("Passwords don't match!".colorize(:red))
        sleep 1.2
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

      options = ["Add Journal Entry", "View Journal Entries", "Delete Journal Entry", "Add or Delete Moods", "Show the Most Used Moods", "Filter Entries by Mood", "Exit"]

      # display options menu
      options.each_with_index { |option, index|
        puts("[#{index + 1}]".colorize(:light_cyan) + " #{option}")
      }
      puts

      input = gets.strip

      no_entries_error = "You don't have any journal entries!".colorize(:red)

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
          puts no_entries_error
          sleep 1
        end
      when "3"
        # Display journal entry titles to user and allow them to delete a specific entry
        if @journal_entries_arr.length > 0
          remove_journal_entry()
        else
          puts no_entries_error
          sleep 1
        end
      when "4"
        # Allow user to create / delete moods
        custom_mood()
      when "5"
        # Allow user to see the most used moods
        if @journal_entries_arr.length > 0
          get_most_used_moods() 
          puts("Press enter to return...".colorize(:light_cyan))
          gets
        else
          puts no_entries_error
          sleep 1
        end
      when "6"
        # Display journal entries with a certain mood
        if @journal_entries_arr.length > 0 
          filter_entries_by_mood()
        else
          puts no_entries_error
          sleep 1
        end
      when "7"
        # Close the app
        Animation::shutdown()
      else
        puts("Please enter a valid option!".colorize(:red))
        sleep 1
      end
    end
  end

  def get_journal_entry(mood_list)
    puts `clear`
    puts("NEW JOURNAL ENTRY".colorize(:light_cyan))
    2.times { puts }
    # Get title for journal entry
    print("Title: ".colorize(:light_magenta))
    title = gets.strip()

    puts()
    puts("Journal Entry:".colorize(:light_cyan) + " (Type EXIT on a new line, to finish entry)".colorize(:red))
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
      print("Choose a mood for this entry".colorize(:light_cyan) + " (Enter mood number): ".colorize(:red))
      input = gets.strip()

      # If the input does not include numbers, or the number is not on the list, inform user and check again
      if input.count('0-9') == input.length
        if input.to_i <= mood_list.length && input.to_i > 0
          mood = mood_list[input.to_i - 1]
          break
        end
      end

      puts("Please enter a valid number!".colorize(:red))
      puts
      view_mood_list(mood_list)
    end

    # Get the date and time for the current entry
    
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

  # Add the journal entry specified to the class's local journal storage

  def add_journal_entry_to_arr(journal_entry)
    content = journal_entry[:content].join(';')
    csv_text = "title,content,mood,date\n#{journal_entry[:title]},#{content},#{journal_entry[:mood]},#{journal_entry[:date]}"
    csv_entry = CSV.parse(csv_text, :headers => true)

    csv_entry.each { |row|
      @journal_entries_arr << row.to_hash
    }
  end

  def custom_mood()
    while true
      puts `clear`
      view_mood_list(@mood_list)
      puts
      valid_inputs = []

      options = ["Add Mood", "Delete Mood", "Return"]

      options.each_with_index { |option, index|
        puts("[#{index + 1}]".colorize(:light_cyan) + " #{option}")
        valid_inputs << (index + 1).to_s
      }
      puts

      user_input = gets.strip


      # If the user's input is within the valid input list, then run a case statement to execute an option
      while !valid_inputs.include?(user_input)
        puts("Please enter a valid number!".colorize(:red))
        user_input = gets.strip
      end

      case user_input
      when "1"
        puts `clear`
        puts "Type your mood:".colorize(:light_cyan)
        puts
        mood_input = gets().strip

        !@mood_list.include?(mood_input.capitalize) ? @mood_list << mood_input.capitalize : (puts("That mood already exists!".colorize(:red))
                                                                                             sleep 2
                                                                                            )
      when "2"
        puts `clear`
        view_mood_list(@mood_list)
        puts
        puts "Type a mood that you want to delete:".colorize(:light_cyan)
        puts

        valid_input = false

        while !valid_input
          delete_mood_input = gets().strip
          if delete_mood_input.count('0-9') == delete_mood_input.length && delete_mood_input != "0"
            if delete_mood_input.to_i <= @mood_list.length
              @mood_list.delete_at(delete_mood_input.to_i - 1)
              break
            end
          end

          puts("Please enter a valid number!".colorize(:red))

        end

      when "3" 
        return
      end

      write_mood_list_to_file
    end
  end

  # Save the local journal storage to the file associated with the account
  def save_journal_entries_arr_to_disk()
    File.open("database/journals/#{@current_account}.csv", "w") do |file|
      file.puts("title,content,mood,date")
      @journal_entries_arr.each { |journal|
        file.puts(journal)
      }
    end

  end

  # Read the journal entries for the specified user into the local journal storage
  def read_journal_entries_to_array()
    @journal_entries_arr = []

    File.open("database/journals/#{@current_account}.csv").each_with_index { |row, index|
      if index != 0
        @journal_entries_arr << eval(row) 
      end
    }
  end

  # Display the list of journal entries stored in the local journal storage (class array)
  def display_list_of_entries(journal_entries_arr)
    puts `clear`
    journal_entries_arr.each_with_index { |journal, index|
      puts("#{index + 1}.".colorize(:light_cyan) + " #{journal['title']}" + " " * 20 + "#{journal['date']}".colorize(:light_magenta))
    }
    puts
    puts("Type EXIT to return to main menu".colorize(:red))
    print("Please enter the number of the journal entry you would like to view: ".colorize(:light_cyan))
    while true
      input = gets.strip

      if input.count('0-9') == input.length
        if input.to_i <= journal_entries_arr.length
          return input.to_i
        end
      elsif input.upcase == "EXIT"
        return
      end

      puts("Please enter a valid number!".colorize(:red))
    end
  end

  # Display the content of the specified journal entry
  def show_content_of_entry(user_selection, journal_entries_arr)
    journal = journal_entries_arr[user_selection - 1]

    lines = journal['content'].split(';')

    puts `clear`
    puts journal['title'].colorize(:light_cyan)
    puts

    lines.each { |line|
      puts line
    }

    2.times { puts } 
    puts("Mood: " + "#{journal['mood']}".colorize(:light_magenta))
    puts
    puts "Press enter to return to main menu...".colorize(:red)
    gets
  end


  def view_mood_list(mood_list_arr)
      mood_list_arr.each_with_index do |moodli, index|
          puts "#{index + 1}: #{moodli}"
      end
  end

  # Write the mood list for the user to their user moods file
  def write_mood_list_to_file()
    File.open("database/moods/#{@current_account}.txt", "w") do |file|
      @mood_list.each { |mood|
        file.puts(mood.strip)
      }
    end 
  end

  # Read the mood list under the user's username
  def read_mood_list_from_file()
    @mood_list = []
    
    File.open("database/moods/#{@current_account}.txt", "r").each_line { |line|
      @mood_list << line
    }
    

  end

  # Count the amount of times a mood was used by incrementing the moods value in a hash
  def get_most_used_moods()
    mood_hash = {}

    puts `clear`

    @journal_entries_arr.each { |journal|
      mood_hash[journal['mood']] == nil ? mood_hash[journal['mood']] = 1 : mood_hash[journal['mood']] += 1
    }

    mood_hash.sort_by { |mood, count| count}.reverse.each { |mood, count|
      puts("#{mood}: #{count}")
    }
  end

  # remove specified journal entry from list
  def remove_journal_entry()
    puts `clear`

    @journal_entries_arr.each_with_index { |journal, index|
      puts("#{index + 1}.".colorize(:light_cyan) + " #{journal['title']}" + " " * 20 + "#{journal['date']}".colorize(:light_magenta))
    }

    puts()

    valid_input = false
    while true
      puts("Type EXIT to return to main menu".colorize(:red))
      print("Enter number of entry to remove: ".colorize(:light_cyan))
      entry_to_delete = gets.strip
      if entry_to_delete.count('0-9') == entry_to_delete.length && entry_to_delete != "0"
        if entry_to_delete.to_i <= @journal_entries_arr.length
          break
        end
      elsif entry_to_delete.upcase == "EXIT"
        return
      end

      puts("Please enter a valid number!")

    end

    @journal_entries_arr.delete_at(entry_to_delete.to_i - 1)

    # delete the entry from the @journal_entries_arr and then write the changes to disk

    save_journal_entries_arr_to_disk

  end

  def filter_entries_by_mood()
    puts `clear`

    mood_list = []

    # Iterate through each journal entry and only display the ones with the specified mood
    @journal_entries_arr.each { |journal|
      mood_list << journal['mood'] if !mood_list.include?(journal['mood'])
    }

    view_mood_list(mood_list)
    puts
    print("Select the mood you'd like to filter".colorize(:light_cyan) + " (Type EXIT to return): ".colorize(:red))
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
      
      puts("Please enter a valid mood!".colorize(:red))
      print("Select the mood you'd like to filter".colorize(:light_cyan) + " (Type EXIT to return): ".colorize(:red))
      input = gets.strip
    end

    filtered_array = []

    @journal_entries_arr.each { |journal|
      filtered_array << journal if journal['mood'] == selected_mood
    }

    selected_entry = display_list_of_entries(filtered_array)
    # Show the content of the selected entry, unless the user typed "EXIT"
    show_content_of_entry(selected_entry, filtered_array) if selected_entry != nil
  end

end

def main()

  journal_app = Journal.new

  journal_app.title()

end


main()

