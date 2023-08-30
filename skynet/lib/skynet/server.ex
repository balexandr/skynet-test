defmodule Skynet.Server do
  @moduledoc """
  Module that utilizes OTP to handle the creation and destruction of terminators.

  When Skynet goes online, it builds the first terminator then sets off two sets of recurrsion functions
  that will reproduce (20% chance every 5 seconds) or kill (25% chance every 10 seconds) terminators.

  If for whatever reason, Sarah ends up killing all the terminators early in the process,
  there's a condition that creates a new one as to not disrupt the process.

  Helpful Copy/Paste
    - Skynet.Server.build_terminator()
    - Skynet.Server.kill_terminator(1)
    - Skynet.Server.get_terminators()
  """
  use GenServer

  @spec start_link(_opts :: any) :: {:ok, pid} | {:error, term}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  @spec init(any) :: {:ok, any}
  def init(terminators) do
    IO.inspect("Skynet is online...")

    build_terminator()
    maybe_reproduce()
    maybe_kill()
    {:ok, terminators}
  end

  @spec build_terminator() :: :ok
  def build_terminator() do
    GenServer.cast(__MODULE__, :build)
  end

  @spec kill_terminator(integer()) :: :ok
  def kill_terminator(id) do
    GenServer.cast(__MODULE__, {:kill, id})
  end

  @spec get_terminators() :: [map()]
  def get_terminators() do
    GenServer.call(__MODULE__, :get_terminators)
  end

  @impl true
  @spec handle_cast(:build, [map()]) :: {:noreply, [map()]}
  def handle_cast(:build, terminators) do
    {:noreply, terminators ++ [default_terminator()]}
  end

  @spec handle_cast({:kill, integer()}, [map()]) :: {:noreply, [map()]}
  def handle_cast({:kill, kill_id}, terminators) do
    {:noreply, Enum.reject(terminators, fn %{id: id} -> id == kill_id end)}
  end

  @impl true
  @spec handle_call(:get_terminators, any, [map()]) :: {:reply, [map()], [map()]}
  def handle_call(:get_terminators, _from, terminators) do
    {:reply, terminators, terminators}
  end

  @impl true
  @spec handle_info(:reproduce, [map()]) :: {:noreply, [map()]}
  def handle_info(:reproduce, terminators) do
    new_terminators =
      Enum.reduce(terminators, terminators, fn _terminator, acc ->
        if :rand.uniform() <= 0.2 do
          acc ++ [default_terminator()]
        else
          acc
        end
      end)

    new_terminators =
      if length(new_terminators) < 1 do
        IO.inspect("How'd she kill us all, create another!")
        [default_terminator()]
      else
        new_terminators
      end

    maybe_reproduce()
    {:noreply, new_terminators}
  end

  @impl true
  @spec handle_info(:kill, [map()]) :: {:noreply, [map()]}
  def handle_info(:kill, terminators) do
    new_terminators =
      Enum.reduce(terminators, [], fn terminator, acc ->
        if :rand.uniform() <= 0.25 do
          acc
        else
          acc ++ [terminator]
        end
      end)

    maybe_kill()
    {:noreply, new_terminators}
  end

  ###########
  # Private #
  ###########

  defp maybe_reproduce() do
    Process.send_after(self(), :reproduce, 5000)
  end

  defp maybe_kill() do
    Process.send_after(self(), :kill, 10000)
  end

  defp default_terminator() do
    %{id: :erlang.unique_integer([:positive]), name: "Uncle Bob"}
  end
end
