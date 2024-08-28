defmodule ElixirLsFailureTest do
  use ExUnit.Case
  doctest ElixirLsFailure

  use ExUnit.Case
  use ExUnitProperties

  def gen_data() do
    StreamData.list_of(StreamData.fixed_map(%{
      "e" => StreamData.string(:utf8)
    }), min_length: 1, max_length: 1)
  end

  def gen_data_all() do
    gen all fixed_map <- gen_data() do
      fixed_map
    end
  end

  test "greets the world" do
    data = Enum.at(gen_data_all(), 0)
    assert ElixirLsFailure.hello() == :world
  end
end
