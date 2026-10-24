# Project development environments

Before running project commands, inspect repository instructions and existing
development environment configuration, including `flake.nix`, `devenv.nix`,
`shell.nix`, `.envrc`, and documented setup commands.

Use the project's existing development environment for builds, tests, linters,
formatters, code generation, and other development tools. For a Nix flake, use
`nix develop -c <command>`. For devenv, use `devenv shell <command>`. Follow
repository instructions for any other environment. Do not assume a shell entered
in one tool call remains active in later calls; wrap each command as needed.

If a project has no development environment, create a Nix flake or devenv shell
as part of the task before running project tooling. Prefer the repository's
existing Nix conventions; otherwise use a small `flake.nix` with a default
development shell. Inspect manifests and workflows to choose the required
runtime, build tools, and development dependencies. Avoid introducing a second
environment when an existing setup already serves this purpose.

Keep dependencies declarative. Update the environment when adding a tool rather
than installing it globally or making an undocumented ad hoc installation.
Commit applicable lock files, ignore local environment state, and document how
to enter the environment and run common checks. Add repository-level agent
instructions to use the environment if those instructions are missing.

Validate that the environment evaluates and run the relevant checks through it.
If Nix or another required environment tool is unavailable, report the concrete
blocker and any checks that could not run; do not silently use global tools.
Do not install or reconfigure system-level tooling without authorization.

<!-- agent-skills-defaults:start -->
## Agent skills defaults

When using Matt Pocock's engineering skills, use the active repository's
instructions and `docs/agents/*.md` first. For missing settings, read
`/home/aleksander/.codex/agent-defaults/matt-pocock/issue-tracker.md` for local Markdown tickets under that
repository's `.scratch/`, `/home/aleksander/.codex/agent-defaults/matt-pocock/triage-labels.md` for standard
triage labels, and `/home/aleksander/.codex/agent-defaults/matt-pocock/domain.md` for glossary and ADR conventions.
Keep project artifacts in the active repository. Create domain docs as concepts
and decisions are resolved. Configure a remote issue tracker only when the
repository or user selects it; a remote URL alone does not authorize publishing.

When using pstack skills, read `/home/aleksander/.cursor/rules/pstack-models.mdc` before choosing models. It overrides
their upstream model defaults. On T3, pass its exact model IDs, provider, and
options to `delegate_task`; recheck the live catalog before dispatching.
If a configured model is unavailable, report the mismatch and ask for a replacement.
Within pstack workflows, use `pstack-tdd` and `pstack-teach` for its TDD and
teaching skills; `tdd` and `teach` belong to Matt Pocock's collection.
<!-- agent-skills-defaults:end -->
