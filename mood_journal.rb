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

  return {
    title: title,
    content: lines 
  }

end

def save_journal_entry_to_disk(journal_entry)
  content = journal_entry[:content].join(';')

  File.open("journal_entries.csv", "a+").puts("#{journal_entry[:title]},#{content}")
  File.close
end

journal_entry = get_journal_entry()

save_journal_entry_to_disk(journal_entry)

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
        mood_input = gets().strip.capitalize
        mood_list_arr << mood_input
    elsif (user_input_custom_mood == 2)
        puts "Type a mood that you want to delete:"
        puts mood_list_arr
        delete_mood_input = gets().strip.capitalize
        mood_list_arr.delete(delete_mood_input)
    elsif (user_input_custom_mood == 3)
        puts "home page" 
    end
end
custom_mood(mood_list_arr)
print mood_list_arr
        