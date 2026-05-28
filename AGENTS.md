# AGENTS.md

Default instructions for AI coding agents working in this repository.
This file follows the [AGENTS.md](https://agents.md) convention and is the
single source of truth for agent guidance in this project. Other agent-specific
files (e.g. `CLAUDE.md`) point here.

## Project overview

This is a Puppet module (`dockerapp`) that provisions Docker-based applications
on a host. Source layout:

- `manifests/` — Puppet manifests (`init.pp`, `params.pp`, `run.pp`, `basedirs.pp`)
- `spec/` — rspec-puppet unit tests
  - `spec/classes/` — class tests
  - `spec/defines/` — defined-type tests
- `metadata.json` — module metadata and version (targets OpenVox 8+ / Puppet 8+)
- `Makefile` — convenience targets wrapping PDK

## Toolchain

Use **[Regent](https://github.com/puppetlabs/regent)** — the Rust-based
alternative development kit for Puppet modules — for all validate, test, and
build operations. **PDK is discontinued for this module; do not use `pdk`.**

Do not invoke `rspec` or `bundle exec` directly either — go through `regent` so
the managed Ruby/gem runtime is used.

Regent binary: `regent` (on `PATH`, typically `~/.cargo/bin/regent`).

First-time setup in a fresh checkout:

```sh
regent bootstrap   # install required gems / runtime deps
regent fixtures    # install fixture modules from .fixtures.yml
```

## Running tests

Always run the unit tests via `regent` before reporting a task complete:

```sh
make test          # equivalent to: regent test
```

Useful flags when iterating:

```sh
regent test --detail                # verbose per-case output
regent test --pattern <substring>   # filter test cases
```

To validate style/lint/syntax:

```sh
make validate      # equivalent to: regent validate
```

To build a release tarball into `pkg/`:

```sh
make build         # runs validate, then `regent build`
```

## Adding or updating tests

- New manifest classes → add a spec under `spec/classes/<name>_spec.rb`.
- New defined types → add a spec under `spec/defines/<name>_spec.rb`.
- Reuse `spec/spec_helper.rb` and `spec/default_facts.yml` for shared setup.
- After any change to `manifests/` or `spec/`, run `make test`.

## Packaging / `.pdkignore` quirk

`regent build` honors `.pdkignore`, but its parser does **not** recognize
gitignore-style leading-slash anchors. A pattern like `/vendor/` is treated as
a no-op, so the gem cache, fixture modules, and `bin/` shims would otherwise
ship in the tarball (inflating it to ~70 MB).

Rule: in `.pdkignore`, write `vendor/`, not `/vendor/` — no leading slash on
any pattern. If a fresh `make build` produces an unexpectedly large `.tar.gz`,
that quirk is almost certainly the cause.

## Conventions

- Bump `version` in `metadata.json` for user-visible changes.
- Update `CHANGELOG.md` and `README.md` when behavior changes.
- Keep Puppet style: follow `.puppet-lint.rc` and `.rubocop.yml`; `make validate`
  enforces both.

## Deploying

`make deploy` builds and uploads to Puppet Forge. Only run when the user
explicitly requests a release.
