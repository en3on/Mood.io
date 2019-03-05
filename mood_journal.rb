require 'csv'
require 'pry'
require 'date'

@journal_entries_arr = []

def get_journal_entry(mood_list_arr)
@journal_entries_arr

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
binding.pry
var = true
