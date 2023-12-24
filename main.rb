require 'colorize'

class Game
  COLORS = {
    1 => :red,
    2 => :yellow,
    3 => :green,
    4 => :cyan,
    5 => :blue,
    6 => :magenta
  }
  
  def play
    print_instructions
  end
  
  def colorful(num)
    color = COLORS[num]
    " #{num} ".colorize(:color => :black, :background => color)
  end

  def print_instructions
    puts 'Do you know how to play this game?'
    knows = gets.chomp.downcase == 'no' ? false : true 
    unless knows
      puts instructions
    end
  end

  def instructions
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
      HEREDOC
  end
end

class Player

end

class Breaker < Player

end

class Maker < Player

end

Game.new.play
