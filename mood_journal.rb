require 'csv'

def get_journal_entry(mood_list_arr)
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

  return {
    title: title,
    content: lines, 
    mood: mood
  }

end

def save_journal_entry_to_disk(journal_entry)
  content = journal_entry[:content].join(';')

  File.open("journal_entries.csv", "a+").puts("#{journal_entry[:title]},#{content},#{journal_entry[:mood]}")
end

def read_journal_entries_from_disk(file_name)
  csv_text = File.read("journal_entries.csv")
  csv = CSV.parse(csv_text, :headers => true)

  journal_entries = []

  csv.each { |row|
    row_data = row.to_hash 
    
    journal_entries << row_data
  }
end

def display_list_of_entries(journal_entries_arr)
  journal_entries_arr.each_with_index { |journal, index|
    puts("#{index + 1}. #{journal['title']}")
  }
end

