# Project agent instructions

Follow the project's existing agent instruction files. If none exist, create
an `AGENTS.md` or `CLAUDE.md` only if the user explicitly asks.

# Project development environments

Before running project commands, inspect repository instructions and existing
development environment configuration, including `flake.nix`, `devenv.nix`,
`shell.nix`, `.envrc`, and documented setup commands.

Use the project's existing development environment for builds, tests, linters,
formatters, code generation, and other development tools. For a Nix flake, use
`nix develop -c <command>`. For devenv, use `devenv shell <command>`. Follow
repository instructions for any other environment. Wrap each command as needed,
since a shell entered in one tool call may not remain active in later calls.
Use direnv only if the current machine is already set up to use it and direnv
loads the project's `flake.nix` or `shell.nix`. In that case, explain how to use
direnv in instructions for the user. Otherwise, include the explicit environment
command, such as `nix develop -c <command>`.

If a project has no development environment, create a Nix flake or devenv shell
as part of the task before running project tooling. Prefer the repository's
existing Nix conventions; otherwise use a small `flake.nix` with a default
development shell. Inspect manifests and workflows to choose the required
runtime, build tools, and development dependencies. Avoid introducing a second
environment when an existing setup already serves this purpose.

Declare new tools in the development environment instead of installing them
globally or through undocumented commands. Commit applicable lock files,
ignore local environment state, and document how
to enter the environment and run common checks. If a repository-level agent
instruction file already exists, update it to require using the environment.

Validate that the environment evaluates and run the relevant checks through it.
If Nix or another required environment tool is unavailable, report what is
missing and which checks could not run. Do not substitute global tools. Do
not install or reconfigure system-level tooling without authorization.

<!-- agent-skills-defaults:start -->

## Agent skills defaults

When using Matt Pocock's engineering skills, use the active repository's
instructions and `docs/agents/*.md` first. For settings they do not cover, read
`/home/aleksander/.codex/agent-defaults/matt-pocock/issue-tracker.md` for local
Markdown tickets under that repository's `.scratch/`,
`/home/aleksander/.codex/agent-defaults/matt-pocock/triage-labels.md` for
standard triage labels, and
`/home/aleksander/.codex/agent-defaults/matt-pocock/domain.md` for glossary and
ADR conventions. Keep project artifacts in the active repository. Create domain
docs as concepts and decisions are resolved. Configure a remote issue tracker
only when the repository or user selects it; a remote URL alone does not
authorize publishing.

When using pstack skills, read
`/home/aleksander/.cursor/rules/pstack-models.mdc` before choosing models. It
overrides the skills' model defaults. On T3, pass its exact model IDs,
provider, and options to `delegate_task`; recheck the live catalog before
dispatching. If a configured model is unavailable, report the mismatch and ask
for a replacement. Within pstack workflows, use `pstack-tdd` and `pstack-teach`
for its TDD and teaching skills; `tdd` and `teach` belong to Matt Pocock's
collection.

<!-- agent-skills-defaults:end -->
