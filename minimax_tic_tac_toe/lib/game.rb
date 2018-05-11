require "pry"
require_relative "./game_state"
require_relative "./game_tree"

class Game
  attr_accessor :game_state, :human_player, :computer_player

  def initialize
    @human_player = get_human_player
    @game_state = @initial_game_state = GameTree.new(self).generate
  end

  def turn
    puts "#{game_state.current_player}'s turn:"
    render_board

    if game_state.final_state?
      end_game
    end

    puts "\n=============="
    if game_state.current_player == computer_player
      self.game_state = game_state.next_move
    else
      get_human_move
    end

    turn
  end

  def computer_player
    human_player == "X" ? "O" : "X"
  end

  private

    def get_human_player
      puts "Would you like to play as 'X' or 'O'?"
      human_player = gets.strip

      unless human_player == "O" || human_player == "X"
        puts "Sorry, your entry was invalid. Would you like to play as 'X' or 'O'?"
        human_player = gets.strip
      end

      human_player
    end

    def end_game
      describe_final_game_state
      puts "Play again y/n"
      answer = gets
      if answer.downcase.strip == "y"
        self.game_state = @initial_game_state
        self.human_player = get_human_player
        turn
      else
        exit
      end
    end

    def get_human_move
      puts "Enter square # to place your '#{human_player}' in:"
      position = gets

      move = game_state.moves.find { |game_state| game_state.board[position.to_i] == "#{human_player}" }

      if move
        self.game_state = move
      else
        puts "That's not a valid move"
        get_human_move
      end
    end

    def describe_final_game_state
      if game_state.draw?
        puts "It's a draw!"
      elsif game_state.winner == "X"
        puts "X won!"
      else
        puts "O won!"
      end
    end

    def render_board
      output = ""
      0.upto(8) do |position|
        output << " #{game_state.board[position] || position } "
        case position % 3
        when 0, 1 then output << "|"
        when 2 then output << "\n------------\n" unless position == 8
        end
      end
      puts output
    end
end

Game.new.turn
