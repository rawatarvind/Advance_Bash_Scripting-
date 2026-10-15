# Underscore

> The special shell variable `$_` holds the last argument of the previous command, enhancing productivity in Bash sessions and scripts.

The special shell variable `$_` holds the last argument of the previous command. It’s especially handy in interactive Bash sessions and scripts when you want to avoid retyping long or dynamic arguments.

## Why Use `$_`?

* Boosts productivity by reducing repetitive typing
* Seamlessly reuses file names, directory paths, or any last argument
* Works in interactive shells **and** within scripts

<Callout icon="lightbulb" color="#1CB2FE">
  `$_` refers strictly to the last argument of the **previous** command. If that command had no arguments, `$_` will be empty.
</Callout>

***

## Interactive Shell Examples

### Listing and Copying a File

```bash theme={null}
$ ls -l file.conf
total 16
-rw-r--r-- 1 root root 896 Jun 18 2020 file.conf
$ cp $_ /tmp
```

Here, `$_` expands to `file.conf`, so you don’t have to type it twice.

### Chaining Commands

```bash theme={null}
$ ls -l file.conf; echo "Done"
total 16
-rw-r--r-- 1 root root 896 Jan 18 2020 file.conf
Done
$ echo $_
Done
```

Since the last command was `echo "Done"`, `$_` now contains `Done`.

***

## Using `$_` in Scripts

```bash theme={null}
#!/usr/bin/env bash

# Create a new directory
mkdir project_build

# Change into the new directory using $_
cd $_

# Show current path
pwd
```

Here, `$_` saves you from typing `project_build` again.

***

## Common Use Cases

| Scenario | Last Command | `$_` Value |
| - | - | - |
| Copying a file | `cp large_archive.tar.gz /backup` | `/backup` |
| Editing a file | `vim /etc/nginx/nginx.conf` | `/etc/nginx/nginx.conf` |
| Moving a directory | `mv logs_old logs_archive` | `logs_archive` |
| Pipelining commands | `grep ERROR logfile.log` | `logfile.log` |

***

## Advanced Examples

```bash theme={null}
# Remove a file, then verify its removal
rm temp_data.csv
echo "Removed" $_

# Using in a pipeline
find . -name '*.log' | xargs gzip
echo "Compressed" $_
```

***

## Further Reading

* [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
* [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

