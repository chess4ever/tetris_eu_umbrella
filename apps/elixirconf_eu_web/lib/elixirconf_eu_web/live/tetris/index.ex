defmodule  ElixirconfEuWeb.Tetris.Index do
  use Phoenix.LiveView
  alias Tetris.Core.{Board, Game, Shape}
  alias Tetris.Boundary.{GameLogic}

  def mount(_session, socket) do
    # {:ok, game_session_pid} = Tetris.start_game_session(%{listener_pid:  self()})

    game = Game.new(%{})
    new_socket = generate_socket_from_game(socket, game)
    # new_socket = generate_socket_from_state(socket, :sys.get_state(game_session_pid))
    # |> assign(:game_id, game_session_pid)



    {:ok, new_socket}
  end

  # def handle_info({:state_change, new_state}, socket) do
  #   {:noreply, generate_socket_from_state(socket, new_state)}
  # end

  def handle_event("tetris", "rotate", socket) do
    # game_session_id = socket.assigns.game_id
    # Tetris.rotate(game_session_id)
    {:noreply, socket}
  end

  def handle_event("move", %{"code" => key}, socket) do
    # game_session_id = socket.assigns.game_id
    ox = socket.assigns.offset_x
    oy = socket.assigns.offset_y
    active_shape = socket.assigns.active_shape
    board = socket.assigns.board

    IO.puts "move ... #{ key } "

    game = %Game{offset_x: ox,
                 offset_y: oy,
                 active_shape: active_shape,
                 board: board
                }


    res = case key do
            # "ArrowRight" -> GameLogic.move(ox, oy, active_shape, board, :right)
            "ArrowLeft" -> GameLogic.move(game, :left)
            # "ArrowLeft" -> GameLogic.move(ox, oy, active_shape, board, :left)
            # "ArrowLeft" -> Tetris.move(game_session_id, :left)
            # "ArrowUp" -> Tetris.rotate(game_session_id)
            # "ArrowDown" -> Tetris.move(game_session_id, :down)
            _ -> nil
          end

    IO.puts inspect(res)

    updated_socket = generate_socket_from_game(socket, res)


    # {:noreply, updated_socket}
    {:noreply, socket}
  end

  defp generate_socket_from_game(socket, game) do

    assign(socket,
      game_over: game.game_over,
      board: game.board,
      active_shape: game.active_shape,
      next_shape: game.next_shape,
      # state_change_listener: game.state_change_listener,
      score: game.score,
      game_over: game.game_over,
      offset_x: game.offset_x,
      offset_y: game.offset_y,

      lanes: game.board.lanes,
      indexor: game.board.indexor,

      new_game: true,
      speed: 600
    )

  end

  def render(assigns) do
    ElixirconfEuWeb.TetrisView.render("tetris-game.html", assigns)
  end

end
