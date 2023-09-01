# libstdbash [![Build Status][shellcheck.svg]][shellcheck]

A standard library for Bash 4 and above.

## Background

At present, this library is still very much in its infancy, much needs to be done to approach usability and
practicality. Eventually, the goal is to produce system packages (`*.deb`, `*.rpm`, etc.) to install `libstdbash` on
your system, and then a simple `source /usr/lib/stdbash/init.sh` to gain access to the import system, which will then
allow users to simply:

```shell
.include /usr/lib/stdbash/logging.sh
.include /usr/lib/stdbash/term.sh
```

`.include` will feature a smart import system where calling `.include` is idempotent. This will be accomplished using
an associative array which will store file-paths along with their hashes to only reload them if their contents have
changed. Sourcing the `init.sh` will setup a variety of basic tools to make all other features opt-in to only be used
if necessary.

## Supplied Functions

Each file in `lib/*.sh` supplies its own set of functions, aliases, and/or environment variables. For now, simply
running `source lib/filename.sh` will include the required functions into your current shell session.

### `lib/logging.sh`

Provides basic logging functions with colored formatting, provided that `stderr` (fd 2) is a TTY. If it isn't this will
simply output plain-text and avoid corrupting data if sent to a file or a pipe.

Five logging levels exist with these function names, similar to most other logging libraries in other languages:

 - `.trace` (`TRACE`)
 - `.debug` (`DEBUG`)
 - `.info` (`INFO`)
 - `.warn` (`WARN`)
 - `.error` (`ERROR`)

At present, nothing exists to define separate loggers, and the logging format is presently:

```shell
$(date +%Y-%m-%dT%H:%M:%S) [$(printf '%-5s' "${log_level}")] ${message}
```

Logs are always emitted to standard error (fd 2) so that they do not interfere with standard output.

`.fatal` logs at the `ERROR` level and then causes the program to exit with a return code of 1.

### `lib/term.sh`

Provides terminal-related functions:

 - `.is-tty`: checks if the given file descriptor (defaults to `stderr`/`2`) is a TTY.
 - `.lsc`: lists available ANSI color names.
 - `.fgc`: sets the ANSI foreground color.
 - `.bgc`: sets the ANSI background color.
 - `.fgr`/`.bgr`: resets the ANSI color back to its default for both foreground and background.
 - `.color-test`: tests your terminal colors for all of the different ANSI colors.

## Testing

This library is continuously tested using [`shellcheck`][shellcheck-repo] in [GitHub Actions][shellcheck-repo].

## License

Licensed at your discretion under either:

 - [MIT License](./LICENSE-MIT)
 - [Apache License, Version 2.0](./LICENSE-APACHE)

 [shellcheck-repo]: https://github.com/koalaman/shellcheck
 [shellcheck]: https://github.com/naftulikay/libstdbash/actions/workflows/shellcheck.yml
 [shellcheck.svg]: https://github.com/naftulikay/libstdbash/actions/workflows/shellcheck.yml/badge.svg

