defmodule InteractiveTetris.RotatorTest do
  use ExUnit.Case, async: true

  alias InteractiveTetris.Rotator

  test "allows rotations in multiples of 90" do
    assert Rotator.rotate([[1]], 0)   == [[1]]
    assert Rotator.rotate([[1]], 90)  == [[1]]
    assert Rotator.rotate([[1]], 180) == [[1]]
    assert Rotator.rotate([[1]], 270) == [[1]]
    assert Rotator.rotate([[1]], 360) == [[1]]
    assert Rotator.rotate([[1]], 450) == [[1]]
    assert Rotator.rotate([[1]], 540) == [[1]]

    assert_raise ArgumentError, fn ->
      Rotator.rotate([[1]], 10)
    end

    assert_raise ArgumentError, fn ->
      Rotator.rotate([[1]], 80)
    end
  end

  test "rotates the bar" do
    bar = [[1, 1, 1, 1]]
    assert Rotator.rotate(bar, 0)   == [[1, 1, 1, 1]]
    assert Rotator.rotate(bar, 90)  == [[1], [1], [1], [1]]
    assert Rotator.rotate(bar, 180) == [[1, 1, 1, 1]]
    assert Rotator.rotate(bar, 270) == [[1], [1], [1], [1]]
    assert Rotator.rotate(bar, 360) == [[1, 1, 1, 1]]
  end

  test "rotates the tee" do
    tee = [[1, 1, 1],
           [0, 1, 0]]
    assert Rotator.rotate(tee, 0) == [[1, 1, 1],
                                      [0, 1, 0]]
    assert Rotator.rotate(tee, 90) == [[0, 1],
                                       [1, 1],
                                       [0, 1]]
    assert Rotator.rotate(tee, 180) == [[0, 1, 0],
                                        [1, 1, 1]]
    assert Rotator.rotate(tee, 270) == [[1, 0],
                                        [1, 1],
                                        [1, 0]]
    assert Rotator.rotate(tee, 360) == [[1, 1, 1],
                                        [0, 1, 0]]
  end
end
