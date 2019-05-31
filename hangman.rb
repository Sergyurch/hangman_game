require 'json'

class Game
  
  def initialize
    reset_data
    puts "LET'S PLAY HANGMAN! WILL YOU BE ABLE TO GUESS THE WORD?"
    start
  end
  
  def start
    load_game
    
    @turns.times do
      puts ''
      puts "Turns left: #{@turns}"
      puts "Current word:  #{@current_word}"
      puts "Incorrect letters: #{@incorrect_letters.to_s}"
      puts ''
      save_game
      puts 'Make your choice. Enter only one letter or the whole word.'
      @choice = gets.chomp
      
      until @choice.match?(/[A-Z,a-z]/)
        puts "Enter only letters."
        @choice = gets.chomp
      end
      
      if @choice == @guessed_word || @current_word == @guessed_word
        puts 'You win!'
        break
      elsif @choice.length == 1
        @guessed_word.split('').each_with_index do |letter, index|
          @current_word[index] = @guessed_word[index] if letter == @choice.downcase 
        end
        @incorrect_letters.push(@choice.downcase) if !@guessed_word.include?(@choice.downcase)
      end
      
      @turns -= 1
    end
    
    puts "You lost!"
    
    if play_again?
      reset_data
      start
    else 
      return
    end
  end
  
  def reset_data
    @guessed_word = Word.new.random
    @turns = 7
    @incorrect_letters = []
    @current_word = ''
    @guessed_word.length.times { @current_word += '_' }
  end
  
  def save_game
    puts 'Would you like to save game?(Y/N)'
    answer = gets.chomp
    
    until answer.match?(/[Y,y,N,n]/)
      puts "Enter \'Y\' or \'N\', please"
      answer = gets.chomp
    end
    
    if answer.match?(/[Y,y]/)
      object = {'guessed_word' => @guessed_word, 'turns' => @turns, 'current_word' => @current_word, 'incorrect_letters' => @incorrect_letters}
      File.open("save.txt", "w") do |file|
        file.puts JSON.dump object
      end
    end
  end
  
  def load_game
    if File.exist?('save.txt')
      puts "Would you like to load saved game?(y/n)"
      answer = gets.chomp
      
      until answer.match?(/[Y,y,N,n]/)
        puts "Enter only \"y\" or \"n\"."
        answer = gets.chomp
      end
      
      if answer.match?(/[Y,y]/)
        data = JSON.load File.read('save.txt')
        @guessed_word = data['guessed_word']
        @turns = data['turns']
        @current_word = data['current_word']
        @incorrect_letters = data['incorrect_letters']
      end
    end
  end
  
  def play_again?
    puts 'Would you like to play again?(Y/N)'
    answer = gets.chomp
    
    until answer.match?(/[Y,y,N,n]/)
      puts "Enter \'Y\' or \'N\', please"
      answer = gets.chomp
    end
    
    return (answer.match?(/[Y,y]/)) ? true: false
  end
end

class Word
  def initialize
    @words = File.open('5desk.txt', 'r').readlines.select! {|word| word.chomp.length >= 5 && word.chomp.length <= 12}
    @words.map! {|word| word.chomp}
    #return words[rand(words.length)]
  end
  
  def random
    @words[rand(@words.length)]
  end
end