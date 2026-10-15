# awk print

> This guide covers awk's syntax, pattern-action structure, and the print statement for data extraction and formatting.

Awk is a powerful, domain-specific language built for efficient text processing. In this guide, we'll cover its core syntax, the pattern-action structure, and how to use the `print` statement to extract and format data.

## Awk Usage Overview

```bash theme={null}
awk [options] [program] [file...]
```

| Option | Description |
| - | - |
| `-F fs` | Set the input field separator to `fs` |
| `-v var=value` | Assign a value to an awk variable before program execution |
| `-f file` | Read the awk program from the specified `file` |
| `program` | Provide the awk program directly as a quoted string |
| `file...` | One or more input files; if omitted, reads from standard input |

<Callout icon="lightbulb" color="#1CB2FE">
  Always quote your `program` (single or double quotes) so the shell passes it verbatim to awk.
</Callout>

For full details, see the [GNU Awk Manual](https://www.gnu.org/software/gawk/manual/gawk.html).

## Pattern-Action Structure

An awk program is a sequence of *pattern-action* pairs:

```text theme={null}
pattern { action }
```

* If **pattern** is omitted, **action** runs on every input line.
* The `{ … }` block is the **action block**, containing commands like `print`, loops, and conditionals.

Example: Start an interactive session that does nothing with your input.

```bash theme={null}
awk '{}'
```

Type lines, then press **Ctrl-D** to end input:

```bash theme={null}
$ awk '{}'
hello world
^D
$
```

<Callout icon="triangle-alert" color="#FF6B6B">
  Without quotes around `{}`, many shells will interpret braces or special characters—always quote your action blocks!
</Callout>

## The `print` Statement

Inside the action block, `print` sends its arguments (fields, string literals, variables) to standard output.

### Accessing Fields

By default, awk splits each line on whitespace into fields named `$1`, `$2`, ..., `$NF`.

```bash theme={null}
$ awk '{ print $2 }'
abc def ghi
jkl mno pqr
^D
def
mno
```

### Processing Files

Place the filename after the program to read from a file instead of interactively:

Given `abc.txt`:

```text theme={null}
abc def ghi
jkl mno pqr
xy yz uv
```

Run:

```bash theme={null}
awk '{ print $3 }' abc.txt
```

Output:

```text theme={null}
ghi
pqr
uv
```

### Printing String Literals

You can mix fields and literal strings in a single `print`:

```bash theme={null}
awk '{ print "Line:", $1, "->", $NF }' abc.txt
```

Output:

```text theme={null}
Line: abc -> ghi
Line: jkl -> pqr
Line: xy -> uv
```

### Multiple Expressions

Separate expressions by commas; awk joins them with the **output field separator** (`OFS`, default is a space):

```bash theme={null}
awk '{ print "Hello", "World" }' abc.txt
```

## Redirecting and Piping Input

Awk accepts input from:

* Files:
  ```bash theme={null}
  awk '{ print $0 }' data.txt
  ```
* Standard input via redirection:
  ```bash theme={null}
  awk '{ print $0 }' < data.txt
  ```
* Piping from other commands:
  ```bash theme={null}
  cat data.txt | awk '{ print $1 }'
  ```

## Summary

* **Command structure**: `awk [options] [pattern-action] [file...]`
* **Pattern-action**: `pattern { action }`
* **Fields**: `$1`, `$2`, … `$NF`
* **String literals**: printed as-is within quotes
* **Separators**: input (`FS`) and output (`OFS`)
* **Interactive mode**: omit files; end with **Ctrl-D**, cancel with **Ctrl-C**

## Links and References

* [GNU Awk Manual](https://www.gnu.org/software/gawk/manual/gawk.html)
* [Kurt Werner’s Awk Tutorial](https://www.grymoire.com/Unix/Awk.html)
* [Awk on TLDP](https://tldp.org/LDP/abs/html/awk.html)

