defmodule Tetris.Boundary.BoardManager do

  alias Tetris.Core.{Board, Shape}

  def add(%Board{
        lanes: board_lanes
                } = board,
    %Shape{
      color: shape_color,
      coordinates: coordinates
    } = shape,
    {offset_x, offset_y}
  ) do

    tiles = Enum.map(coordinates, fn {x,y} -> {x + offset_x, y + offset_y} end)

    board = add_tiles_to_board(board, tiles, shape_color)

    {:ok, board}
  end

  def add_tiles_to_board(board, tiles, color) do
    Enum.reduce(tiles, board, fn tile, acc_board -> add_tile_to_board(acc_board, tile, color ) end)
  end

  def add_tile_to_board(board, {x, y} = tile, color) do

    {remaining_empty_lanes, u_indexor, u_lanes} = if Map.has_key?(board.indexor, y) do

      lane_key = board.indexor[y]
      y_lane = board.lanes[lane_key]
      y_lane_added = Map.put(y_lane, x, color)
      updated_lanes = Map.put(board.lanes, lane_key, y_lane_added)

      {board.empty_lane_ids, board.indexor, updated_lanes}
    else
      [first | remaining_empty_lanes] = board.empty_lane_ids

      updated_indexor = Map.put(board.indexor, y, first)
      updated_lanes = Map.put(board.lanes, first, %{x => color})

      {remaining_empty_lanes, updated_indexor, updated_lanes}
    end


    %Board{
      board | indexor: u_indexor,
      lanes: u_lanes,
      empty_lane_ids: remaining_empty_lanes
    }
  end

end
