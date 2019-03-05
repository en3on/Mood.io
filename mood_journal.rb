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

