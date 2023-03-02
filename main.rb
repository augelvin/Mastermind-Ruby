class Mastermind
  @@rounds = 8
  
  def initialize(human_class, computer_class)
    @human = human_class.new
    @computer = computer_class.new(self)
    @again = true
    @code = Array.new
    @options
  end

  def play()
    while @again
      @options = Array(1111..6666).map {|n| n.to_s.split('')}
      game_mode = ask_game_mode
      code_maker if game_mode == 1
      code_breaker if game_mode == 2
      again?
    end
  end

  def ask_game_mode
    loop do
      puts "\nChoose game mode:"
      puts "1 - Code Maker: Make a 4 digit code, and computer try to guess the code"
      puts "2 - Code Breaker: Computer make a 4-digit code, and you have 8 chances to guess"
      mode = gets.to_i
      return mode if (mode == 1 || mode == 2)
      puts "Please type '1' or '2' only"
    end
  end

  def code_maker
    @code = @human.gets_code('Make')
    guess_rounds(@computer)
  end

  def code_breaker
    for i in 1..4 do
      @code.push(rand(1..6).to_s)
    end
    guess_rounds(@human)
  end

  def again?
    puts "\nDo you want to play again?"
    puts "Press 'y' to play again, others to quit"
    answer = gets.chomp
    if answer != 'y'
      @again = false
    end
  end

  def guess_rounds(guesser)
    for i in 1..@@rounds do
      name = guesser.gets_name
      guess = guesser.gets_code('Guess')
      feedback = evaluate(guess, @code)
      puts ''
      puts guess.join + ' - ' + feedback
      filter_options(guess, feedback)
      if feedback == 'OOOO'
        puts "#{name} broke the code! #{name} win!"
        break
      elsif i == @@rounds
        puts "#{name} lose! The code is #{@code}."
      else
        puts "Wrong guess, try again."
      end
      puts "Guess(es) left: #{@@rounds-i}"
    end
  end

  def evaluate(guess, code)
    result = ''
    temp_guess = guess.join.split('')
    temp_code = code.join.split('')
    temp_guess.each_index do |i|
      if temp_guess[i] == temp_code[i]
        result << 'O'
        temp_code[i] = nil
        temp_guess[i] = 'checked'
      end
    end
    temp_guess.each_index do |i|
      if temp_code.include?(temp_guess[i])
        result << 'X'
        temp_code[temp_code.index(temp_guess[i])] = nil
        temp_guess[i] = 'checked'
      end
    end
    return result
  end

  def filter_options(guess, feedback)
    new_options = Array.new
    @options.each do |option|
      result = evaluate(option, guess)
      if result == feedback
        new_options << option
      end
    end
    @options = new_options
  end

  def get_options
    @options
  end
end

class Human
  def gets_code(action) # for both create and guess
    loop do
      puts "\n#{action} a 4-digit code using numbers from 1 to 6"
      code = gets.chomp.split('')
      return code if (code.all? {|i| ['1', '2', '3', '4', '5', '6'].include?(i)} && code.length == 4)
      puts "\nPlease make a 4-digit code with the number 1 to 6 only"
    end
  end

  def gets_name
    name = 'You'
  end
end

class Computer
  def initialize(game)
    @game = game
  end
  
  def gets_code(action)
    guess = @game.get_options.sample      
  end

  def gets_name
    name = 'Computer'
  end
  
end

game = Mastermind.new(Human, Computer).play