defmodule MiniCommissionEngine do
  @moduledoc """
  Documentation for `MiniCommissionEngine`.
  """

  def eval([:e_int, num], _env), do: num
  def eval([:e_float, float], _env), do: float
  def eval([:e_string, str], _env), do: str

  def eval([:e_var, varname], env) do
    {:ok, val} = Env.resolve(env, varname)
    val
  end

  def eval([:e_binop, op, [arg1, arg2]], env) do
    val1 = eval(arg1, env)
    val2 = eval(arg2, env)

    case op do
      :add -> val1 + val2
      :sub -> val1 - val2
      :mult -> val1 * val2
      :div -> val1 / val2
    end
  end

  def eval([:e_funcall, {:e_var, "max"}, [arg1, arg2]], env) do
    val1 = eval(arg1, env)
    val2 = eval(arg2, env)
    if val1 > val2, do: val1, else: val2
  end

  def eval([:e_funcall, {:e_var, "min"}, [arg1, arg2]], env) do
    val1 = eval(arg1, env)
    val2 = eval(arg2, env)
    if val1 < val2, do: val1, else: val2
  end

  def eval([:e_funcall, {:e_var, "let"}, [{:e_var, varname}, val, body]], env) do
    real_val = eval(val, env)
    new_env = %Env{parent: env, frame: %{varname => real_val}}
    eval(body, new_env)
  end
end
