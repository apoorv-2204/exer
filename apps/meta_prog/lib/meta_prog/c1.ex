defmodule MetaProg.C1 do
  @moduledoc false
  require Logger

  defmodule Notifier do
    def ping(pid) do
      if Process.alive?(pid) do
        Logger.debug("Sending ping!")
        send(pid, :ping)
      end
    end
  end
end

defmodule Math do
  @moduledoc """
    # r ="/home/apoorv_pca/Documents/elixir/exer/apps/meta_prog/lib/meta_prog/c1/instance.exs"
  # AST
  # Every expression you write in Elixir breaks down to a three-element tuple in the AST.
  # iex(3)>  quote do: (5 * 2) - 1 + 7
  # {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
  #  [
  #    {:-, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
  #     [{:*, [context: Elixir, imports: [{2, Kernel}]], [5, 2]}, 1]},
  #    7
  #  ]}
  # {:+, [context:],  [ {:-, [context:], [{:*, [context:], [5, 2]}, 1]},    7  ]}
  # { node/operator, context, L,Rhs}  # r ="/home/apoorv_pca/Documents/elixir/exer/apps/meta_prog/lib/meta_prog/c1/instance.exs"
  # AST
  # Every expression you write in Elixir breaks down to a three-element tuple in the AST.
  # iex(3)>  quote do: (5 * 2) - 1 + 7
  # {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
  #  [
  #    {:-, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
  #     [{:*, [context: Elixir, imports: [{2, Kernel}]], [5, 2]}, 1]},
  #    7
  #  ]}
  # {:+, [context:],  [ {:-, [context:], [{:*, [context:], [5, 2]}, 1]},    7  ]}
  # { node/operator, context, L,Rhs}
  """
  # macro takes an ast and returns an ast
  # incoming variables as part of ast cant be used directly they need to unquoted if you want to do operation on incoming ast variables.variibles whihc where in the original code
  defmacro say({operator, ctx, [lhs, rhs]}) do
    # quote returns ast
    quote do
      IO.inspect(unquote(ctx))
      # you cant use lhs directly you need to unquote
      #
      # iex(17)> Math.say 5+2
      # error: undefined variable "lhs" (context Math)
      # └─ iex:17
      #
      # IO.inspect(lhs)
      IO.inspect(unquote(lhs))
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = apply(Kernel, unquote(operator), [lhs, rhs])
      IO.puts("#{lhs} plus #{} is #{result}")
      result
    end
  end
end

defmodule AST do
  @moduledoc """



  """
  @doc """
  iex(5)> AST.run
    {:defmodule, [context: AST, imports: [{2, Kernel}]],
    [
      {:__aliases__, [alias: false], [:MyModule]},
      [
        do: {:def, [context: AST, imports: [{1, Kernel}, {2, Kernel}]],
          [{:hello, [context: AST], AST}, [do: "World"]]}
      ]
    ]}
  a stacking tuple was produced from each quoted expression.
  iex(6)> quote do: Kernel.+(5,2)
  {{:., [], [{:__aliases__, [alias: false], [:Kernel]}, :+]}, [], [5, 2]}
  """
  def run() do
    quote do
      defmodule MyModule do
        def hello, do: "World"
      end
    end
  end
end

defmodule ControlFlow do
  @moduledoc """
  You can think of quote/unquote as string interpolation for code. If you were
  building up a string and needed to inject the value of a variable into that
  string, you would interpolate it. The same goes when constructing an AST.
  We use quote to begin generating an AST and unquote to inject values from an
  outside context. This allows the outside bound variables, expression and block,
  to be injected directly into our if ! transformation
  """
  defmacro not_if(expression, do: block) do
    quote do
      if !unquote(expression) do
        unquote(block)
      end
    end
  end

  defmacro unless(expression, do: block) do
    quote do
      if !unquote(expression), do: unquote(block)
    end
  end
end

defmodule MacroTest do
  @moduledoc """
  defmodule ASTComparison do
  def t1 do
    number = 5

    ast = quote do
      unquote(number) * 10
    end

    IO.inspect(ast)
  end

  def t2 do
    number = 5

    ast =
      quote do
        unquote(number * 10)
      end

    IO.inspect(ast)
  end
  end

  # ┌──────────────────────┬────────────────────────────────────────────┬──────────────────────────────┐
  # │        Feature       │ First Snippet (`unquote(number) * 10`)    │ Second Snippet (`unquote(number * 10)`) │
  # ├──────────────────────┼────────────────────────────────────────────┼──────────────────────────────┤
  # │ Evaluation Timing    │ `number` is injected into the AST and      │ `number * 10` is evaluated  │
  # │                      │ multiplication remains in AST              │ **before** `quote`, so only `50` remains │
  # ├──────────────────────┼────────────────────────────────────────────┼──────────────────────────────┤
  # │ AST Representation  │ `{:*, [], [5, 10]}` (captures multiplication) │ `50` (captures only the literal value) │
  # ├──────────────────────┼────────────────────────────────────────────┼──────────────────────────────┤
  # │ AST Structure       │ Expression remains as an operation (`*`)    │ Only a literal number is inside AST │
  # └──────────────────────┴────────────────────────────────────────────┴──────────────────────────────┘
  #
  # Summary:
  # - In the first case, `unquote(number)` injects `5`, so AST still contains `5 * 10` as an operation.
  # - In the second case, `number * 10` evaluates **before** `quote`, so AST only contains `50`.

  """
  require ControlFlow

  def test() do
    unless 5 != 5 do
      "block entered"
    end
  end

  def t2 do
    number = 5

    ast =
      quote do
        unquote(number * 10)
      end

    IO.inspect(ast)

    Code.eval_quoted(ast)
    |> IO.inspect()

    # - {50, []}
  end

  def t3 do
    ast =
      quote do
        ControlFlow.unless(2 == 5, do: "block entered")
      end

    IO.inspect(ast)
    expanded_once = Macro.expand_once(ast, __ENV__)
    IO.inspect(expanded_once)
    expanded_twice = Macro.expand_once(expanded_once, __ENV__)

    IO.inspect(expanded_twice)

    Macro.expand_once(expanded_twice, __ENV__)
    |> Macro.expand_once(__ENV__)
    |> Macro.expand_once(__ENV__)
    |> Macro.expand_once(__ENV__)

    # will not expand further
  end
end

defmodule Context do
  defmacro definfo do
    IO.puts("In macro's context (#{__MODULE__}).")

    quote do
      IO.puts("In caller's context (#{__MODULE__}).")

      def friendly_info do
        IO.puts("""
        My name is #{__MODULE__}
        My functions are #{inspect(__MODULE__.__info__(:functions))}
        """)
      end

      # om shree namah
    end
  end
end

defmodule ContextDemo do
  @moduledoc """

  """

  require Context

  Context.definfo()
end

defmodule Setter do
  defmacro fail_bind_name(string) do
    quote do
      name = unquote(string)
    end
  end

  defmacro sucess_bind_name(string) do
    quote do
      var!(name) = unquote(string)
    end
  end
end

defmodule Hygiene do
  @moduledoc """
  Elixir has the concept of macro hygiene. Hygiene means that variables,
  imports, and aliases that you define in a macro do not leak into the caller’s
  own definitions. We must take special consideration with macro hygiene when
  expanding code, because sometimes it is a necessary evil to implicitly access
  the caller’s scope in an unhygienic way.

  This safeguard not only prevents accidental namespace clashes, but also
  requires us to be explicit about reaching into the caller’s context.

  defining   or accessing variables between different contexts

  """

  @doc """
  meaning_to_life wasn’t available in the scope of our expression, even though it
  was passed as a binding to Code.eval_quoted. Elixir takes the safe approach of
  requiring you to explicitly allow a macro to define bindings in the caller’s
  context. This design forces you to think about whether violating hygiene is
  necessary
  """
  def t1() do
    ast =
      quote do
        if meaning_to_file == 42 do
          "its _true"
        else
          "it remains to be seen"
        end
      end

    Code.eval_quoted(ast, meaning_to_file: 42)

    # iex(2)> Hygiene.t1
    # error: undefined variable "meaning_to_file" (context Hygiene)
    # └─ nofile:1

    # ** (CompileError) cannot compile code (errors have been logged)

    # iex(2)>
  end

  @doc """
  We can use the var! macro to explicitly override hygiene within a quoted
  expression

  if we wnat to access variable of callerrs contest we need to user var!,
  if something was not passed as part of macro
  """
  def t2() do
    ast =
      quote do
        if var!(meaning_to_file) == 42 do
          "its _true"
        else
          "it remains to be seen"
        end
      end

    Code.eval_quoted(ast, meaning_to_file: 42)
    # iex(3) > Hygiene.t2()
    # {"its _true", [meaning_to_file: 42]}
  end

  @doc """
  By using var!, we were able to override hygiene to rebind name to a new value.
  Overriding hygiene is useful on a case-by-case basis.

  should be avoided where possible
  because it can mask implementation details and add implicit behavior that
  is unknown to the caller.
  acros, it’s important to be aware of what context a macro
  is executing in and to respect hygien
  """
  def t3() do
    require Setter
    name = "ehllo"

    Setter.fail_bind_name(:yo)
    IO.inspect(name)

    Setter.sucess_bind_name(:sucess)
    IO.inspect(name)
  end
end
