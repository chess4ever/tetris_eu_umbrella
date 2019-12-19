defmodule  ElixirconfEuWeb.Tetris.Index do
  use Phoenix.LiveView
  # alias Tetris.{Tile, Game, Shape}
  alias Tetris.Core.{Board, Game, Shape}

  def mount(_session, socket) do
    {:ok, game_session_pid} = Tetris.start_game_session(%{listener_pid:  self()})

    new_socket = generate_socket_from_state(socket, :sys.get_state(game_session_pid))
    |> assign(:game_id, game_session_pid)


    # IO.puts inspect(:sys.get_state(game_session_pid))

    # IO.puts inspect(game_session_pid)
    # IO.puts inspect(:sys.get_state(game_session_pid))

    # IO.puts "game sess id and ^^^ game id"
    # # # |> assign(:game_id, game_session_pid)

    {:ok, new_socket}
  end

  def handle_event({:state_change, new_state}, socket) do

    IO.puts "hanle event"
    {:noreply, socket}
  end

  # def handle_info(msg, state) do
  #   # Logger.error("Unhandled message -> module: #{__MODULE__}, msg: #{inspect msg}, state: #{inspect state}")

  #   IO.puts " msg is "
  #   IO.puts inspect(msg)

  #   {:noreply, state}
  # end

  def handle_info({:state_change, new_state}, socket) do

    IO.puts "staet changesd..... response"

    # game_session_id = socket.assigns.game_session_pid
    {:noreply, generate_socket_from_state(socket, new_state)}
    # {:noreply, socket}
  end

  def handle_event("tetris", "rotate", socket) do
    game_session_id = socket.assigns.game_id
    Tetris.rotate(game_session_id)
    {:noreply, socket}
  end

  def handle_event("move", %{"code" => key}, socket) do
    game_session_id = socket.assigns.game_id
    # game_session_id = socket.assigns.state_change_listener

    case key do
      "ArrowRight" -> Tetris.move(game_session_id, :right)
      # "ArrowRight" -> Process.send(game_session_id, {:move, :right}, [])
      "ArrowLeft" -> Tetris.move(game_session_id, :left)
      _ -> nil
    end
    {:noreply, socket}
  end

  # generate_socket
  defp generate_socket_from_state(socket, game) do
    # game = :sys.get_state(game_session)

    # IO.puts "*******************"
    # IO.puts inspect(game)

    assign(socket,
      game_over: game.game_over,
      board: game.board,
      active_shape: game.active_shape,
      # game_id: game.game_id,
      state_change_listener: game.state_change_listener,
      score: game.score,
      game_over: game.game_over,
      offset_x: game.offset_x,
      offset_y: game.offset_y,
      lane_1: Board.display_lane_tiles(game.board, 1),
      lane_2: Board.display_lane_tiles(game.board, 2),
      lane_3: Board.display_lane_tiles(game.board, 3),
      lane_4: Board.display_lane_tiles(game.board, 4),
      lane_5: Board.display_lane_tiles(game.board, 5),
      lane_6: Board.display_lane_tiles(game.board, 6),
      lane_7: Board.display_lane_tiles(game.board, 7),
      lane_8: Board.display_lane_tiles(game.board, 8),
      lane_9: Board.display_lane_tiles(game.board, 9),
      player_name: "somebody",
      new_game: true,
      speed: 600
    )

  end


  ##################### old code to remove ###################

  defp initial_stated(socket) do
    game = Game.new(%{})
    shape = Shape.new(:l_shape)
    custom_position_coordinates = {2, 5}
    shape_added_board = Board.add_shape(game.board, shape, custom_position_coordinates)
    game = %Game{game | board: shape_added_board}

    assign(socket,
      # game: game,
      game_over: game.game_over,
      board: game.board,
      active_shape: game.active_shape,
      score: game.score,
      game_over: game.game_over,
      offset_x: game.offset_x,
      offset_y: game.offset_y,
      lane_1: Board.display_lane_tiles(game.board, 1),
      lane_2: Board.display_lane_tiles(game.board, 2),
      lane_3: Board.display_lane_tiles(game.board, 3),
      lane_4: Board.display_lane_tiles(game.board, 4),
      lane_5: Board.display_lane_tiles(game.board, 5),
      lane_6: Board.display_lane_tiles(game.board, 6),
      lane_7: Board.display_lane_tiles(game.board, 7),
      lane_8: Board.display_lane_tiles(game.board, 8),
      lane_9: Board.display_lane_tiles(game.board, 9),
      # shape_names: game.shape_names,
      # board: game.board,
      player_name: "somebody",
      new_game: true,
      speed: 600
    )
  end

  defp restart_game(socket, game_mode) do
    game = Game.new(game_mode)

    assign(socket,
      # game: game,
      score: game.score,
      active_shape: game.active_shape,
    )
  end

  def render(%{new_game: true} = assigns) do
    # IO.puts inspect(assigns)
    ElixirconfEuWeb.TetrisView.render("tetris-game.html", assigns)
  end


  def handle_event("game_submit", %{
        "player-name" => player_name,
        "game-mode" => game_mode} = form, socket) do
    mode = String.to_atom(game_mode)
    game = Game.new(mode)

    #config maintaintains game board


    {:noreply,
     assign(socket,
       player_name: player_name,
       board: game.board,
       active_shape: game.active_shape,
       score: game.score,
       # game: game,
       game_over: game.game_over,
       speed: game.speed,
       new_game: false
     )
    }
  end

end
