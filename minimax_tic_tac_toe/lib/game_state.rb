class GameState
  attr_reader :game
  attr_accessor :current_player, :board, :moves, :rank

  def initialize(current_player, board, game)
    @current_player = current_player
    @board = board
    @moves = []
    @game = game
  end

  def rank
    @rank ||= final_state_rank || intermediate_state_rank
  end

  def next_move
    moves.max { |a, b| a.rank <=> b.rank }
  end

  def final_state?
    winner || draw?
  end

  def draw?
    board.compact.size == 9 && winner.nil?
  end

  def winner
    @winner ||= winning_positions.map do |positions|
      winning_row?(positions) || nil
    end.compact.first
  end

  private

    def intermediate_state_rank
      ranks = moves.map { |game_state| game_state.rank }
      if current_player == game.computer_player
        ranks.max
      else
        ranks.min
      end
    end

    def final_state_rank
      if final_state?
        return 0 if draw?
        winner == game.computer_player ? 1 : -1
      end
    end

    def winning_row?(positions)
      player = board[positions[0]]
      if player &&
      player == board[positions[1]] &&
      player == board[positions[2]]
        player
      end
    end

    def winning_positions
      [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [6, 4, 2]
      ]
    end
end
