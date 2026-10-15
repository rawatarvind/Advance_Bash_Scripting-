# Built in Variables

> This guide explains how to use awk's built-in variables for efficient text data parsing and manipulation.

In this guide, you’ll learn how to leverage **awk**’s built-in variables to parse and manipulate text data efficiently. We’ll cover:

* Positional variables (`$1`, `$2`, …)
* `NR` (Number of Records)
* `NF` (Number of Fields)
* `$NF` (Last Field in the Current Record)
* `FILENAME`

Throughout this article, we’ll use a sample file, **size.txt**, generated from `df -h`:

```bash theme={null}
df -h > size.txt
```

***

## 1. Positional Variables

By default, **awk** splits each input line on whitespace. You can print specific fields using `$1`, `$2`, `$3`, and so on:

```bash theme={null}
awk '{ print $1, $2, $3 }' abc.txt
```

* `$1` → first column
* `$2` → second column
* `$3` → third column

For example, given `abc.txt`:

```text theme={null}
abc def ghi
jkl mno pqr
stu vwx yz
```

```bash theme={null}
awk '{ print $1 }' abc.txt
# Output:
abc
jkl
stu

awk '{ print $2 }' abc.txt
# Output:
def
mno
vwx

awk '{ print $3 }' abc.txt
# Output:
ghi
pqr
yz
```

***

## 2. NR: Number of Records

`NR` tracks the current record (line) number. This is useful for adding line numbers or filtering specific lines:

```bash theme={null}
awk '{ print NR, $1, $4 }' size.txt
```

Produces:

```text theme={null}
1 Filesystem Avail
2 udev       1.8G
3 tmpfs      356M
4 /dev/sda1  9.3G
...
```

To print only the 8th line’s available space:

```bash theme={null}
awk 'NR == 8 { print $4 }' size.txt
# Output:
360G
```

***

## 3. NF: Number of Fields

`NF` contains how many fields are in the current record. It helps you spot inconsistencies in your data:

```bash theme={null}
awk '{ print NF }' size.txt
```

```text theme={null}
7
6
6
6
6
6
6
6
6
```

<Callout icon="lightbulb" color="#1CB2FE">
  The header line has 7 fields because “Mounted on” is split into two separate fields.
</Callout>

***

## 4. Combining NR and NF

Print both the record number and its field count:

```bash theme={null}
awk '{ print NR, NF }' size.txt
```

```text theme={null}
1 7
2 6
3 6
4 6
...
```

Concatenate text with values:

```bash theme={null}
awk '{ print "Line", NR, "has", NF, "fields" }' size.txt
```

```text theme={null}
Line 1 has 7 fields
Line 2 has 6 fields
...
```

***

## 5. \$NF: The Last Field

Use `$NF` to refer directly to the last field of each record:

```bash theme={null}
awk '{ print $NF }' size.txt
```

```text theme={null}
on
/dev
/run
/
...
```

***

## 6. FILENAME: Current Filename

`FILENAME` holds the name of the file being processed (empty when reading from stdin):

```bash theme={null}
awk '{ print FILENAME, $1 }' size.txt
```

```text theme={null}
size.txt Filesystem
size.txt udev
size.txt tmpfs
...
```

When you pipe data into **awk**, `FILENAME` is empty:

```bash theme={null}
df -h | awk '{ print FILENAME, $1 }'
# Output:
 Filesystem
 udev
 tmpfs
 ...
```

***

## 7. Summary Table of Built-in Variables

| Variable | Description | Example |
| - | - | - |
| `$1`, `$2` | Positional fields (first, second, etc.) | `awk '{ print $2 }' file.txt` |
| `NR` | Current record (line) number | `awk '{ print NR }' file.txt` |
| `NF` | Number of fields in the current record | `awk '{ print NF }' file.txt` |
| `$NF` | The last field in the current record | `awk '{ print $NF }' file.txt` |
| `FILENAME` | Name of the file being processed (or empty) | `awk '{ print FILENAME }' file.txt` |

***

## 8. Custom Field Separators

If your data uses a delimiter other than whitespace, set the `-F` option:

```bash theme={null}
awk -F, '{ print $1, $NF }' data.csv
```

<Callout icon="triangle-alert" color="#FF6B6B">
  Always quote the `-F` argument when it contains special characters, e.g., `awk -F'|' '...' file.txt`.
</Callout>

***

## Links and References

* [GNU awk Manual](https://www.gnu.org/software/gawk/manual/)
* [awk User’s Guide](https://www.cs.princeton.edu/~bwk/btl.mirror/)
* [Korn Shell: awk Built-in Variables](https://docstore.mik.ua/orelly/unix3/awk/ch02_01.htm)

