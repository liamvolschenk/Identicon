defmodule Identicon.Image do
  @moduledoc """
  A struct to store all the necessary data (hex, color, grid and pixel map) to be used in the Identicon image

  """

  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
