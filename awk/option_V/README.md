# Option v

> Explains using awk -v to set variables before execution with examples, best practices, and filtering demos using a sample employees dataset

The -v option in awk sets variables before the awk program or action block runs. Declaring variables this way keeps configuration separate from program logic, makes one-liners easier to read, and improves reusability for scripts and pipelines.

<Frame>
  <img src="https://mintcdn.com/kodekloud-c4ac6d9a/1UnYm26nZTOghZP0/images/Advanced-Bash-Scripting/awk/Option-v/awk-v-variables-dsl-slide.jpg?fit=max&auto=format&n=1UnYm26nZTOghZP0&q=85&s=bc56603bca4590c822ed8752ec118eab" alt="A presentation slide titled &#x22;awk -v Variables&#x22; with a large &#x22;$ awk&#x22; logo in the center. Below it is the subtitle &#x22;Domain-Specific Language&#x22; inside a dotted rounded rectangle." width="1920" height="1080" data-path="images/Advanced-Bash-Scripting/awk/Option-v/awk-v-variables-dsl-slide.jpg" />
</Frame>

## Simple example: use -v with a BEGIN block

This example sets a variable named `var` before the program executes and prints it from a `BEGIN` block. `BEGIN` runs before awk reads any input.

```bash theme={null}
$ awk -v var="Hello, World!" 'BEGIN { print var }'
Hello, World!
```

## Notes on placement and behavior

* The `-v` flag is an option to the `awk` command and is typically placed among other options.
* For portability and clarity, place `-F` (custom field separator) before `-v` when both are used.
* `BEGIN` runs before any input is processed — use it for initialization, printing headers, or other tasks that don't require input data.
* If you omit `BEGIN` and use an action like `{ print var }`, awk reads input (files or stdin) and executes the action for every input record. End interactive stdin with Ctrl+D on Unix-like systems.

<Callout icon="lightbulb" color="#1CB2FE">
  When you need configuration values that may change (thresholds, prefixes, file names), pass them with `-v` instead of hard-coding them in the awk program — it improves readability and allows reusing the same script with different settings.
</Callout>

## Example — printing a variable for each input line (stdin)

```bash theme={null}
$ awk -v var="Hello, World!" '{ print var }'
passing input ........................
Hello, World!
passing input again ........................
Hello, World!
^D
```

(Press Ctrl+D to finish interactive stdin input.)

## Practical dataset: employees.txt

Use this sample data for the following examples. It's pipe-delimited with fields:

1. ID
2. First name
3. Last name
4. Department
5. Job title
6. Email
7. Salary

```bash theme={null}
$ cat employees.txt
1|Kriti|Shreshtha|Finance|Financial Analyst|kriti.shreshtha@company.com|60000
2|Rajasekar|Vasudevan|Finance|Senior Accountant|rajasekar.vasudevan@company.com|75000
3|Debbie|Miller|IT|Software Developer|debbie.miller@company.com|80000
4|Enrique|Rivera|Marketing|Marketing Specialist|enrique.rivera@company.com|65000
5|Feng|Lin|Sales|Sales Manager|feng.lin@company.com|90000
6|Andy|Luscomb|IT|IT Manager|andy.luscomb@company.com|95000
7|Mark|Crocker|HR|HR Manager|mark.crocker@company.com|85000
8|Jing|Ma|Engineering|Engineering Manager|jing.ma@company.com|100000
```

## Example — prefix first names with a descriptive variable

Use `-F "|" -v prefix="..."` to set the field separator and a descriptive prefix that will print before the first name field (`$2`):

```bash theme={null}
$ awk -F "|" -v prefix="Employee's First Name: " '{ print prefix, $2 }' employees.txt
Employee's First Name: Kriti
Employee's First Name: Rajasekar
Employee's First Name: Debbie
Employee's First Name: Enrique
Employee's First Name: Feng
Employee's First Name: Andy
Employee's First Name: Mark
Employee's First Name: Jing
```

Observations:

* `-v prefix="..."` defines a variable available inside the awk program.
* `-F "|" ` splits records on the pipe character; `$2` is the first name.
* The variable `prefix` is expanded inside the action block for each input record.

## Filtering by numeric field (salary)

Print employees earning 90,000 or more (salary is field `$7`):

```bash theme={null}
$ awk -F "|" '$7 >= 90000' employees.txt
5|Feng|Lin|Sales|Sales Manager|feng.lin@company.com|90000
6|Andy|Luscomb|IT|IT Manager|andy.luscomb@company.com|95000
8|Jing|Ma|Engineering|Engineering Manager|jing.ma@company.com|100000
```

### Parameterize the threshold with -v

Use `-v` to pass the salary threshold, making the command reusable without editing the awk program:

```bash theme={null}
$ awk -F "|" -v high_salary="90000" '$7 >= high_salary' employees.txt
5|Feng|Lin|Sales|Sales Manager|feng.lin@company.com|90000
6|Andy|Luscomb|IT|IT Manager|andy.luscomb@company.com|95000
8|Jing|Ma|Engineering|Engineering Manager|jing.ma@company.com|100000
```

Print only the first names of high earners:

```bash theme={null}
$ awk -F "|" -v high_salary="90000" '$7 >= high_salary { print $2 }' employees.txt
Feng
Andy
Jing
```

## Example — benchmark with two variables

Declare multiple variables by using multiple `-v` flags. This example finds employees earning \<= 65000 or >= 90000:

```bash theme={null}
$ awk -F "|" -v high_salary="90000" -v low_salary="65000" \
    '$7 >= high_salary || $7 <= low_salary { print $2 }' employees.txt
Kriti
Enrique
Feng
Andy
Jing
```

<Frame>
  <img src="https://mintcdn.com/kodekloud-c4ac6d9a/1UnYm26nZTOghZP0/images/Advanced-Bash-Scripting/awk/Option-v/awk-v-meaningful-variable-names.jpg?fit=max&auto=format&n=1UnYm26nZTOghZP0&q=85&s=cd2eaa6de182237bfef170b39f18d8e9" alt="A dark-themed slide titled &#x22;awk -v Variables&#x22; showing a central &#x22;-v&#x22; icon and text advising to create meaningful variable names because they help quickly identify the program's purpose." width="1920" height="1080" data-path="images/Advanced-Bash-Scripting/awk/Option-v/awk-v-meaningful-variable-names.jpg" />
</Frame>

## Summary and best practices

| Topic | Recommendation | Example | |
| - | - | - | - |
| Variable declaration | Use `-v name=value` to set variables before awk runs | `awk -v threshold=100 file` | |
| Field separator | Place `-F` before `-v` for portability | \`awk -F " | " -v n=1 '...'\` |
| Multiple variables | Use one `-v` per variable | `-v a=1 -v b=2` | |
| Numeric comparisons | Quoted numeric strings work; awk converts strings to numbers when used numerically | `-v n="90000"` | |
| Initialization | Use `BEGIN` for startup tasks; omit `BEGIN` to process input records | `BEGIN { print "Header" }` | |

<Callout icon="warning" color="#FF6B6B">
  Each `-v` sets a variable before awk begins. If you pass a variable name that matches an awk built-in or field name, you can shadow it — choose meaningful names (e.g., `high_salary`, `prefix`) to avoid collisions and improve maintainability.
</Callout>

Key takeaways:

* `-v` separates configuration from logic and improves clarity for one-liners and scripts.
* Place `-F` before `-v` for consistent behavior across awk implementations.
* Use clear variable names and pass numeric thresholds via `-v` to make scripts configurable.
* `BEGIN` executes prior to record processing; normal action blocks execute per input record.

## Links and references

* [GNU Awk User’s Guide](https://www.gnu.org/software/gawk/manual/gawk.html) — comprehensive reference for awk options and behavior
* [KornShell & awk examples](https://www.grymoire.com/Unix/Awk.html) — practical awk one-liners and tutorials

This lesson covered declaring and using variables in awk with `-v`, how they interact with `BEGIN` blocks and regular action blocks, and practical examples using a sample employees file.

