# Command parser for LOGO

This is a LOGO command parser build with PEG.js

# Example

This code

```
REPEAT 4 [
  FD 10 RT 90
]
```

will output this

```
[
   {
      "command": "FD",
      "args": [
         10
      ]
   },
   {
      "command": "RT",
      "args": [
         90
      ]
   },
   {
      "command": "FD",
      "args": [
         10
      ]
   },
   {
      "command": "RT",
      "args": [
         90
      ]
   },
   {
      "command": "FD",
      "args": [
         10
      ]
   },
   {
      "command": "RT",
      "args": [
         90
      ]
   },
   {
      "command": "FD",
      "args": [
         10
      ]
   },
   {
      "command": "RT",
      "args": [
         90
      ]
   }
]
```

