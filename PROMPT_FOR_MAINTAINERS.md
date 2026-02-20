# Task: Add a GitHub Actions workflow to automatically update the Homebrew tap

## Context

We maintain a Homebrew tap at `gruntwork-io/homebrew-tap` (https://github.com/gruntwork-io/homebrew-tap). When this repo publishes a new GitHub Release, a GitHub Actions workflow in **this repo** should open a PR against the homebrew-tap repo to update the Homebrew formula.

## Homebrew tap structure

The tap repo has the following structure:

```
Formula/
  <tool>.rb                          # unversioned formula, always tracks the latest release
  <tool>@<major>.<minor>.<patch>.rb  # versioned formula, pinned to an exact version
```

For example, if this repo is `gruntwork-io/boilerplate`:

```
Formula/
  boilerplate.rb          # latest
  boilerplate@0.12.0.rb   # pinned to v0.12.0
```

Or if this repo is `gruntwork-io/runbooks`:

```
Formula/
  runbooks.rb             # latest
  runbooks@0.5.2.rb       # pinned to beta-v0.5.2
```

Every release gets its own versioned formula so users can install any version they want.

## Formula file format

Each formula has the same structure. See the [current boilerplate.rb](./Formula/boilerplate.rb) and [current runbooks.rb](./Formula/runbooks.rb) for reference.

## Versioned formula naming conventions

Versioned formulae follow Homebrew's naming rules:

- **Filename:** `<tool>@<major>.<minor>.<patch>.rb` (e.g., `boilerplate@0.12.0.rb`)
- **Class name:** `@` becomes `AT`, all `.` characters are dropped (e.g., `BoilerplateAT0120`, `RunbooksAT052`)
- The version in the filename uses only the numeric semver portion, stripped of any prefixes like `v` or `beta-v`.
- The `version` field inside the formula still uses the full release tag (e.g., `v0.12.0-alpha1`, `beta-v0.5.2`).
- The versioned formula is otherwise identical to the unversioned one.

## Binary artifact naming convention

Each release publishes 4 binaries with this naming pattern:

```
<tool>_darwin_arm64
<tool>_darwin_amd64
<tool>_linux_arm64
<tool>_linux_amd64
```

For example, runbooks publishes:
- `runbooks_darwin_arm64`
- `runbooks_darwin_amd64`
- `runbooks_linux_arm64`
- `runbooks_linux_amd64`

## What the workflow should do

Create a GitHub Actions workflow file at `.github/workflows/update-homebrew.yml` that:

1. **Triggers** on `release` events with type `published`.
2. **Downloads** all 4 platform/arch binaries from the release.
3. **Computes `sha256`** checksums for each binary.
4. **Generates the updated formula `.rb` file** for the unversioned formula (`<tool>.rb`), replacing the version string, all download URLs, and all sha256 values with the new release's values.
5. **Creates a versioned formula for the new release.** Every release gets its own versioned formula. Extract the numeric semver (strip any `v`, `beta-v`, etc. prefix) and create `<tool>@<major>.<minor>.<patch>.rb` with the appropriate class name. Also update the README.md table to include the new versioned formula.
6. **Opens a PR** against `gruntwork-io/homebrew-tap` with the changes, using the `gh` CLI or `peter-evans/create-pull-request` action. The PR title should be something like `Update <tool> to <version>`.

## Authentication

The workflow needs a GitHub token (PAT or GitHub App token) with `contents: write` permission on the `gruntwork-io/homebrew-tap` repo, stored as a repository secret named `HOMEBREW_TAP_TOKEN`.

## Important details

- The release tag name is available as `${{ github.event.release.tag_name }}`.
- Do NOT use `mislav/bump-homebrew-formula-pr` — our formulae have 4 separate URLs with individual sha256 values per platform/arch, which that action does not support.
- Use `shasum -a 256` or `sha256sum` to compute checksums.
- The workflow should clone the `gruntwork-io/homebrew-tap` repo, make changes on a branch, push the branch, and open a PR.
- Keep the workflow simple and readable. Prefer a shell script step over complex action compositions.
- The PR should target the `main` branch of `gruntwork-io/homebrew-tap`.
