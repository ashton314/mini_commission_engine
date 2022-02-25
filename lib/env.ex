defmodule Env do
  @moduledoc """
  Representation of an environment.
  """

  @type t :: %Env{
    parent: t() | nil,
    frame: %{String.t() => any()}
  }

  defstruct [:parent, :frame]

  @spec resolve(t(), String.t()) :: {:ok, any()} | {:error, String.t()}
  def resolve(env, varname) do
    case Map.fetch(env.frame, varname) do
      {:ok, val} -> {:ok, val}
      :error ->
        if env.parent, do: resolve(env.parent, varname), else: {:error, "bad var"}
    end
  end
end
