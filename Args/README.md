# Args

> This guide explains handling command-line arguments in Bash scripts using positional parameters, special variables, and quoting techniques.

When writing Bash scripts, handling command-line arguments efficiently is crucial. You can access each argument by its position (`$1`, `$2`, …), but when the number of parameters varies, special variables like `$@` and `$*` simplify your logic. This guide covers:

* Positional parameters
* Grouping arguments
* Iterating with `"$@"` vs `"$*"`
* The impact of quoting
* Customizing the internal field separator (IFS)
* Compatibility considerations

***

## 1. Positional Parameters: `$1`, `$2`, …

By default, Bash assigns each argument to a numbered variable:

```bash theme={null}
#!/usr/bin/env bash
firstarg=$1
secondarg=$2

echo "First argument: ${firstarg}"
echo "Second argument: ${secondarg}"
```

```bash theme={null}
$ ./simple-args.sh "arg1"
First argument: arg1
Second argument:

$ ./simple-args.sh "arg1" "arg2"
First argument: arg1
Second argument: arg2
```

When you need to accept an unpredictable number of parameters, indexing each one becomes cumbersome. That’s where `$@` and `$*` come in.

***

## 2. Grouping All Arguments: `$@` vs `$*`

Both `$@` and `$*` collect *all* positional arguments:

<Frame>
  ![The image illustrates the special shell variables \$\* and \$@, accompanied by a graphic of twelve cylindrical objects arranged in a grid.](https://kodekloud.com/kk-media/image/upload/v1752868618/notes-assets/images/Advanced-Bash-Scripting-Args/shell-variables-cylindrical-objects.jpg)
</Frame>

```bash theme={null}
#!/usr/bin/env bash
packaged_args1="$@"
packaged_args2="$*"

echo "Using \$@: ${packaged_args1}"
echo "Using \$*: ${packaged_args2}"
```

```bash theme={null}
$ ./simple-args2.sh arg1 arg2 arg3
Using $@: arg1 arg2 arg3
Using $*: arg1 arg2 arg3
```

Both variables contain the full list of parameters, but they differ when you iterate over them.

***

## 3. Iterating with a For Loop

Compare two scripts that loop over their arguments:

```bash theme={null}
#!/usr/bin/env bash
echo "Number of arguments: $#"
echo "All arguments: $@"
for arg in "$@"; do
  echo "Argument: $arg"
done
```

```bash theme={null}
#!/usr/bin/env bash
echo "Number of arguments: $#"
echo "All arguments: $*"
for arg in "$*"; do
  echo "Argument: $arg"
done
```

```bash theme={null}
$ ./atsign-example1.sh one two three
Number of arguments: 3
All arguments: one two three
Argument: one
Argument: two
Argument: three

$ ./star-example1.sh one two three
Number of arguments: 3
All arguments: one two three
Argument: one two three
```

<Frame>
  ![The image illustrates the concept of special shell variables \$\* and \$@, using a visual representation of containers and arrows.](https://kodekloud.com/kk-media/image/upload/v1752868619/notes-assets/images/Advanced-Bash-Scripting-Args/special-shell-variables-visualization.jpg)
</Frame>

In the soda‐can analogy:

* `$@` places each can in its own compartment.
* `$*` pours all the soda into one big bottle—individual cans are no longer separate.

<Frame>
  ![The image illustrates the difference between special shell variables \$@ and \$\*, using a visual representation of containers to show how they handle arguments.](https://kodekloud.com/kk-media/image/upload/v1752868620/notes-assets/images/Advanced-Bash-Scripting-Args/shell-variables-difference-visual.jpg)
</Frame>

***

## 4. The Importance of Double Quotes

<Callout icon="lightbulb" color="#1CB2FE">
  Always quote `$@` and `$*`:

  * `"$@"` expands each argument separately.
  * `"$*"` joins all arguments into a single string, separated by the first character of `IFS` (default: space).
</Callout>

Unquoted, both behave identically:

```bash theme={null}
#!/usr/bin/env bash
print_section_header() {
  local title="$1"
  echo "==============================="
  echo "= Section ${title} ="
  echo "==============================="
}

print_section_header "1: \$@"
echo "--> Output of \$@: $@"
echo "Looping \$@ without quotes:"
for arg in $@; do
  echo "$arg"
done

print_section_header "2: \$*"
echo "--> Output of \$*: $*"
echo "Looping \$* without quotes:"
for arg in $*; do
  echo "$arg"
done
```

```bash theme={null}
$ ./special-shell-noquotes.sh one two three
===============================
= Section 1: $@ =
===============================
--> Output of $@: one two three
Looping $@ without quotes:
one
two
three
===============================
= Section 2: $* =
===============================
--> Output of $*: one two three
Looping $* without quotes:
one
two
three
```

***

## 5. Modifying the Internal Field Separator (IFS)

You can change `IFS` to alter how `"$*"` joins arguments:

```bash theme={null}
#!/usr/bin/env bash
IFS=','

echo "Output of \$@: $@"
echo "Output of \$*: $*"
```

```bash theme={null}
$ ./modified-ifs-v1.sh one two three
Output of $@: one two three
Output of $*: one,two,three
```

Splitting later requires unquoted iteration:

```bash theme={null}
#!/usr/bin/env bash
IFS='_'
args_at="$@"
args_star="$*"

print_section_header() { ... }

print_section_header "1: \$@"
echo "--> \$@: $@"
echo "Looping over args_at:"
for arg in $args_at; do
  echo "$arg"
done

print_section_header "2: \$*"
echo "--> \$*: $*"
echo "Looping over args_star:"
for arg in $args_star; do
  echo "$arg"
done
```

***

## 6. Compatibility with Older Bash Versions

Some pre-4.0 Bash releases split unquoted assignments differently. For example, under Bash 3:

```bash theme={null}
#!/usr/bin/env bash
IFS=','
args_at=$@
echo "--> \$@: ${args_at}"
for arg in $args_at; do
  echo "$arg"
done
```

Still, quoting on assignment ensures consistent splitting:

```bash theme={null}
#!/usr/bin/env bash
IFS=','
args_at="$@"
echo "--> \$@: $@"
for arg in $args_at; do
  echo "$arg"
done
```

***

## 7. Summary: `$@` vs `$*`

| Variable | Quoted Expansion | Unquoted Expansion | Use Case |
| - | - | - | - |
| `$@` | Each arg is separate | Each word separate | Looping over arguments |
| `$*` | All args as one | Splits on `IFS` | Passing all args to another command or function |

***

## 8. Conclusion

* Use `"$@"` when you need to preserve each argument.
* Use `"$*"` to aggregate them into a single string with a custom delimiter.
* Always quote both to maintain consistent behavior across Bash versions and avoid word-splitting pitfalls.

<Frame>
  ![The image shows a comparison between special shell variables \$@ and \$\*, with a recommendation to surround them with double quotes.](https://kodekloud.com/kk-media/image/upload/v1752868621/notes-assets/images/Advanced-Bash-Scripting-Args/shell-variables-comparison-doubles-quotes.jpg)
</Frame>

***

## Links and References

* [Bash Reference Manual – Special Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html)
* [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
* [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
