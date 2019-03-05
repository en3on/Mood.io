
require 'csv'
require 'pry'
require 'date'

@journal_entries_arr = []


def main_menu
lineWidth = 100
title = "Welcome to mood.IO"
options = "Please select the main following options: "
p1 = ("Press 1 - To add a journal entry")
p2 = ("Press 2 - To view your journal entries")
p3 = ("Press 3 - To select a mood of your choice and view the the journal entries for that mood")
p4 = ("Press 4 - To view all mood list")
p5 = ("Press 5 - To view your most used words for each journal entries")
p6 = ("Press 6 - Quit mood.IO ")
puts
puts
puts
sleep 1
puts title.center(lineWidth)
puts
puts
puts
print "Loading"
1.upto(5) do |n|
    print "."
    sleep 1 # in second delays the print
  end
puts
puts
sleep 1
puts p1.center(lineWidth)
sleep 1.2
puts p2.center(lineWidth)
sleep 1.2
puts p3.center(lineWidth)
sleep 1.2
puts p4.center(lineWidth)
sleep 1.2
puts p5.center(lineWidth)
sleep 1.2
puts p6.center(lineWidth)
puts
puts

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
mood_list_arr = ["Happy", "Sad", "Chilled"]
def custom_mood(mood_list_arr)
    puts("Press 1: To add a mood")
    puts("Press 2: To delete a mood")
    puts("Press 3: Go back to Homepage")
    user_input_custom_mood = gets().strip.to_i
    while (user_input_custom_mood != 1 && user_input_custom_mood != 2 && user_input_custom_mood != 3)
        puts("Error Error incorrect input")
        puts("Press 1: To add a mood?")
        puts("Press 2: To delete a mood")
        puts("Press 3: Go back to Homepage")
        user_input_custom_mood = gets().strip.to_i
    end
    if (user_input_custom_mood == 1)
        puts "Type your mood:"
        arr_one_mood = []
        mood_input = gets().strip.capitalize
        while (/\d/.match(mood_input) || (/[!@#$%^&*()_+={}\[\]:;'"\/\\?><.,]/).match(mood_input) || ("-").match(mood_input))
            puts "Incorrect input, Please type your mood again!"
            mood_input = gets().strip.capitalize
        end
        mood_list_arr << mood_input
    elsif (user_input_custom_mood == 2)
        puts "Type a mood that you want to delete:"
        puts mood_list_arr
        delete_mood_input = gets().strip.capitalize
        while (!mood_list_arr.include?(delete_mood_input))
            puts mood_list_arr
            puts "Please only type the mood that you want to delete from the list!!!"
            delete_mood_input = gets().strip.capitalize
        end
        mood_list_arr.delete(delete_mood_input)
    elsif (user_input_custom_mood == 3)
        puts "home page" 
    end
end
custom_mood(mood_list_arr)
print mood_list_arr

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
