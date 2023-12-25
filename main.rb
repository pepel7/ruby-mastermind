require 'colorize'

class Game
  private

  COLORS = {
    1 => :red,
    2 => :yellow,
    3 => :green,
    4 => :cyan,
    5 => :blue,
    6 => :magenta
  }

  def initialize
    @code
    @breaker
    @maker
  end

  attr_accessor :breaker, :maker
  public attr_accessor :code
  
  public def play
    print_instructions
    choose_roles
    maker.make_code
    turn = 1
    loop do
      guess_code = breaker.break_code(turn, guess_code)
      if code_broken?(guess_code)
        puts "#{breaker} broke it!! Game over."
        break
      elsif turn > 12
        puts "The turns have run out! Game over. #{maker} wins."
        break
      end
      puts 'Wrong guess.'
      turn += 1
    end
  end
  
  def colorful(num)
    color = COLORS[num]
    " #{num} ".colorize(:color => :black, :background => color)
  end

  def print_instructions
    puts "Do you know how to play this game? \n#{"(Enter 'no' if you don't, or anything else if you know the rules)".gray}"
    knows = gets.chomp.downcase == 'no' ? false : true 
    unless knows
      puts instructions
    end
  end

  def instructions # прибрати таби наприкінці! (залишені, щоб згортався код)
    <<-HEREDOC
    #{"How to play Mastermind:".black.on_light_white}

    This is a 1-player game against the computer.
    You can choose whether you will be the code #{"maker".bold.underline} or the code #{"breaker".bold.underline}.
    
    There are six different number/color combinations:
    
    #{colorful(1)} #{colorful(2)} #{colorful(3)} #{colorful(4)} #{colorful(5)} #{colorful(6)}
    
    
    The code maker must select a four-digit number to create a 'master code'. For example:
    
    #{colorful(1)} #{colorful(3)} #{colorful(4)} #{colorful(1)}
    
    As you can see, #{"numbers/colors can be repeated".yellow}.
    To win, the code breaker needs to guess the 'master code' in 12 turns or less.
    
    
    #{"Clues:".black.on_light_white}
    After each guess, there will be up to four clues to help crack the code.
    
     ● This clue means you have 1 correct number in the correct location.
    
     ○ This clue means you have 1 correct number, but in the wrong location.
    
    
    #{"Clue Example:".black.on_light_white}
    To continue the example, using the above 'master code' a guess of "1463" would produce 3 clues:
    
    #{colorful(1)} #{colorful(4)} #{colorful(6)} #{colorful(3)}  Clues: ● ○ ○ 
    
    The guess had 1 correct number in the correct location and 2 correct numbers in a wrong location.
    __________________________________________________
      HEREDOC
  end

  def choose_roles
    puts "Who would you like to be? Type 'm' for maker or 'b' for breaker."
    loop do
      answer = gets.chomp.downcase
      if answer == 'm'
        @maker = HumanPlayer.new(self, 'maker')
        @breaker = ComputerPlayer.new(self, 'breaker') #видалити @role якщо вони не використовуватимуться
        break
      elsif answer == 'b'
        @breaker = HumanPlayer.new(self, 'breaker')
        @maker = ComputerPlayer.new(self, 'maker')
        break
      end
    end
  end

  def code_broken?(guess_code)
    code == guess_code
  end
end

class Player
  private

  def initialize(game, role)
    @game = game
    @role = role
  end

  attr_accessor :game
end

class ComputerPlayer < Player
  def make_code
    game.code = ' ' + rand(1111..6666).to_s # ignore index 0 for convenience
    puts 'The computer has chosen its secret code.'
    p game.code
  end

  private

  def to_s
    'Computer'
  end
end

class HumanPlayer < Player
  def make_code
    game.code = gets.chomp
  end

  def break_code(turn, guess_code)
    puts "Turn #{turn}: Enter four digits (1-6) to guess the code"
    guess_code = ' ' + gets.chomp # ignore index 0 for convenience
  end

  private

  def to_s
    'Human'
  end
end

Game.new.play
