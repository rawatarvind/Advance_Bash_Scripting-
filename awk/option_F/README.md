# Option F

> Learn to use the -F option in awk to customize field separators for processing structured text.

Learn how to use the **-F** option in `awk` to customize the field separator when processing structured text. By default, `awk` splits records on whitespace, but **-F** lets you define any character or regular expression as the delimiter.

```bash theme={null}
usage: awk [-F fs] [-v var=value] [-f progfile | 'prog'] [file ...]
```

## 1. Default Field Splitting

By default, `awk` treats any whitespace as the field separator:

```bash theme={null}
$ df -h
```

```text theme={null}
Filesystem      Size  Used Avail Use% Mounted on
udev            1.8G     0  1.8G   0% /dev
tmpfs           366M  9.7M  356M   3% /run
...
```

When your data uses a different delimiter—such as commas, colons, or pipes—you must override this behavior.

## 2. Changing the Field Separator with -F

To use a colon (`:`) as the separator:

```bash theme={null}
$ awk -F ":" '{ print $1 }' sizeV1.txt
```

```text theme={null}
Filesystem
udev
tmpfs
/dev/sda1
...
```

Print the second field:

```bash theme={null}
$ awk -F ":" '{ print $2 }' sizeV1.txt
```

```text theme={null}
Size
1.8G
366M
...
```

Combine fields 1 and 5:

```bash theme={null}
$ awk -F ":" '{ print $1, $5 }' sizeV1.txt
```

```text theme={null}
Filesystem Use%
udev 0%
tmpfs 3%
...
```

You can also pipe data into `awk`:

```bash theme={null}
$ cat sizeV1.txt | awk -F ":" '{ print $2 }'
```

## 3. Why Quote or Escape the Separator

Certain characters (for example, `|`, `&`, `*`, `<`, `>`) have special meanings to the shell.

<Callout icon="triangle-alert" color="#FF6B6B">
  Always quote or escape the field separator to prevent shell interpretation.

  Incorrect:

  ```bash theme={null}
  awk -F | '{ print $1 }' employees.txt
  ```

  This fails because `|` is seen as a pipe.

  Correct:

  ```bash theme={null}
  awk -F "|" '{ print $1 }' employees.txt
  # or
  awk -F \| '{ print $1 }' employees.txt
  ```
</Callout>

<Frame>
  ![The image shows a tip about using the awk command with a field separator, suggesting to enclose the character in double quotes for literal values. There's also a lightbulb icon and a checkmark.](https://kodekloud.com/kk-media/image/upload/v1752868665/notes-assets/images/Advanced-Bash-Scripting-Option-F/awk-command-field-separator-tip.jpg)
</Frame>

## 4. Common Field Separators

| Separator | Shell Meaning | Example Use Case |
| - | - | - |
| : | None | `/etc/passwd` |
| , | None | CSV export |
| \| | Pipe (must escape) | Database output |
| \t | Tab (escape \t) | TSV files |
| = | Assignment (escape) | Key-value configs |

<Frame>
  ![The image shows a list of special characters separated by dotted lines, under the heading "awk -F - Field Separator."](https://kodekloud.com/kk-media/image/upload/v1752868666/notes-assets/images/Advanced-Bash-Scripting-Option-F/awk-field-separator-special-characters.jpg)
</Frame>

## 5. Example: Processing Database Output

Here’s a Bash script (`db.sh`) that runs a PostgreSQL query inside Docker, trimming each field:

```bash theme={null}
#!/usr/bin/env bash
docker_run() {
  docker exec -i employees_db psql -U postgres -d employees -tAQ <<EOF
SELECT
  trim(id_employee::text),
  trim(first_name),
  trim(last_name),
  trim(area),
  trim(job_title),
  trim(email),
  trim(salary::text)
FROM "employee";
EOF
}
docker_run > employees.txt
exit 0
```

View the output:

```bash theme={null}
$ cat employees.txt
```

```text theme={null}
1|Kriti|Shreshtha|Finance|Financial Analyst|kriti.shreshtha@company.com|60000
...
```

Extract first names (field 2):

```bash theme={null}
$ awk -F "|" '{ print $2 }' employees.txt
```

```text theme={null}
Kriti
Rajasekar
Debbie
...
```

<Callout icon="lightbulb" color="#1CB2FE">
  See the [GNU Awk User’s Guide](https://www.gnu.org/software/gawk/manual/html_node/Options.html) for more `awk` options.
</Callout>

## Next Steps

Next, we’ll explore the **-v** option to declare variables within `awk`:

```bash theme={null}
usage: awk [-F fs] [-v var=value] [-f progfile | 'prog'] [file ...]
```

## References

* [GNU Awk Manual](https://www.gnu.org/software/gawk/manual/)
* [awk(1) — Linux manual page](https://man7.org/linux/man-pages/man1/awk.1.html)
* [PostgreSQL Documentation](https://www.postgresql.org/docs/)
