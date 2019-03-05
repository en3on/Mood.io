def journal_entry()
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

  journal_entry = {
    title: title,
    content: lines 
  }

end

