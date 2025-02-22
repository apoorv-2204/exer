defmodule MetaProg.C2.Assertion do
  @moduledoc """
  A simple DSL for assertion-based testing.

  This module leverages Elixir macros to provide:

    * `assert/1` - Asserts a relationship between two values (e.g., `lhs == rhs`, `lhs > rhs`).
    * `test/2`  - Defines test functions that are stored in the `@tests` attribute.
    * `__using__/1` - Sets up the caller module so it can use the DSL macros and
      automates a `@before_compile` hook to inject a `run/0` function for running tests.

  ## Key Points

  1. **`__MODULE__` (Inside a Macro Module)**
     - Within this file (the **macro-defining** module), `__MODULE__` refers to `MetaProg.C2.Assertion`.
     - So, `unquote(__MODULE__)` literally inserts `MetaProg.C2.Assertion` into the quoted code at compile time.

  2. **`__CALLER__.module` (Caller Module)**
     - When you're inside a macro and you want the **name of the module** that is calling the macro, you can use `__CALLER__.module`.
     - In this DSL, we don't need `__CALLER__.module` directly because we register attributes and do `@before_compile` in the caller module context using `quote` blocks.

  3. **`@before_compile`**
     - `@before_compile SomeModule` tells Elixir to invoke `SomeModule.__before_compile__/1` as a macro in the **caller** module’s context **just before** the caller finishes compiling.
     - In this code, we do `@before_compile unquote(__MODULE__)` so that **Elixir** will call `MetaProg.C2.Assertion.__before_compile__/1` in the **caller**’s context. That’s how we inject a `run/0` function into the caller module automatically.

  4. **Why `unquote(__MODULE__)` Instead of `__CALLER__.module`?**
     - We must reference **the module that actually defines** the `__before_compile__/1` macro, which is `MetaProg.C2.Assertion`.
     - If we used `@before_compile __CALLER__.module`, Elixir would look for `__before_compile__/1` in the caller module (which doesn’t have one) and fail.

  ### Example

      defmodule MyTests do
        use MetaProg.C2.Assertion

        test "2 is greater than 1" do
          assert 2 > 1
        end

        test "3 is not less than 2" do
          assert 3 < 2  # This will fail
        end
      end

      MyTests.run()

  You’ll see `.` for passing tests and a failure report for any failing test.

  """
  defmacro refute({operator, context, [lhs, rhs]}) do
    quote bind_quoted: [op: operator, ctx: context, lhs: lhs, rhs: rhs] do
      MetaProg.C2.Assertion.Test.assert(op, lhs, rhs)
      |> Kernel.==(false)
      |> MetaProg.C2.Assertion.Test.wrap_result(op, lhs, rhs)
    end
  end

  # ------------------------------------------------------------------
  # MACRO: assert/1
  # ------------------------------------------------------------------
  @doc """
  Asserts a relationship between two values.

  It pattern matches against the AST form: `assert lhs <operator> rhs`.

  Internally calls `MetaProg.C2.Assertion.Test.assert/3` with the operator
  (`:==`, `:>`, or `:<`) and the left/right operands.

  **Important**: This macro only accepts expressions of the form
  `lhs <operator> rhs`. Other uses (e.g., `assert some_value`) won't match
  and will raise a compile error.
  """
  defmacro assert({operator, context, [lhs, rhs]}) do
    quote bind_quoted: [op: operator, ctx: context, lhs: lhs, rhs: rhs] do
      MetaProg.C2.Assertion.Test.assert(op, lhs, rhs)
      |> MetaProg.C2.Assertion.Test.wrap_result(op, lhs, rhs)
    end
  end

  # ------------------------------------------------------------------
  # MACRO: __using__/1
  # ------------------------------------------------------------------
  @doc """
  When you do:

      use MetaProg.C2.Assertion

  This macro:

    * Imports the macros (`assert/1` and `test/2`) from this module.
    * Registers an attribute `@tests` in the caller module (accumulates all tests).
    * Sets a `@before_compile` hook so we can inject a `run/0` function later.

  **Note**: The `IO.inspect(__MODULE__)` call here shows the **caller** module
  during the macro expansion of `use MetaProg.C2.Assertion`. That is,
  if the caller is `MyTests`, it will display `MyTests`.
  """
  defmacro __using__(_env) do
    # its a varaible rep ast
    quote do
      # Import macros from MetaProg.C2.Assertion
      import unquote(__MODULE__)

      # Demonstration: shows which module is invoking `use` (the "caller" module).
      # IO.inspect(__MODULE__, label: "Caller module during `__using__` macro")
      # IO.inspect(unquote(__MODULE__), label: "unquote(__MODULE__) `__using__` macro")

      # Register an attribute `:tests` in the caller, accumulative for all test definitions.
      Module.register_attribute(__MODULE__, :tests, accumulate: true)

      # Specifies that, before the caller finishes compiling,
      # Elixir should call `MetaProg.C2.Assertion.__before_compile__/1`.
      @before_compile unquote(__MODULE__)
    end
  end

  # ------------------------------------------------------------------
  # MACRO: __before_compile__/1
  # ------------------------------------------------------------------
  @doc """
  This macro is invoked just before the caller’s module is fully compiled.

  It injects a `run/0` function into the caller module, which delegates
  to `MetaProg.C2.Assertion.Test.run/2` using the accumulated `@tests`.

  **Inside this `quote`**, `__MODULE__` now refers to the **caller** module
  (because we’re injecting code back into the caller).
  """
  defmacro __before_compile__(_env) do
    # IO.inspect("__before_compile__")

    quote do
      def run, do: MetaProg.C2.Assertion.Test.run(@tests, __MODULE__)
    end
  end

  # ------------------------------------------------------------------
  # MACRO: test/2
  # ------------------------------------------------------------------
  @doc """
  Defines a test with the given `desc` (description) and a `do` block.

  The macro:
    * Converts `desc` to a function name (atom).
    * Registers `{function_name, do_block_ast}` in the caller’s `@tests` attribute.
    * Defines a function with the name derived from `desc`.

  Example:

      test "some test" do
        assert 2 > 1
      end

  This creates a function `:"some test"()` and adds a corresponding
  entry to `@tests`.
  """
  defmacro test(desc, do: do_code) do
    func_name = String.to_atom(desc)

    quote do
      @tests {unquote(func_name), unquote(desc)}
      def unquote(func_name)(), do: unquote(do_code)
    end
  end
end

defmodule MetaProg.C2.Assertion.Test do
  @moduledoc """
  Handles the low-level assertion logic and runs a list of tests
  defined in the caller module.

  ## Functions

    * `assert/3` - Checks if the assertion passes or fails.
    * `run/2` - Executes all accumulated tests, printing '.' for success
      or a failure message on error.
  """

  # Simple OK/fail helpers
  defp ok(), do: {:ok, nil}

  defp fail(op, lhs, rhs) do
    {:fail,
     """
     FAILURE: Expected: #{lhs} to be #{op} to: #{rhs}
     """}
  end

  def wrap_result(false, ops, lhs, rhs), do: fail(ops, lhs, rhs)
  def wrap_result(true, _ops, _lhs, _rhs), do: ok()

  # Assertion pattern matches for comparison operators
  def assert(:==, lhs, rhs), do: Kernel.==(lhs, rhs)
  def assert(:===, lhs, rhs), do: Kernel.===(lhs, rhs)
  def assert(:!=, lhs, rhs), do: Kernel.!=(lhs, rhs)
  def assert(:!==, lhs, rhs), do: Kernel.!==(lhs, rhs)

  def assert(:>, lhs, rhs), do: Kernel.>(lhs, rhs)
  def assert(:>=, lhs, rhs), do: Kernel.>=(lhs, rhs)
  def assert(:<, lhs, rhs), do: Kernel.<(lhs, rhs)
  def assert(:<=, lhs, rhs), do: Kernel.<=(lhs, rhs)
  def assert(operator, _, _), do: raise(ArgumentError, "Unsupported operator: #{operator}")

  @doc """
  Executes each test function from the `tests` list for the given `module`.
  Prints a dot (`.`) for passed tests or a detailed message if a test fails.

      MetaProg.C2.Assertion.Test.run(@tests, __MODULE__)
  """
  def run(tests, module) do
    Enum.each(tests, fn {test_func, description} ->
      case apply(module, test_func, []) do
        {:ok, nil} ->
          IO.write(".")

        {:fail, reason} ->
          IO.puts("""
          ===============================================
          FAILURE: #{inspect(description)} #{inspect(reason)}
          ===============================================
          """)
      end
    end)
  end

  # def test() do
  #   [
  #     abstract_code:
  #       {:raw_abstract_v1,
  #        [
  #          {:attribute, 1, :file, {~c"lib/meta_prog/c2/assertion_demo.ex", 1}},
  #          {:attribute, 1, :module, MetaProg.C2.AssertionDemo},
  #          {:attribute, 1, :compile, [:no_auto_import]},
  #          {:attribute, 1, :export,
  #           [
  #             "Math test 1": 0,
  #             __info__: 1,
  #             "integers can be added and subtracted": 0,
  #             "integers can be multiplied and divided": 0,
  #             run: 0
  #           ]},
  #          {:attribute, 1, :spec,
  #           {{:__info__, 1},
  #            [
  #              {:type, 1, :fun,
  #               [
  #                 {:type, 1, :product,
  #                  [
  #                    {:type, 1, :union,
  #                     [
  #                       {:atom, 1, :attributes},
  #                       {:atom, 1, :compile},
  #                       {:atom, 1, :functions},
  #                       {:atom, 1, :macros},
  #                       {:atom, 1, :md5},
  #                       {:atom, 1, :exports_md5},
  #                       {:atom, 1, :module},
  #                       {:atom, 1, :deprecated},
  #                       {:atom, 1, :struct}
  #                     ]}
  #                  ]},
  #                 {:type, 1, :any, []}
  #               ]}
  #            ]}},
  #          {:function, 0, :__info__, 1,
  #           [
  #             {:clause, 0, [{:atom, 0, :module}], [], [{:atom, 0, MetaProg.C2.AssertionDemo}]},
  #             {:clause, 0, [{:atom, 0, :functions}], [],
  #              [
  #                {:cons, 0, {:tuple, 0, [{:atom, 0, :"Math test 1"}, {:integer, 0, 0}]},
  #                 {:cons, 0,
  #                  {:tuple, 0,
  #                   [
  #                     {:atom, 0, :"integers can be added and subtracted"},
  #                     {:integer, 0, 0}
  #                   ]},
  #                  {:cons, 0,
  #                   {:tuple, 0,
  #                    [
  #                      {:atom, 0, :"integers can be multiplied and divided"},
  #                      {:integer, 0, 0}
  #                    ]},
  #                   {:cons, 0, {:tuple, 0, [{:atom, 0, :run}, {:integer, 0, 0}]}, {nil, 0}}}}}
  #              ]},
  #             {:clause, 0, [{:atom, 0, :macros}], [], [nil: 0]},
  #             {:clause, 0, [{:atom, 0, :struct}], [], [{:atom, 0, nil}]},
  #             {:clause, 0, [{:atom, 0, :exports_md5}], [],
  #              [
  #                {:bin, 0,
  #                 [
  #                   {:bin_element, 0,
  #                    {:string, 0,
  #                     [138, 131, 105, 174, 172, 33, 82, 171, 143, 201, 37, 47, 37, 226, 88, ...]},
  #                    :default, :default}
  #                 ]}
  #              ]},
  #             {:clause, 0, [{:match, 0, {:var, 0, :Key}, {:atom, 0, :attributes}}], [],
  #              [
  #                {:call, 0, {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
  #                 [{:atom, 0, MetaProg.C2.AssertionDemo}, {:var, 0, :Key}]}
  #              ]},
  #             {:clause, 0, [{:match, 0, {:var, 0, :Key}, {:atom, 0, :compile}}], [],
  #              [
  #                {:call, 0, {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
  #                 [{:atom, 0, MetaProg.C2.AssertionDemo}, {:var, 0, :Key}]}
  #              ]},
  #             {:clause, 0, [{:match, 0, {:var, 0, :Key}, {:atom, 0, :md5}}], [],
  #              [
  #                {:call, 0, {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
  #                 [{:atom, 0, MetaProg.C2.AssertionDemo}, {:var, 0, :Key}]}
  #              ]},
  #             {:clause, 0, [{:atom, 0, :deprecated}], [], [nil: 0]}
  #           ]},
  #          {:function, 12, :"Math test 1", 0,
  #           [
  #             {:clause, 12, [], [],
  #              [
  #                {:match, 13, {:var, {74, 7}, :_@1}, {:atom, 13, :==}},
  #                {:match, 13, {:var, {74, 7}, :_@2},
  #                 {:cons, 13, {:tuple, 13, [{:atom, 13, :line}, {:integer, 13, 13}]},
  #                  {:cons, 13, {:tuple, 13, [{:atom, 13, :column}, {:integer, 13, 14}]},
  #                   {nil, 13}}}},
  #                {:match, 13, {:var, {74, 7}, :_@3}, {:integer, 13, 1}},
  #                {:match, 13, {:var, {74, 7}, :_@4}, {:integer, 13, 5}},
  #                {:call, 13,
  #                 {:remote, 13, {:atom, 13, MetaProg.C2.Assertion.Test},
  #                  {:atom, 13, :wrap_result}},
  #                 [
  #                   {:call, 13,
  #                    {:remote, 13, {:atom, 13, MetaProg.C2.Assertion.Test}, {:atom, 13, :assert}},
  #                    [{:var, 13, :_@1}, {:var, 13, :_@3}, {:var, 13, :_@4}]},
  #                   {:var, 13, :_@1},
  #                   {:var, 13, :_@3},
  #                   {:var, 13, :_@4}
  #                 ]},
  #                {:match, 14, {:var, {74, 7}, :_@5}, {:atom, 14, :===}},
  #                {:match, 14, {:var, {74, 7}, :_@6},
  #                 {:cons, 14, {:tuple, 14, [{:atom, 14, :line}, {:integer, 14, 14}]},
  #                  {:cons, 14, {:tuple, 14, [{:atom, 14, :column}, {:integer, 14, 14}]},
  #                   {nil, 14}}}},
  #                {:match, 14, {:var, {74, 7}, :_@7}, {:integer, 14, 5}},
  #                {:match, 14, {:var, {74, 7}, :_@8},
  #                 {:bin, 14, [{:bin_element, 14, {:string, 14, ~c"5"}, :default, :default}]}},
  #                {:call, 14,
  #                 {:remote, 14, {:atom, 14, MetaProg.C2.Assertion.Test},
  #                  {:atom, 14, :wrap_result}},
  #                 [
  #                   {:call, 14,
  #                    {:remote, 14, {:atom, 14, MetaProg.C2.Assertion.Test}, {:atom, 14, :assert}},
  #                    [{:var, 14, :_@5}, {:var, 14, :_@7}, {:var, 14, :_@8}]},
  #                   {:var, 14, :_@5},
  #                   {:var, 14, :_@7},
  #                   {:var, 14, :_@8}
  #                 ]},
  #                {:match, 15, {:var, {74, 7}, :_@9}, {:atom, 15, :==}},
  #                {:match, 15, {:var, {74, 7}, :_@10},
  #                 {:cons, 15, {:tuple, 15, [{:atom, 15, :line}, {:integer, 15, 15}]},
  #                  {:cons, 15, {:tuple, 15, [{:atom, 15, ...}, {:integer, ...}]}, {nil, 15}}}},
  #                {:match, 15, {:var, {74, 7}, :_@11}, {:integer, 15, 5}},
  #                {:match, 15, {:var, {74, 7}, :_@12}, {:integer, 15, 5}},
  #                {:call, 15,
  #                 {:remote, 15, {:atom, 15, MetaProg.C2.Assertion.Test},
  #                  {:atom, 15, :wrap_result}},
  #                 [
  #                   {:call, 15,
  #                    {:remote, 15, {:atom, 15, MetaProg.C2.Assertion.Test}, {:atom, 15, ...}},
  #                    [{:var, 15, :_@9}, {:var, 15, :_@11}, {:var, 15, ...}]},
  #                   {:var, 15, :_@9},
  #                   {:var, 15, :_@11},
  #                   {:var, 15, :_@12}
  #                 ]},
  #                {:match, 16, {:var, {74, 7}, :_@13}, {:atom, 16, :>}},
  #                {:match, 16, {:var, {74, 7}, :_@14},
  #                 {:cons, 16, {:tuple, 16, [{:atom, ...}, {...}]},
  #                  {:cons, 16, {:tuple, ...}, {...}}}},
  #                {:match, 16, {:var, {74, 7}, :_@15}, {:integer, 16, 2}},
  #                {:match, 16, {:var, {74, 7}, :_@16}, {:integer, 16, 0}},
  #                {:call, 16,
  #                 {:remote, 16, {:atom, 16, MetaProg.C2.Assertion.Test}, {:atom, 16, ...}},
  #                 [
  #                   {:call, 16, {:remote, ...}, [...]},
  #                   {:var, 16, :_@13},
  #                   {:var, 16, ...},
  #                   {:var, ...}
  #                 ]},
  #                {:block, 17,
  #                 [
  #                   {:match, 17, {:var, ...}, {...}},
  #                   {:match, 17, {...}, ...},
  #                   {:match, 17, ...},
  #                   {:match, ...},
  #                   {...}
  #                 ]}
  #              ]}
  #           ]},
  #          {:function, 20, :"integers can be added and subtracted", 0,
  #           [
  #             {:clause, 20, [], [],
  #              [
  #                {:match, 21, {:var, {74, 7}, :_@1}, {:atom, 21, :==}},
  #                {:match, 21, {:var, {74, 7}, :_@2},
  #                 {:cons, 21, {:tuple, 21, [{:atom, 21, :line}, {:integer, 21, 21}]},
  #                  {:cons, 21, {:tuple, 21, [{:atom, 21, :column}, {:integer, 21, 18}]},
  #                   {nil, 21}}}},
  #                {:match, 21, {:var, {74, 7}, :_@3},
  #                 {:op, {21, 14}, :+, {:integer, {21, 14}, 2}, {:integer, {21, 14}, 3}}},
  #                {:match, 21, {:var, {74, 7}, :_@4}, {:integer, 21, 5}},
  #                {:call, 21,
  #                 {:remote, 21, {:atom, 21, MetaProg.C2.Assertion.Test},
  #                  {:atom, 21, :wrap_result}},
  #                 [
  #                   {:call, 21,
  #                    {:remote, 21, {:atom, 21, MetaProg.C2.Assertion.Test}, {:atom, 21, :assert}},
  #                    [{:var, 21, :_@1}, {:var, 21, :_@3}, {:var, 21, :_@4}]},
  #                   {:var, 21, :_@1},
  #                   {:var, 21, :_@3},
  #                   {:var, 21, :_@4}
  #                 ]},
  #                {:block, 22,
  #                 [
  #                   {:match, 22, {:var, {74, 7}, :_@5}, {:atom, 22, :==}},
  #                   {:match, 22, {:var, {74, 7}, :_@6},
  #                    {:cons, 22, {:tuple, 22, [{:atom, 22, :line}, {:integer, 22, 22}]},
  #                     {:cons, 22, {:tuple, 22, [{:atom, 22, ...}, {:integer, ...}]}, {nil, 22}}}},
  #                   {:match, 22, {:var, {74, 7}, :_@7},
  #                    {:op, {22, 14}, :-, {:integer, {22, 14}, 5}, {:integer, {22, 14}, 5}}},
  #                   {:match, 22, {:var, {74, 7}, :_@8}, {:integer, 22, 10}},
  #                   {:call, 22,
  #                    {:remote, 22, {:atom, 22, MetaProg.C2.Assertion.Test},
  #                     {:atom, 22, :wrap_result}},
  #                    [
  #                      {:call, 22,
  #                       {:remote, 22, {:atom, 22, MetaProg.C2.Assertion.Test}, {:atom, 22, ...}},
  #                       [{:var, 22, :_@5}, {:var, 22, :_@7}, {:var, 22, ...}]},
  #                      {:var, 22, :_@5},
  #                      {:var, 22, :_@7},
  #                      {:var, 22, :_@8}
  #                    ]}
  #                 ]}
  #              ]}
  #           ]},
  #          {:function, 25, :"integers can be multiplied and divided", 0,
  #           [
  #             {:clause, 25, [], [],
  #              [
  #                {:match, 26, {:var, {74, 7}, :_@1}, {:atom, 26, :==}},
  #                {:match, 26, {:var, {74, 7}, :_@2},
  #                 {:cons, 26, {:tuple, 26, [{:atom, 26, :line}, {:integer, 26, 26}]},
  #                  {:cons, 26, {:tuple, 26, [{:atom, 26, :column}, {:integer, 26, 18}]},
  #                   {nil, 26}}}},
  #                {:match, 26, {:var, {74, 7}, :_@3},
  #                 {:op, {26, 14}, :*, {:integer, {26, 14}, 5}, {:integer, {26, 14}, 5}}},
  #                {:match, 26, {:var, {74, 7}, :_@4}, {:integer, 26, 25}},
  #                {:call, 26,
  #                 {:remote, 26, {:atom, 26, MetaProg.C2.Assertion.Test},
  #                  {:atom, 26, :wrap_result}},
  #                 [
  #                   {:call, 26,
  #                    {:remote, 26, {:atom, 26, MetaProg.C2.Assertion.Test}, {:atom, 26, :assert}},
  #                    [{:var, 26, :_@1}, {:var, 26, :_@3}, {:var, 26, :_@4}]},
  #                   {:var, 26, :_@1},
  #                   {:var, 26, :_@3},
  #                   {:var, 26, :_@4}
  #                 ]},
  #                {:block, 27,
  #                 [
  #                   {:match, 27, {:var, {74, 7}, :_@5}, {:atom, 27, :==}},
  #                   {:match, 27, {:var, {74, 7}, :_@6},
  #                    {:cons, 27, {:tuple, 27, [{:atom, 27, :line}, {:integer, 27, 27}]},
  #                     {:cons, 27, {:tuple, 27, [{:atom, ...}, {...}]}, {nil, 27}}}},
  #                   {:match, 27, {:var, {74, 7}, :_@7},
  #                    {:op, {27, 15}, :/, {:integer, {27, 15}, 10}, {:integer, {27, 15}, 2}}},
  #                   {:match, 27, {:var, {74, 7}, :_@8}, {:integer, 27, 5}},
  #                   {:call, 27,
  #                    {:remote, 27, {:atom, 27, MetaProg.C2.Assertion.Test},
  #                     {:atom, 27, :wrap_result}},
  #                    [
  #                      {:call, 27, {:remote, 27, {:atom, 27, ...}, {:atom, ...}},
  #                       [{:var, 27, :_@5}, {:var, 27, ...}, {:var, ...}]},
  #                      {:var, 27, :_@5},
  #                      {:var, 27, :_@7},
  #                      {:var, 27, :_@8}
  #                    ]}
  #                 ]}
  #              ]}
  #           ]},
  #          {:function, 1, :run, 0,
  #           [
  #             {:clause, [generated: true, location: 0], [], [],
  #              [
  #                {:call, 1,
  #                 {:remote, 1, {:atom, 1, MetaProg.C2.Assertion.Test}, {:atom, 1, :run}},
  #                 [
  #                   {:cons, 1,
  #                    {:tuple, 1,
  #                     [
  #                       {:atom, 1, :"integers can be multiplied and divided"},
  #                       {:tuple, 1, [{:atom, 1, :ok}, {:atom, 1, nil}]}
  #                     ]},
  #                    {:cons, 1,
  #                     {:tuple, 1,
  #                      [
  #                        {:atom, 1, :"integers can be added and subtracted"},
  #                        {:tuple, 1, [{:atom, 1, :fail}, {:bin, 1, [...]}]}
  #                      ]},
  #                     {:cons, 1,
  #                      {:tuple, 1, [{:atom, 1, :"Math test 1"}, {:tuple, 1, [{...}, ...]}]},
  #                      {nil, 1}}}},
  #                   {:atom, 1, MetaProg.C2.AssertionDemo}
  #                 ]}
  #              ]}
  #           ]}
  #        ]}
  #   ]
  # end
end
