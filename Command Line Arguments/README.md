# Command Line Arguments


Command-line arguments are essential in shell scripting for creating flexible, reusable scripts. Instead of hard-coding values, you can accept inputs at runtime—much like using a remote control to switch channels on a TV. This guide covers everything from basic positional parameters to advanced iteration techniques.


# Understanding Positional Parameters

When you invoke a script with arguments:
   $ ./myscript.sh foo bar baz

Inside myscript.sh, the inputs map to:
    #!/bin/bash
    echo "First argument: $1"
    echo "Second argument: $2"
    echo "Third argument: $3"


Output:

    First argument: foo
    Second argument: bar
    Third argument: baz

