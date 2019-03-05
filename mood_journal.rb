
require 'csv'
require 'pry'
require 'date'

@journal_entries_arr = []

def main_menu
    puts("Welcome to mood.IO")
    puts("Please select the main following options: ")
    puts("Press 1 - To add a journal entry")
    puts("Press 2 - To view your journal entries")
    puts("Press 3 - To select a mood of your choice and view the the journal entries for that mood")
    puts("Press 4 - To view all mood list")
    puts("Press 5 - To view your most used words for each journal entries")
    puts("Press 6 - Quit mood.IO ")
    user_input = gets().strip.to_i
    while (user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4 && user_input != 5 && user_input != 6)
        puts("Error please select the main following options: ")
        puts("Press 1 - To add a journal entry")
        puts("Press 2 - To view your journal entries")
        puts("Press 3 - To select a mood of your choice and view the the journal entries for that mood")
        puts("Press 4 - To view all mood list")
        puts("Press 5 - To view your most used words for each journal entries")
        puts("Press 6 - Quit mood.IO ")
        user_input = user_input = gets().strip.to_i
    end
    if (user_input == 1)
        p 1
    elsif (user_input == 2)
        p 2
    elsif (user_input == 3)
        p 3
    elsif (user_input == 4)
        p 4
    elsif (user_input == 5)
        p 5
    elsif (user_input == 6)
        puts "Thank you for using mood.IO"
    end
end

def get_journal_entry()
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

  puts("Choose a mood for this entry!")
  # run mood_list_display function
  mood = "Happy"

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
  @journal_entries_arr.each_with_index { |journal, index|
    puts("#{index + 1}. #{journal['title']}")
  }
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
end


def view_mood_list(mood_list_arr)
    mood_list_arr.each_with_index do |moodli, index|
        puts "#{index + 1}: #{moodli}"
    end
end

