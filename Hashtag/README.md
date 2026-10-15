# Hashtag

> This guide explains how to use `$#` in Bash to count command-line arguments for better error handling and input validation in scripts.

In shell scripting, robust error handling and input validation are crucial. Earlier, we saw how `$?` captures the exit status of the last command. In this guide, we’ll dive into `$#`, which returns the number of positional parameters passed to your script or function. By checking `$#` early, you can prevent unexpected behavior and make your scripts more reliable.

## Table of Contents

1. [Why `$#` Matters](#why-)
2. [Basic Usage of `$#`](#basic-usage-of-)
3. [Positional Parameters and Empty Defaults](#positional-parameters-and-empty-defaults)
4. [Guard Clauses with `$#`](#guard-clauses-with-)
   * [Exact Number of Arguments](#exact-number-of-arguments)
   * [Minimum Number of Arguments](#minimum-number-of-arguments)
   * [Range of Arguments](#range-of-arguments)
5. [Real-World Example: Walking Calorie Expenditure Script](#real-world-example-walking-calorie-expenditure-script)
   * [Flawed Version](#flawed-version)
   * [Improved Version with `set -e` and `terminate()`](#improved-version-with-set-e-and-terminate)
6. [Summary of Key Variables](#summary-of-key-variables)
7. [Links and References](#links-and-references)

***

## Why `$#` Matters

Shell scripts often rely on user-supplied arguments. If your script assumes a certain number of inputs but none (or too many) are provided, it can silently fail or produce erroneous results. Checking `$#` allows you to:

* Validate inputs before executing critical logic
* Provide clear usage messages
* Exit early on misuse

<Callout icon="lightbulb" color="#1CB2FE">
  Always validate positional parameters to avoid silent errors and improve script maintainability.
</Callout>

***

## Basic Usage of `$#`

Create a script called `count-args.sh`:

```bash theme={null}
#!/usr/bin/env bash
echo "Number of arguments: $#"
```

Run it with different argument counts:

```bash theme={null}
$ ./count-args.sh
Number of arguments: 0

$ ./count-args.sh alpha
Number of arguments: 1

$ ./count-args.sh alpha beta
Number of arguments: 2

$ ./count-args.sh ""
Number of arguments: 1
```

***

## Positional Parameters and Empty Defaults

By default, referencing an unset positional parameter expands to an empty string without an error:

```bash theme={null}
#!/usr/bin/env bash
echo "First: '${1}'"
echo "Second: '${2}'"
```

```bash theme={null}
$ ./show-params.sh hello
First: 'hello'
Second: ''
$ echo $?
0
```

Without validation, scripts can continue with missing data, leading to downstream failures.

***

## Guard Clauses with `$#`

Validate `$#` early in your script to enforce expected usage. Below are common patterns:

| Pattern | Description | Example | | | | |
| - | - | - | - | - | - | - |
| `[[ $# -ne N ]]` | Exact number of arguments | `if [[ $# -ne 1 ]]; then echo "Usage: $0 <arg>" >&2; exit 1; fi` | | | | |
| `[[ $# -lt N ]]` | At least N arguments | `if [[ $# -lt 1 ]]; then echo "Need at least one arg" >&2; exit 1; fi` | | | | |
| \`\[\[ \$# -lt MIN | | \$# -gt MAX ]]\` | Between MIN and MAX args | \`if \[\[ \$# -lt 1 | | \$# -gt 2 ]]; then echo "Expect 1–2 args" >&2; exit 1; fi\` |

### Exact Number of Arguments

```bash theme={null}
#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <arg>" >&2
  exit 1
fi

echo "Argument received: $1"
exit 0
```

### Minimum Number of Arguments

```bash theme={null}
#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
  echo "Error: At least one argument is required." >&2
  exit 1
fi

echo "Received $# argument(s)."
```

### Range of Arguments

```bash theme={null}
#!/usr/bin/env bash
readonly MIN=1
readonly MAX=2

if [[ $# -lt $MIN || $# -gt $MAX ]]; then
  echo "Usage: $0 <arg1> [arg2]" >&2
  echo "Provide between $MIN and $MAX arguments." >&2
  exit 1
fi

echo "Arguments are within the expected range."
```

***

## Real-World Example: Walking Calorie Expenditure Script

Calculating calories burned from step counts is a practical script. Let’s see a flawed version and then improve it with input validation.

### Flawed Version

```bash theme={null}
#!/usr/bin/env bash
steps=${1}
cal_per_step=0.04
calories=$(echo "${steps} * ${cal_per_step}" | bc)
echo "Calories burned for ${steps} steps: ${calories}"
```

Running without arguments shows a syntax error but exits with status `0`:

```bash theme={null}
$ ./calorie.sh
(standard_in) 1: syntax error
$ echo $?
0
```

<Callout icon="triangle-alert" color="#FF6B6B">
  Scripts that continue after errors can hide critical failures. Always combine guard clauses with strict error handling.
</Callout>

### Improved Version with `set -e` and `terminate()`

```bash theme={null}
#!/usr/bin/env bash
set -e

CL_ARGS_ERROR=155
CAL_PER_STEP=0.04

terminate() {
  local msg="$1"
  local code="${2:-160}"
  echo "Error: $msg" >&2
  exit "$code"
}

# Guard clause: expect exactly one argument
if [[ $# -ne 1 ]]; then
  terminate "Please provide exactly one argument (number of steps)" "$CL_ARGS_ERROR"
fi

steps=$1
calories=$(echo "$steps * $CAL_PER_STEP" | bc)
echo "Calories burned for $steps steps: $calories"
exit 0
```

#### Usage

```bash theme={null}
$ ./calorie.sh
Error: Please provide exactly one argument (number of steps)
$ echo $?
155

$ ./calorie.sh 10000
Calories burned for 10000 steps: 400.00
$ echo $?
0
```

***

## Summary of Key Variables

| Variable | Description | Example |
| - | - | - |
| `$?` | Exit status of the last command | `echo $?` |
| `$#` | Number of positional parameters passed to a script | `if [[ $# -ne 1 ]]; then ... fi` |
| `$1, $2` | Positional parameters (first, second, etc.) | `echo "First: $1"` |

***

## Links and References

* [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
* [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
* [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
