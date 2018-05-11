class GameTree
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def generate
    initial_game_state = GameState.new("X", Array.new(9), game)
    generate_moves(initial_game_state)
    initial_game_state
  end

  def generate_moves(game_state)
    next_player = (game_state.current_player == "X" ? "O" : "X")
    game_state.board.each_with_index do |player_at_position, position|
      unless player_at_position
        next_board = game_state.board.dup
        next_board[position] = game_state.current_player

        next_game_state = GameState.new(next_player, next_board, game)
        game_state.moves << next_game_state
        generate_moves(next_game_state)
      end
    end
  end
end
