# Arrays

> This article explains how to declare, access, and effectively use arrays in Bash scripting.

Arrays in Bash empower you to store multiple values in an indexed collection, offering direct access to any element—first, middle, or last—by its index. This is analogous to reaching into a specific drawer when you know exactly where your socks are kept, rather than inspecting each one sequentially.

<Frame>
  ![The image illustrates the concept of arrays using a drawer analogy, showing three drawers labeled 1, 2, and 3 on the left, and an array with indices 0, 1, and 2 on the right.](https://kodekloud.com/kk-media/image/upload/v1752868541/notes-assets/images/Advanced-Bash-Scripting-Arrays/arrays-drawer-analogy-diagram.jpg)
</Frame>

<Callout icon="lightbulb" color="#1CB2FE">
  Bash arrays are **zero-indexed**: the first element is at index `0`, the second at `1`, and so on.
</Callout>

## Why Use Arrays?

* **Direct element access** reduces loops and conditional checks.
* **Cleaner scripts** when handling lists of servers, filenames, or configurations.
* **Improved performance** versus string-based lists requiring manual parsing.

Compare a string-based iteration:

```bash theme={null}
#!/usr/bin/env bash

servers="server1 server2 server3"
for server in ${servers}; do
  if [[ "$server" == "server2" ]]; then
    server="${server}.kodekloud.com"
  fi
  echo "$server"
done
```

Output:

```bash theme={null}
server1
server2.kodekloud.com
server3
```

This checks every item, akin to opening each drawer until you find your socks. Arrays eliminate that overhead.

***

## Declaring Arrays

### 1. Assigning by Index

```bash theme={null}
#!/usr/bin/env bash

course_sections[0]="Introduction"
course_sections[1]="Coding Standards"
course_sections[2]="Refresher"

echo "${course_sections[0]}"   # Introduction
echo "${course_sections[1]}"   # Coding Standards
echo "${course_sections[2]}"   # Refresher
```

<Frame>
  ![The image illustrates an array with three indexed elements (0, 1, 2), highlighting the second element (index 1) as "server\[1\]".](https://kodekloud.com/kk-media/image/upload/v1752868542/notes-assets/images/Advanced-Bash-Scripting-Arrays/array-indexed-elements-server1.jpg)
</Frame>

### 2. Inline Initialization

```bash theme={null}
#!/usr/bin/env bash

declare -a course_sections=("Introduction" "Coding Standards" "Refresher")
echo "${course_sections[@]}"   # Introduction Coding Standards Refresher
```

You can also omit `declare -a`:

```bash theme={null}
course_sections=("Intro" "Middle" "End")
```

***

## Accessing Array Elements

| Operation | Syntax | Example Output |
| - | - | - |
| Single element | `${array[index]}` | `${course_sections[1]}` → Coding Standards |
| All elements | `${array[@]}` | `${course_sections[@]}` → all items |
| Number of elements | `${#array[@]}` | count of items |
| All indices (keys) | `${!array[@]}` | list of valid indices |
| Slice | `${array[@]:start:length}` | subset of elements |

### Get All Elements

```bash theme={null}
#!/usr/bin/env bash

sections=("Intro" "Body" "Conclusion")
echo "${sections[@]}"  # Intro Body Conclusion
```

***

## Quoting Arrays: Preserve Whitespace

Unquoted expansions split on spaces:

```bash theme={null}
#!/usr/bin/env bash

sections=("Coding Standards" "Best Practices")

# Unquoted
for s in ${sections[@]}; do
  echo "$s"
done

# Quoted
for s in "${sections[@]}"; do
  echo "$s"
done
```

Output:

```plaintext theme={null}
Coding
Standards

Coding Standards
```

<Callout icon="triangle-alert" color="#FF6B6B">
  Always **quote** `${array[@]}` in loops or commands to preserve elements containing spaces.\
  Unquoted expansions can lead to unexpected word splitting.
</Callout>

***

## Modifying Arrays

### Append an Element

```bash theme={null}
#!/usr/bin/env bash

sections=("Intro" "Methods")
sections+=("Conclusion")
echo "${sections[@]}"  # Intro Methods Conclusion
```

### Overwrite Entire Array

Assigning a string replaces index `0` but retains the array type:

```bash theme={null}
#!/usr/bin/env bash

sections=("A" "B" "C")
sections="NewSection"
echo "${sections[@]}"  # NewSection
```

***

## Further Reading and References

* [Bash Reference Manual: Arrays](https://www.gnu.org/software/bash/manual/html_node/Arrays.html)
* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [Docker Hub](https://hub.docker.com/)
* [Terraform Registry](https://registry.terraform.io/)
