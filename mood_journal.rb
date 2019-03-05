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