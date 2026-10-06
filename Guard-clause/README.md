# Guard clause

> Explains using guard clauses in shell scripts to fail fast, reduce nesting, and improve readability and maintainability of scripts

In this lesson we cover the guard-clause pattern for Shell scripting — a simple technique that reduces nesting by checking and failing fast on preconditions. Guard clauses make the primary, successful path of your script clear and unindented, improving readability and maintainability.

## Why avoid deep nesting?

Consider a basic file-exists check:

```bash theme={null}
#!/bin/bash

# Check if a file exists
if [[ -e myfile.txt ]]; then
    echo "File exists"
else
    echo "File does not exist"
fi
```

Now compare that to a more deeply nested script that validates a user and file conditions before running a process:

```bash theme={null}
#!/bin/bash

if [[ "${USER_NAME}" == "admin" ]]; then
    if [[ -e "${FILE_PATH}" ]]; then
        if [[ -s "${FILE_PATH}" ]]; then
            run_process
        else
            echo "File exists but is empty"
        fi
    else
        echo "File does not exist"
    fi
else
    echo "User is not admin"
fi

exit 0
```

Deep nesting like this makes control flow harder to follow and increases the cognitive load when scanning code or debugging.

## Use guard clauses to fail fast

A cleaner approach is to check preconditions early and exit immediately when they fail. This keeps the successful execution path flat and easy to read.

Here is an idiomatic version of the previous script using guard clauses. Each critical condition is checked up front and exits on failure, leaving the main logic simple:

```bash theme={null}
#!/bin/bash
readonly FILE_PATH="/home/ubuntu/guard_clause/file.txt"
readonly USER_NAME="admin"

run_process() {
    echo "running process..."
}

if [[ "${USER_NAME}" != "admin" ]]; then
    echo "User is not admin"
    exit 1
fi

if [[ ! -e "${FILE_PATH}" ]]; then
    echo "File does not exist"
    exit 1
fi

if [[ ! -s "${FILE_PATH}" ]]; then
    echo "File exists but is empty"
    exit 1
fi

run_process

exit 0
```

By reversing conditionals (using ! where appropriate) and exiting immediately on failure, the main successful path of the script is simple and unindented.

<Frame>
  <img src="https://mintcdn.com/kodekloud-c4ac6d9a/1UnYm26nZTOghZP0/images/Advanced-Bash-Scripting/Refresher/Guard-clause/guard-clause-slide-checklist.jpg?fit=max&auto=format&n=1UnYm26nZTOghZP0&q=85&s=0ba5b8c9375ab7a9be85655647118b5b" alt="A dark-themed presentation slide titled &#x22;Guard Clause&#x22; with a small check/cross icon on the left. On the right are three checked points: &#x22;Improve code readability&#x22;, &#x22;Reduce the nesting depth or conditional statements&#x22;, and &#x22;Prevent hard-to-find bugs.&#x22;" width="1920" height="1080" data-path="images/Advanced-Bash-Scripting/Refresher/Guard-clause/guard-clause-slide-checklist.jpg" />
</Frame>

Guard clauses are like preparing tools before disassembling a car — you check essentials first so the rest of the work assumes those conditions are met.

## Minimal guard example

A very small guard clause to ensure a file exists:

```bash theme={null}
if [[ ! -f ${file} ]]; then
    exit 1
fi
```

This ensures subsequent code runs only when the file is present.

## Practical example: require a CLI argument

A common guard is verifying the presence of required command-line arguments before proceeding. Example for `git clone`:

```bash theme={null}
#!/bin/bash

if [[ -z "${1}" ]]; then
    echo "Usage: $0 <git-repository-url>"
    exit 1
fi

git_url="${1}"

git clone "${git_url}"

exit 0
```

Tips:

* For scripts that take multiple or optional flags, prefer getopts or a parsing library.
* Use special shell variables like `$#`, `$@`, and positional parameters to write robust argument checks.

## One-line guard idioms

Shell short-circuit logic is often used for concise guard patterns:

* OR (||) — run the right-hand side if the left-hand side fails.
* AND (&&) — run the right-hand side only if the left-hand side succeeds.

| Operator | Use case | Example | | | | |
| -: | - | - | - | - | - | - |
| | | | Fail fast with a fallback command | \[\[ -f "file.txt" ]] | | echo "file does not exist" |
| && | Execute follow-up command only on success | \[\[ -n "${1}" ]] && echo "argument provided: ${1}" | | | | |

When using multiple commands on the right-hand side (for example, printing a message then exiting), group them with braces:

```bash theme={null}
[[ -f "file.txt" ]] || { echo "file does not exist"; exit 1; }
```

## References

* [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
* [Shell Scripting Best Practices](https://www.shellscript.sh/)
* [Git Documentation - git-clone](https://git-scm.com/docs/git-clone)

<Callout icon="lightbulb" color="#1CB2FE">
  Guard clauses improve readability by reducing nesting, making successful execution paths clear, and failing early on error conditions.
</Callout>

