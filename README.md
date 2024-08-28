# ElixirLsFailure

**Reproduction Steps:**

1. Create project.

```
mix new elixir_ls_failure --sup
```

2. Add StreamData dependency.

```
defp deps do
[
  # {:dep_from_hexpm, "~> 0.3.0"},
  # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  {:stream_data, "~> 1.0", only: [:dev, :test]},
]
end
```

3. Add the following code to the default test file:

```
defmodule ElixirLsFailureTest do
  use ExUnit.Case
  doctest ElixirLsFailure

  use ExUnit.Case
  use ExUnitProperties

  def gen_data() do
    StreamData.list_of(StreamData.fixed_map(%{
      "e" => StreamData.string(:utf8)
    }), min_length: 1, max_length: 1)
  end

  def gen_data_all() do
    gen all fixed_map <- gen_data() do
      fixed_map
    end
  end

  test "greets the world" do
    data = Enum.at(gen_data_all(), 0)
    assert ElixirLsFailure.hello() == :world
  end
end
```

4. Set a breakpoint on the assert in test "greets the world".
5. Start VSCode debugging with this launch configuration:

```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "mix_task",
            "name": "chat: mix test",
            "request": "launch",
            "task": "test",
            "taskArgs": [
                "--trace"
            ],
            "startApps": true,
            "projectDir": "${workspaceRoot}",
            "requireFiles": [
                "${workspaceRoot}/test/test_helper.exs",
                "${workspaceRoot}/test/**/*_test.exs"
            ],
            "exitAfterTaskReturns": false
        }
    ]
}
```

I'm using macOS Sonoma 14.1 on an Apple M3 Max Macbook Pro 16-inch.

6. Stop debugging after 10 seconds. Look in activity monitor for the `beam.smp` process. It will take ~10-20GB. If you let the debugger run for 2-5 minutes the memory usage will spike to 60-100GB. Let it run longer and your system will run out of memory.
