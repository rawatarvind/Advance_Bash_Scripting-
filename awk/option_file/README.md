# Option Files

> Explains running awk programs from files, contrasting pure awk scripts and Bash hybrid approaches, covering shebangs, quoting, variable passing, field separators, and portability considerations.

Although many awk programs are typed directly on the command line for quick tasks, storing awk programs in files is a better practice for larger or reusable scripts. Files make your awk code easier to read, test, version-control, and maintain.

Here are two equivalent ways to run a simple "Hello, World!" example.

Inline on the command line (single-quoted program literal):

```bash theme={null}
$ awk 'BEGIN { print "Hello, World!" }'
Hello, World!
```

From a file (hello.awk) using -f:

```awk theme={null}
BEGIN {
    print "Hello, World!"
}
```

Run it with:

```bash theme={null}
$ awk -f hello.awk
Hello, World!
```

<Frame>
  <img src="https://mintcdn.com/kodekloud-c4ac6d9a/1UnYm26nZTOghZP0/images/Advanced-Bash-Scripting/awk/Option-Files/awk-programs-from-files-checkmark.jpg?fit=max&auto=format&n=1UnYm26nZTOghZP0&q=85&s=571a5afed440a8cb6e56e8eecd64b76a" alt="A dark-themed presentation slide titled &#x22;awk Programs From Files&#x22; showing a teal checkmark icon next to the text &#x22;The importance of writing awk programs to a file.&#x22;" width="1920" height="1080" data-path="images/Advanced-Bash-Scripting/awk/Option-Files/awk-programs-from-files-checkmark.jpg" />
</Frame>

Key details when using awk programs from files

* Do not wrap the program contents in single quotes when it lives in a file. Single quotes are only used when passing an awk program as a single argument on the command line.
* You can make the file executable by adding a shebang that includes the `-f` flag so awk reads the program from the script file:

```bash theme={null}
#!/usr/bin/env awk -f

BEGIN {
    print "Hello, World!"
}
```

<Callout icon="warning" color="#FFCC00">
  Using `#!/usr/bin/env awk -f` in a shebang can be unreliable on some systems because the shebang is passed as a single argument string and `env` may not split the interpreter from its option. Safer alternatives:

  * Use the explicit interpreter path (for example, `#!/usr/bin/awk -f`) when that path is known and consistent across target systems.
  * If your `/usr/bin/env` supports `-S` (GNU coreutils), use `#!/usr/bin/env -S awk -f` to allow argument splitting.

  For maximum portability, prefer an explicit awk interpreter path or invoke `awk -f script` from a shell wrapper.
</Callout>

<Callout icon="lightbulb" color="#1CB2FE">
  The `-f` flag tells awk to read the program from a file. When using an awk shebang, include `-f` so the interpreter treats the script file as an awk program.
</Callout>

Two common styles for file-based awk programs

There are two main patterns for organizing awk in files. Each has trade-offs in portability, readability, and access to shell features.

| Style | Typical shebang / invocation | Pros | Cons | Best suited for |
| - | - | - | - | - |
| Pure awk script | `#!/usr/bin/env awk -f` or `awk -f script.awk` | Entire file is valid awk; portable within awk environments; idiomatic for larger awk-only programs | No direct shell features (globbing, parameter expansion, pipelines) without invoking `system()` or `getline` | Standalone awk utilities and text-processing filters |
| Bash + awk hybrid | `#!/usr/bin/env bash` and call `awk '...'` from shell | Full access to shell features (pipes, env vars, command substitution); easy integration with other tools | Awk code must be quoted inside shell; mixing languages can complicate quoting and maintenance | Shell scripts that leverage awk for data processing steps |

1. Pure awk script (executable awk program)

* Create a file containing only valid awk syntax and include a shebang such as `#!/usr/bin/env awk -f` (or an explicit path).
* Pros: cleaner awk-only source, easier to share as an awk utility.
* Cons: less direct access to shell behavior.

Example (hello.awk):

```awk theme={null}
#!/usr/bin/env awk -f

BEGIN {
    print "Hello, World!"
}
```

Run with either:

```bash theme={null}
$ awk -f hello.awk
Hello, World!

# or make it executable and run
$ chmod +x hello.awk
$ ./hello.awk
Hello, World!
```

2. Bash + awk hybrid (invoke awk from a Bash script)

* Use a Bash shebang and embed an awk program string (usually single-quoted) or invoke awk with `-f` using separate files.
* Pros: Combine shell utilities and environment with awk’s text-processing power.
* Cons: Awk code is quoted inside shell; careful quoting is required.

Example (hello.sh):

```bash theme={null}
#!/usr/bin/env bash

awk 'BEGIN {
    print "Hello, World!"
}'
```

Run by making executable and using `./`:

```bash theme={null}
$ chmod +x hello.sh
$ ./hello.sh
Hello, World!
```

Why the quoting matters

Because the awk program is passed as an argument from the shell in the hybrid style, you must quote it (single quotes are typically used) to prevent the shell from interpreting awk syntax, variables, or braces.

Variable passing and declaration differences

Typically, when invoking awk from a shell (either on the command line or from a Bash script), you use `-v` to pass variables from the shell into awk. In a pure awk program you normally assign variables inside the script (for example, in `BEGIN`).

Pure awk script (hello-v1.awk):

```awk theme={null}
#!/usr/bin/env awk -f

BEGIN {
    hello = "Hello, World"
    print hello
}
```

Run:

```bash theme={null}
$ awk -f hello-v1.awk
Hello, World
```

Bash + awk hybrid (hello-v2.sh):

```bash theme={null}
#!/usr/bin/env bash

awk -v hello="Hello, World!" 'BEGIN {
    print hello
}'
```

Run:

```bash theme={null}
$ chmod +x hello-v2.sh
$ ./hello-v2.sh
Hello, World!
```

Practical reason: using `-v` lets the shell provide values to awk safely and predictably, avoiding issues with quoting and shell expansion.

<Frame>
  <img src="https://mintcdn.com/kodekloud-c4ac6d9a/1UnYm26nZTOghZP0/images/Advanced-Bash-Scripting/awk/Option-Files/awk-files-bash-vs-pure-variables.jpg?fit=max&auto=format&n=1UnYm26nZTOghZP0&q=85&s=9da7775a56fcfcd13f6755f7738223ec" alt="A presentation slide titled &#x22;awk Programs From Files&#x22; noting that awk syntax in a bash script is equivalent to running awk commands in the terminal and that variable declaration syntax differs in pure awk programs. A footer announces an upcoming comparison of field separator syntax between awk hybrid scripts and pure awk programs." width="1920" height="1080" data-path="images/Advanced-Bash-Scripting/awk/Option-Files/awk-files-bash-vs-pure-variables.jpg" />
</Frame>

Field separator examples (two styles)

Pure awk script (separator.awk) using `BEGIN` to set `FS`:

```awk theme={null}
#!/usr/bin/env awk -f

BEGIN {
    FS = "|"
}

{
    print $2, $3
}
```

Bash + awk hybrid (separator.sh) using `-F`:

```bash theme={null}
#!/usr/bin/env bash

awk -F "|" '{
    print $2, $3
}'
```

Both scripts print the second and third fields (e.g., first and last names) when records are pipe-separated. Example output for `employees.txt`:

```bash theme={null}
$ ./separator.sh < employees.txt
Kriti Shrestha
Rajasekar Vasudevan
Debbie Miller
Enrique Rivera
Feng Lin
Andy Luscomb
Mark Crocker
Jing Ma

$ awk -f separator.awk < employees.txt
Kriti Shrestha
Rajasekar Vasudevan
Debbie Miller
Enrique Rivera
Feng Lin
Andy Luscomb
Mark Crocker
Jing Ma
```

Which style should you prefer?

* For this course and many shell-focused workflows, the Bash + awk hybrid is preferred because it shows how awk integrates with shell constructs like pipes, environment variables, command substitution, and the `set` command.
* For larger, standalone text-processing utilities or when distributing an awk tool to users who expect a single awk file, a pure awk script is often cleaner and more idiomatic.

Summary

In this lesson you learned:

* How to run awk programs from files using `awk -f script` or by making the file executable with a shebang (e.g., `#!/usr/bin/env awk -f`).
* The two main styles: pure awk scripts vs. Bash scripts that invoke awk.
* Practical differences in quoting, passing variables (`-v` vs assigning in `BEGIN`), and field-separator handling (`-F` vs `FS`).
* Which style is typically preferred in shell-focused lessons and when to choose a pure awk script instead.

Links and references

* GNU Awk Manual: [https://www.gnu.org/software/gawk/manual/](https://www.gnu.org/software/gawk/manual/)
* awk (Wikipedia): [https://en.wikipedia.org/wiki/Awk](https://en.wikipedia.org/wiki/Awk)
* env command (GNU coreutils): [https://www.gnu.org/software/coreutils/manual/html\_node/env-invocation.html](https://www.gnu.org/software/coreutils/manual/html_node/env-invocation.html)

