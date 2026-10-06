# devnull

> Redirecting standard error to standard output in Bash to capture or suppress command output effectively.

Redirecting standard error (stderr) into standard output (stdout) is a powerful shell idiom that helps you capture or suppress all command output in one place. In this guide, we’ll start with basic redirection operators and build up to the full pattern:

```bash theme={null}
2>&1
```

By the end, you’ll know how to merge streams, write them to files, and even discard them using `/dev/null`.

## 1. Basic redirection with `>`

A single greater‐than symbol sends a file descriptor to a file (or another stream):

```bash theme={null}
$ ls > stdout.txt
```

* Left of `>` is the source FD (default is 1, i.e. stdout).
* Right of `>` is the destination (often a filename).

You can explicitly specify the FD:

```bash theme={null}
$ ls 1>stdout.txt    # same as `ls > stdout.txt`
$ ls 2>stderr.txt    # redirect stderr (fd 2) into stderr.txt
```

<Callout icon="lightbulb" color="#1CB2FE">
  When you omit the FD before `>`, Bash assumes `1` (standard output).
</Callout>

## 2. Merging stdout and stderr with `&>`

Bash provides a shorthand to capture both streams at once:

```bash theme={null}
$ ls -z &> all-logs.txt
$ cat all-logs.txt
ls: cannot access '-z': No such file or directory
```

Here, `&>` is equivalent to `>file 2>&1` in Bash.

## 3. Duplicating file descriptors using `>&n`

When `&` appears on the right side of `>`, you’re duplicating an FD instead of writing to a filename:

```bash theme={null}
$ echo "warning" >&2    # send stdout (fd 1) into stderr (fd 2)
```

This is different from `&> file.txt`, which writes both stdout and stderr into a file.

## 4. Swapping streams with `n>&m`

You can redirect one FD into another:

* Send stdout into stderr:

  ```bash theme={null}
  $ echo "warning" >&2
  ```

* Send stderr into stdout:

  ```bash theme={null}
  $ ls -z 2>&1
  ls: cannot access '-z': No such file or directory
  ```

<Callout icon="triangle-alert" color="#FF6B6B">
  Order matters when combining redirections. Always redirect stdout first, then redirect stderr into it.
</Callout>

## 5. Redirecting both streams to a file

To capture **both** stdout and stderr in a single file, use:

```bash theme={null}
$ ls -z > file.txt 2>&1
```

1. `> file.txt` sends stdout (fd 1) into `file.txt`.
2. `2>&1` redirects stderr (fd 2) into wherever stdout is now pointing.

## 6. Discarding all output with `/dev/null`

If you want a command to produce **no output**, redirect both streams to `/dev/null`, the special “black hole” in Unix-like systems:

```bash theme={null}
> /dev/null 2>&1
```

<Frame>
  ![The image explains that "/dev/null" is a special file that discards all data written to it.](https://kodekloud.com/kk-media/image/upload/v1752868656/notes-assets/images/Advanced-Bash-Scripting-devnull/dev-null-special-file-explanation.jpg)
</Frame>

Use this pattern when you need a silent command—no stdout, no stderr.

<Frame>
  ![The image features the term "/dev/null" with a visual representation of a black hole and checkmarks next to the phrases "Data that is not needed" and "Data should not be saved."](https://kodekloud.com/kk-media/image/upload/v1752868657/notes-assets/images/Advanced-Bash-Scripting-devnull/dev-null-black-hole-checkmarks.jpg)
</Frame>

***

## Key takeaways

| Operator | Purpose | Example |
| - | - | - |
| `>file` | Redirect stdout (fd 1) to a file | `ls > out.txt` |
| `2>file` | Redirect stderr (fd 2) to a file | `ls -z 2>err.txt` |
| `&>file` | Redirect both stdout and stderr to a file | `cmd &>all.txt` |
| `n>&m` | Duplicate FD n into FD m | `echo "err" >&2` |
| `2>&1` | Merge stderr into stdout | `cmd >out.txt 2>&1` |
| `> /dev/null 2>&1` | Discard both stdout and stderr | `some_command > /dev/null 2>&1` |

<Frame>
  ![The image is a slide titled "/dev/null" with checkmarks next to "Redirection," "File descriptors," and "Scenarios where to discard the output."](https://kodekloud.com/kk-media/image/upload/v1752868658/notes-assets/images/Advanced-Bash-Scripting-devnull/dev-null-checkmarks-redirection.jpg)
</Frame>

***

## Links and References

* [Bash Redirections (GNU Manual)](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
* [The Linux `/dev/null` Explained (StackOverflow)](https://stackoverflow.com/questions/1146320/what-is-dev-null)
* [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
