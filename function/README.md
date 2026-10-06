# Function

This article explains how to use Bash functions for structuring, reusing, and maintaining scripts, enhancing modularity and readability in coding.

In this lesson, you’ll learn how Bash functions help you structure, reuse, and maintain your scripts. While Bash offers conditionals, loops, and script sourcing, functions are key to modular, readable code.


**Why Define Functions in Bash?**

Functions encapsulate a sequence of commands into a single callable unit. This reduces repetition, minimizes errors, and makes your scripts easier to update and test.
Imagine a chef perfecting a recipe once and reusing it whenever needed—functions work the same way in scripting.
​
Backup Script: Before vs. After

Without a function:

#!/bin/bash

    mkdir backup
    cd backup
    cp -r "${1}" .
    tar -czvf backup.tar.gz *
    echo "Backup complete!"


Refactored with a function:

    perform_backup() {
        mkdir -p backup
        cd backup || exit 1
        cp -r "${1}" .
        tar -czvf backup.tar.gz *
        echo "Backup complete!"
    }

    perform_backup "${1}"
    exit 0

Always use mkdir -p to avoid errors if the directory already exists, and add || exit 1 after cd to stop the script on failure


**Local Variables in Functions**

Limit variable scope inside functions with local to avoid unintended side effects.


Example where var1 is not visible outside:

    #!/bin/bash

    my_function() {
        local var1="Hello"
    }

    my_function
    echo "${var1}"  # No output

Example printing the local variable:

    #!/bin/bash

    my_function() {
        local var1="Hello"
        echo "${var1}"
    }

    my_function  # Outputs: Hello


# Benefits of Using Functions

Organization: Break large scripts into logical units.
Reusability: Call the same code multiple times without duplication.
Readability: Name complex logic for better clarity.
Maintainability: Update one function rather than many code blocks.