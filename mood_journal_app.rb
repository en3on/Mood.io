module Display
  def start_up_screen()
    system `clear`
    puts("-" * 20 + " mood.IO " + "=" * 20)
    puts("Created by Adam Ladell and David Bui")
    sleep 1.5
  end

  def log_in_screen()

  end

  def register_screen()

  end

  def main_menu()

  end

  def journal_entry_creation()

  end

  def mood_list()

  end

  def delete_entry()

  end

  def journal_entry_list()

  end
end

module Functions

end



def main()
  include Display

  Display::start_up_screen()


end

main()
