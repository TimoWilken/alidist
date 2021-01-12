package: test
version: "v0.0.1"
tag: "v0.0.1"
requires: []
build_requires: []
source: https://github.com/TimoWilken/action-test
incremental_recipe: echo BUILDING INCREMENTAL
valid_defaults: ["test"]
---
#!/bin/sh
echo BUILDING FULL
