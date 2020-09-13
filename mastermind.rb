require 'pry'

class Game
  def initialize
    puts 'Welcome to Mastermind, what is your name?'
    @player = gets.chomp
    i = false
    until i == true
      puts 'Enter 0 to play as Code Breaker, or 1 to play as Code Maker'
      @mode = gets.chomp
      if ('0'..'1').include?(@mode)
        i = true
        @mode = @mode.to_i
      else
        i = false
      end
    end
    @code = []
    @win = false
    @all_results = []
    @round = 1
    @all_guesses = []
    @feedback = []
  end

  def random_generator
    code = []
    i = 0
    while i < 4
      code[i] = rand(6)
      i += 1
    end
    @code = code
  end

  def guess
    guess_code = []
    i = 0
    while i < 4
      print 'Select a number (0-5): '
      number = gets.chomp
      if ('0'..'5').include?(number)
        guess_code[i] = number.to_i
        i += 1
      else
        puts 'Please choose a number in the range'
      end
    end
    @guess_code = guess_code
  end

  def checker
    i = 0
    j = 0
    code = @code.dup
    guess = @guess_code.dup
    feedback = []
    while i < 4
      if code.include?(guess[i])
        feedback.push('White')
        index = code.index(guess[i])
        code[index] = 6
      end
      i += 1
    end
    code = @code.dup
    while j < 4
      if guess[j] == code[j]
        feedback.push('Black')
        feedback.shift
        code[j] = 6
      end
      j += 1
    end
    if feedback == ['Black', 'Black', 'Black', 'Black']
      @win = true
    end
    @all_results.push("#{@guess_code}|#{feedback}")
    puts @all_results
    @feedback = feedback
  end

  def code_maker
    i = 0
    while i < 4
      puts 'Enter a number (0-5)'
      number = gets.chomp
      if ('0'..'5').include?(number)
        @code[i] = number.to_i
        i += 1
      else
        puts 'This is not a number in the range'
      end
    end
    print "Your code is: #{@code} \n"
  end

  def code_guesser(num)
    if @feedback.length == 0
      @guess_code = [num, num, num, num]
    elsif @feedback.length == 1
      @guess_code[1] = num
      @guess_code[2] = num
      @guess_code[3] = num
    elsif @feedback.length == 2
      @guess_code[2] = num
      @guess_code[3] = num
    elsif @feedback.length == 3
      @guess_code[3] = num
    else
      while @all_guesses.include?(@guess_code)
        @guess_code = @guess_code.shuffle
      end
    end
    @all_guesses.push(@guess_code)
  end

  def play
    if @mode == 0
      random_generator
      i = 0
      while i < 10 && @win == false
        puts "----ROUND #{@round}----"
        @round += 1
        guess
        checker
        i += 1
      end
    else
      code_maker
      i = 0
      while i < 10 && @win == false
        puts "----ROUND #{@round}----"
        @round += 1
        code_guesser(i)
        checker
        i += 1
      end
    end
    if @win == true && @mode == 0
      puts "Yay #{@player}! You won!"
    elsif @win == false && @mode == 1
      puts "Yay #{@player}! You won! The computer couldn't guess your code"
    elsif @mode == 0
      puts 'You lost, better luck next time.'
      puts "The code was actually #{@code}."
    else
      puts 'You lost, the computer guessed your code.'
    end
  end
end

game = Game.new
game.play