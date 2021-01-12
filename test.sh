package: test
version: "v0.0.1"
tag: v2021.01.12-1610456289
requires: []
build_requires: []
source: https://github.com/TimoWilken/action-test
incremental_recipe: echo BUILDING INCREMENTAL
valid_defaults: ["test"]
---
#!/bin/sh
echo BUILDING FULL
