# Expanding

This article explains variable expansion in shell scripting, including usage of braces, quoting, and best practices for handling variables.

In shell scripting, variable expansion uses the dollar sign ($) to tell the shell to replace the variable name with its stored value.

In shell scripting, variable expansion uses the dollar sign ($) to tell the shell to replace the variable name with its stored value.

     #!/bin/bash
      var="value of var"
      echo ${var}

Running this script:
      
      $ ./var-sample.sh
       value of var

# Braces vs No Braces

You can reference variables with or without braces. Braces become essential when you append characters immediately after the variable name.

**With Braces**

     #!/bin/bash
      var="value of var"
      echo ${var}
​
**#!/bin/bash**
 
     var="value of var"
     echo $var
     
Both scripts output:
    $ ./var-sample.sh
    value of var

**Delimiting Variable Name**

Without braces, the shell cannot determine where the variable name ends:

#!/bin/bash
height=170

# Incorrect: $heightcm is undefined
echo "Your height is = $heightcm"

# Correct: ${height}cm expands properly
echo "Your height is = ${height}cm"

$ ./height.sh
Your height is = 
Your height is = 170cm

Quoting and Word Splitting

By default, unquoted expansions are split on whitespace defined by IFS (space, tab, newline). Use quotes to preserve the exact value.



Always quote expansions when dealing with filenames, paths, or URLs to prevent unintended splitting.


