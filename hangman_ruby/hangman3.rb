require 'yaml'

p Dir.pwd
save_games_array = Dir.children("./savefiles/")
user_guess_arr = []
random_word_arr = []
save_input = ''
puts "WELCOME TO HANGMAN!THE GAME!!!!"

$guess_left = 0

def user_guess(rand_word,user_guessed_word,incorrect,rem_guesses)
    game_over = false
    while game_over === false
        p user_guessed_word
        puts "Please guess a letter\n"
        user_guess = gets.chomp
        if (user_guess.size > 1)
            puts "Invalid Input.Please try again.."
        else
            if rand_word.include?(user_guess)
                idx = rand_word.each_with_index.map { |a, i| a == user_guess ? i : nil }.compact
                idx.each do |i|
                    user_guessed_word[i] = user_guess
                end
                p user_guessed_word
            else
                incorrect.push(user_guess)
            end
            puts "Your incorrect guesses: #{incorrect}"
            puts "You still have #{10 - incorrect.size} guesses remaining."
        end     
        

        if user_guess == 'off' || (10 - incorrect.size) < 1 || rand_word == user_guessed_word
            game_over = true
            if user_guess == 'off'
                puts "\n\nDo you want to save the game now?Press 'y' for yes and any other key for no"
                save_input = gets.chomp
                if save_input == 'y'
                    save_game(rand_word,user_guessed_word,incorrect,rem_guesses)
                end
            elsif rand_word == user_guessed_word
                puts "Congratulations!You have won the game!!Yipeee:)"
            elsif (10 - incorrect.size) < 1
                puts "Uh Oh!You have used up all your guesses:("
                puts "The correct word was #{rand_word}"
            end
        end
    end
end

def new_game()
    myFile = File.open('google-10000-english-no-swears.txt')
    file_data = File.read('google-10000-english-no-swears.txt').split
    words_with_correct_length = file_data.filter { |ele| ele if ele.size >= 5 && ele.size <= 12 }
    selected_word = words_with_correct_length.sample
    num_arr = Array(0..(selected_word.length - 1))
    dashed_index = num_arr.sample(4)
    random_word = selected_word.clone
    str_replace = '_'
    dashed_index.each do |idx|
        selected_word[idx] = '_'
    end
    $selected_word_arr = selected_word.split("")
    $random_word_arr = random_word.split("")
    guessed_count = 0
    $correct_guess_arr = []
    $incorrect_guess_arr = []
    user_guess($random_word_arr,$selected_word_arr,$incorrect_guess_arr,guessed_count)
end


def save_game(rand_word,user_guessed_word,incorrect,rem_guesses)
    puts "Please enter the name of the game save"
    game_save_name = gets.chomp
    save_obj = {}
    save_obj[:random_word] = rand_word
    save_obj[:user_guess_progress] = user_guessed_word
    save_obj[:guesses] = rem_guesses
    save_obj[:incorrect_arr] = incorrect
    File.open("./savefiles/#{game_save_name}.yml", "w") { |file| file.write(save_obj.to_yaml) }
    puts "Your progess has been saved..."
end 


def load_game()
    load_idx = 1
    save_games_array = Dir.children("./savefiles/")
    puts "Select the number for the save file you want to load"
    save_games_array.each_with_index do |elem,idx|
        puts "#{idx+1}. #{elem.chomp(".rb")}"
    end
    load_idx = gets.chomp.to_i - 1
    if load_idx >= 0 && load_idx < save_games_array.length
        obj_from_yaml_file = YAML.load(File.read("./savefiles/#{save_games_array[load_idx]}"))
        loaded_random_word = obj_from_yaml_file[:random_word]
        loaded_selected_word = obj_from_yaml_file[:user_guess_progress]
        loaded_remaining_guesses = obj_from_yaml_file[:guesses]
        loaded_incorrect_guesses = obj_from_yaml_file[:incorrect_arr]
        p loaded_remaining_guesses
        user_guess(loaded_random_word,loaded_selected_word,loaded_incorrect_guesses,loaded_remaining_guesses)
        if load_idx <= save_games_array.length && load_idx >= 0
            incorrect_load_ans = false
        end
    else
        puts "\n\n\n\nInvalid Input"
        puts "Let's start a new game instead!"
        new_game()
    end
end



def game()
    puts "Do u wanna load from previous saves?Press 'y' for yes"
    load_ans = gets.chomp
    if load_ans == 'y'
        load_game()
    else
        new_game()
    end
end

game()


