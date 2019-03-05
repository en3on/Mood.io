require 'csv'
require 'pry'

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

#def save_journal_entry_to_disk(journal_entry)
  #content = journal_entry[:content].join(';')

  #File.open("journal_entries.csv", "a+").puts("#{journal_entry[:title]},#{content},#{journal_entry[:mood]}")
#end

#def read_journal_entries_from_disk(file_name)
  #csv_text = File.read("journal_entries.csv")
  #csv = CSV.parse(csv_text, :headers => true)

  #journal_entries = []

  #csv.each { |row|
    #row_data = row.to_hash 
    
    #journal_entries << row_data
  #}
#end

def read_journal_entries_to_array()
  @journal_entries_arr = []

  File.open("journal_entries.csv").each_with_index { |row, index|
    if index != 0
      @journal_entries_arr << eval(row) 
    end
  }
end

def display_list_of_entries(journal_entries_arr)
  @journal_entries_arr.each_with_index { |journal, index|
    puts("#{index + 1}. #{journal['title']}")
  }
end

binding.pry
var = true
