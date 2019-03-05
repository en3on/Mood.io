
require 'csv'
require 'pry'
require 'date'


class Journal
  attr_accessor(:journal_entries_arr, :mood_list)
  def initialize
    @journal_entries_arr = []
    @mood_list = []
  end

  def main_menu
    input = ""
    while input != "6" 
      puts `clear`
      puts("Welcome to mood.IO!")
      puts("Please select an option: ")
      puts

      puts("[1] Add journal entry")
      puts("[2] View Journal Entries")
      puts("[3] Add or Delete Moods")
      puts("[4] Show the most used moods")
      puts("[5] Filter entries by mood")
      puts("[6] Exit")
      puts

      input = gets.strip

      case input
      when "1"
        journal = get_journal_entry(@mood_list)
        add_journal_entry_to_arr(journal)
        save_journal_entries_arr_to_disk()
      when "2"
        if @journal_entries_arr.length > 0
          input = display_list_of_entries
          show_content_of_entry(input)
        else
          puts("There are no entries!")
          puts("Press enter to continue...")
          gets
        end
      when "3"
        custom_mood()
      when "4"
        get_most_used_moods() 
        puts("Press enter to return...")
        gets
      when "5"
        p 5
      when "6"
        puts("Thanks for using mood.IO! :)")
        break
      else
        puts("Please enter a valid option!")
      end
    end
  end

  def get_journal_entry(mood_list)
    puts `clear`
    puts("NEW JOURNAL ENTRY")
    puts
    puts
    print("Title: ")
    title = gets.strip()

    puts()
    puts("Journal Entry: (Type EXIT on a new line, to finish entry)")
    puts

    input = ''

    lines = []

    while input != "EXIT"
      input = gets.strip
      lines << input
    end

    puts

    view_mood_list(mood_list)
    puts
    puts("Choose a mood for this entry! (Enter the mood name)")
    puts
    mood = gets.strip().capitalize

    lines.pop

    return {
      title: title,
      content: lines,
      mood: mood
    }

  end


  def add_journal_entry_to_arr(journal_entry)
    content = journal_entry[:content].join(';')
    csv_text = "title,content,mood\n#{journal_entry[:title]},#{content},#{journal_entry[:mood]}"
    csv_entry = CSV.parse(csv_text, :headers => true)

    csv_entry.each { |row|
      @journal_entries_arr << row.to_hash
    }
  end

  def custom_mood()
    puts `clear`
    view_mood_list(@mood_list)
    puts
    puts("Press 1: To add a mood")
    puts("Press 2: To delete a mood")
    puts("Press 3: Go back to Homepage")
    user_input_custom_mood = gets().strip.to_i
    while (user_input_custom_mood != 1 && user_input_custom_mood != 2 && user_input_custom_mood != 3)
      puts `clear`
      puts("Error incorrect input")
      puts
      view_mood_list(@mood_list)
      puts("Press 1: To add a mood?")
      puts("Press 2: To delete a mood")
      puts("Press 3: Go back to Homepage")
      user_input_custom_mood = gets().strip.to_i
    end
    if (user_input_custom_mood == 1)
      puts `clear`
      puts "Type your mood:"
      puts
      mood_input = gets().strip
      @mood_list << mood_input.capitalize
    elsif (user_input_custom_mood == 2)
      puts `clear`
      puts "Type a mood that you want to delete:"
      puts
      puts
      delete_mood_input = gets().strip.capitalize
      @mood_list.delete(delete_mood_input)
    elsif (user_input_custom_mood == 3)
      return
    end

    write_mood_list_to_file
  end

  def save_journal_entries_arr_to_disk()
    File.open("journal_entries.csv", "w") do |file|
      file.puts("title,content,mood")
      @journal_entries_arr.each { |journal|
        file.puts(journal)
      }
    end

  end

  def read_journal_entries_to_array()
    @journal_entries_arr = []

    File.open("journal_entries.csv").each_with_index { |row, index|
      if index != 0
        @journal_entries_arr << eval(row) 
      end
    }
  end

  def display_list_of_entries()
    puts `clear`
    @journal_entries_arr.each_with_index { |journal, index|
      puts("#{index + 1}. #{journal['title']}")
    }
    puts
    print("Please enter the number of the journal entry you would like to view: ")
    while true
      input = gets.strip

      if input.count('0-9') == input.length
        if input.to_i <= @journal_entries_arr.length
          return input.to_i
        end
      end

      puts("Please enter a valid number!")
    end
  end

  def show_content_of_entry(user_selection)
    journal = @journal_entries_arr[user_selection - 1]

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
    File.open("mood_list.txt", "w") do |file|
      @mood_list.each { |mood|
        file.puts(mood.strip)
      }
    end 
  end

  def read_mood_list_from_file()
    @mood_list = []
    
    file = File.open("mood_list.txt", "r")
    file.each_line { |line|
      @mood_list << line.strip
    }

    file.close

  end

  def get_most_used_moods()
    mood_hash = {}

    @mood_list.each { |mood|
      mood_hash[mood] = 0
    }

    puts(mood_hash)

    @journal_entries_arr.each { |journal|
      mood_hash[journal['mood']] += 1
    }

    sorted_mood_hash = mood_hash.sort_by { |mood, count| count}.reverse

    sorted_mood_hash.each { |mood, count|
      puts("#{mood}: #{count}")
    }
  end
end



def main()

  journal_app = Journal.new

  journal_app.read_mood_list_from_file()

  journal_app.read_journal_entries_to_array

  journal_app.main_menu()

end


main()

