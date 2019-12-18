defmodule Tetris.Core.Board_test do
  use ExUnit.Case
  alias Tetris.Core.{Board, Shape}

  describe "new board properties" do

    test "width and height" do
      board = Board.new()

      assert board.width == 100
      assert board.height == 50
    end

    test "indexor and lanes" do
      board = Board.new()
      assert board.lanes == %{}
    end

    test "no occpied lanes initially" do
      board = Board.new()
      assert board.indexor == %{}
    end

  end

  describe "add shape to board" do

    test "ignoring rules" do
      board = Board.new()
      shape_at_custom_position = Shape.new(:s_shape)
      custom_pos_coords = {20, 40}

      shape_added_board = Board.add_shape(board, shape_at_custom_position, custom_pos_coords)

      refute board.empty_lane_ids == shape_added_board.empty_lane_ids
    end

    test "no duplicate filled lanes" do
      board = Board.new()
      shape = Shape.new(:l_shape)
      custom_position_coordinates = {10, 70}

      shape_added_board = Board.add_shape(board, shape, custom_position_coordinates)

      indexor_count = shape_added_board.indexor
      |> Map.values
      |> length

      uniq_indexor_count = shape_added_board.indexor
      |> Map.values
      |> Enum.uniq
      |> length

      assert indexor_count == uniq_indexor_count
    end

    test "disallow add if the tiles on board are already solid" do
      board = Board.new()
      shape = Shape.new(:l_shape)
      custom_position_coordinates = {10, 70}

      shape_added_board = Board.add_shape(board, shape, custom_position_coordinates)
    end

  end

  describe "tile occupied check" do
    test "single tile check" do
      board = Board.new()
      shape_at_custom_position = Shape.new(:l_shape)
      {x_coordinate, y_coordinate} = {10, 70}

      shape_added_board = Board.add_shape(board, shape_at_custom_position, {x_coordinate, y_coordinate})

      shape_coordinate = {10, 70}

      far_coordinate = {9,12}
      near_coordinate = {11,72}

      assert Board.check_tile_slot_empty(shape_added_board, far_coordinate) == true
      assert Board.check_tile_slot_empty(shape_added_board, near_coordinate) == false
    end

    test "get occupied tile of shape" do
      board = Board.new()
      shape_at_custom_position = Shape.new(:l_shape)
      {x_coordinate, y_coordinate} = {10, 70}

      shape_added_board = Board.add_shape(board, shape_at_custom_position, {x_coordinate, y_coordinate})

    end

  end

  describe "decide lane matured and move down" do
    #
  end

end
