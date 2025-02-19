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
    quote do
      # Import macros from MetaProg.C2.Assertion
      import unquote(__MODULE__)

      # Demonstration: shows which module is invoking `use` (the "caller" module).
      IO.inspect(__MODULE__, label: "Caller module during `__using__` macro")

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
      @test {unquote(func_name), unquote(do_code)}
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
  defp ok(), do: :ok

  defp fail(op, lhs, rhs) do
    {:fail,
     """
     FAILURE:
     Expected: #{lhs}
     to be #{op} to: #{rhs}
     """}
  end

  # Assertion pattern matches for comparison operators
  def assert(:==, lhs, rhs) when lhs == rhs, do: ok()
  def assert(:==, lhs, rhs), do: fail("==", lhs, rhs)

  def assert(:>, lhs, rhs) when lhs > rhs, do: ok()
  def assert(:>, lhs, rhs), do: fail(">", lhs, rhs)

  def assert(:<, lhs, rhs) when lhs < rhs, do: ok()
  def assert(:<, lhs, rhs), do: fail("<", lhs, rhs)

  @doc """
  Executes each test function from the `tests` list for the given `module`.
  Prints a dot (`.`) for passed tests or a detailed message if a test fails.

      MetaProg.C2.Assertion.Test.run(@tests, __MODULE__)
  """
  def run(tests, module) do
    Enum.each(tests, fn {test_func, description} ->
      case apply(module, test_func, []) do
        :ok ->
          IO.write(".")

        {:fail, reason} ->
          IO.puts("""
          ===============================================
          FAILURE: #{description}
          ===============================================
          #{reason}
          """)
      end
    end)
  end
end
