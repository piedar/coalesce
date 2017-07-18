# Package

version       = "0.3.1"
author        = "Bennjamin Blast"
description   = "coalesce to the first value that exists"
license       = "MIT"

# Dependencies

requires "nim >= 0.17.0"

# Tasks

task test, "run tests":
  exec "nim c -r coalesce.nim"
