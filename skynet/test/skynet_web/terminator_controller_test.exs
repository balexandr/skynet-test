defmodule SkynetWeb.TerminatorControllerTest do
  use SkynetWeb.ConnCase

  alias Skynet.Server, as: Server

  describe "API routes" do
    test "POST - builds a terminator", %{conn: conn} do
      conn = post(conn, "/api/terminator/build")

      assert conn.status == 200
    end

    test "DELETE - kills a terminator and returns success", %{conn: conn} do
      Server.build_terminator()
      conn = get(conn, "/api/terminators")

      terminator = List.first(Jason.decode!(conn.resp_body)["terminators"])
      kill_id = "#{terminator["id"]}"

      conn = delete(conn, "/api/terminator/kill/#{kill_id}")

      assert conn.status == 200
    end

    test "GET - returns all terminators", %{conn: conn} do
      Server.build_terminator()
      Server.build_terminator()
      Server.build_terminator()
      Server.build_terminator()

      conn = get(conn, "/api/terminators")

      assert conn.status == 200
      assert conn.resp_body
    end
  end
end
