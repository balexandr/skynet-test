defmodule SkynetWeb.TerminatorController do
  @moduledoc """
  Module for the API calls

  Helpful Copy/Paste
    - curl -X POST http://localhost:4000/api/terminator/build
    - curl -X DELETE http://localhost:4000/api/terminator/kill/1
    - curl -X GET http://localhost:4000/api/terminators
  """

  use SkynetWeb, :controller

  alias Skynet.Server, as: Server

  def get_terminators(conn, _) do
    terminators = Server.get_terminators()

    conn
    |> put_status(200)
    |> json(%{terminators: terminators, count: length(terminators)})
  end

  def build_terminator(conn, _) do
    Server.build_terminator()

    conn
    |> put_status(200)
    |> json(%{message: "Terminator online..."})
  end

  def kill_terminator(conn, %{"id" => id}) do
    stringify_id = String.to_integer(id)

    if is_integer(stringify_id) do
      Server.kill_terminator(id)

      conn
      |> put_status(200)
      |> json(%{message: "Destroyed terminator with Serial No. #{id}"})
    else
      conn
      |> put_status(400)
      |> json(%{message: "Can't find terminator!"})
    end
  end
end
