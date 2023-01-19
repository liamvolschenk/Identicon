defmodule Identicon do
  @moduledoc """
  This module provides methods to create and save an identicon image based on an input string

  Run the following to generate an Identicon:

        ## Examples

        iex> Identicon.main("banana")

Your identicon will be saved in the "identicons" folder.
  """

  @doc """
  The main method to put all the below methods together using the pipe operator

      ## Examples

        iex> Identicon.main("banana")
        :ok
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Take the image and input and write to the file system as a png file using the input as the image name.
  The image is being saved to the "identicons directory, which is also being created here.

  """

  def save_image(image, input) do
    File.mkdir("identicons")
    File.write("identicons/#{input}.png", image)
  end

  @doc """
  Use the Erlang :egd module to create the actual image.
  :egd.create creates an image that is 250x250px in size
  :egd.color then takes the color from the struct and uses it as the fill colour
  Then map over each element in the pixel map and use :egd.filledRectangle to draw a filled in rectangle/square on the image
  using the start and stop co-ordinates from the pixel map and fill color.
  Lastly, :egd.render renders the image

  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
  Create a pixel map out of a list of tuples,
  each tuple contains the top-left and bottom-right coordinates of a 50x50 pixels square representing a pixel of the Identicon.
  Then return the pixel map in the Identicon.Image struct

  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Filter out the elements with out numbers, so that we know which squares to colour in
  Then return the updated grid in the Identicon.Image struct

  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code ,2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Create the grid from the list of elements

  Use Enum.chunk_every/3 to break the hex list into chunks of 3 elements, and discard any remaining elements.
  Then use the mirror_row function to to mirror first two elements after third.
  Then flatten the list and add an index to each element
  Then store the grid in the Identicon.Image struct

  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image {image | grid: grid}
  end

  @doc """
  Take the first two elements from the row, discard the rest.
  Then append the numbers in order: second, then first at the end of the row in order to create a mirrored row.

  """
  def mirror_row(row) do
    # [145, 46, 200]
    [first, second | _tail] = row

    # [145, 46, 200, 46, 145]
    row ++ [second, first]
  end

   @doc """
    Take the first three values from the hex amd use them as the RGB values
    Then store the rgb values/color in the Identicon.Image struct

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Generate an md5 hash of an inputm then use the :binary module to convert the binary data to a list of ints.
    Then store the list/hex in the Identicon.Image struct

  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
