# Homebrew Tap Maintenance Guide

> **LLM Prompt**: Paste this entire document into Claude Code (or your preferred LLM coding assistant) when working in your tool's repo. It contains everything needed to set up automated Homebrew formula updates.

## Overview

The [`gruntwork-io/homebrew-tap`](https://github.com/gruntwork-io/homebrew-tap) repo hosts Homebrew formulae for Gruntwork CLI tools. Formula updates are **fully automated** — when a tool repo publishes a GitHub Release, a workflow in that repo opens a PR against homebrew-tap, approves it, and auto-merges it.

No manual intervention is required for routine releases.

## How the automation works

Each tool repo (e.g., `gruntwork-io/boilerplate`) contains a `.github/workflows/update-homebrew.yml` workflow that:

1. Triggers on `release: [published]`
2. Downloads all 4 platform/arch binaries from the release
3. Computes SHA256 checksums for each binary
4. Clones homebrew-tap, reads metadata (desc, homepage, license) from the existing unversioned formula
5. Generates the updated unversioned formula (`<tool>.rb`) and a new versioned formula (`<tool>@<semver>.rb`)
6. Opens a PR, approves it via a GitHub App, and enables auto-merge

## Prerequisites

Before setting up the workflow, ensure your tool meets these requirements:

1. **Binary naming convention** — each release must publish exactly 4 binaries:
   ```
   <tool>_darwin_arm64
   <tool>_darwin_amd64
   <tool>_linux_arm64
   <tool>_linux_amd64
   ```

2. **Version command** — your tool must have a version command (e.g., `mytool --version` or `mytool version`) whose output contains the release tag string somewhere (substring match, not exact). For example, if the tag is `v1.2.0`, output like `mytool version v1.2.0 (built 2025-01-01)` is fine.

3. **GitHub App secrets** — your repo needs two secrets (same values as other tool repos — they share the same GitHub App):
   - `HOMEBREW_TAP_APP_ID` — the App's numeric ID (`2911684`)
   - `HOMEBREW_TAP_APP_PRIVATE_KEY` — the App's PEM private key

   These values are stored in 1Password under the entry "Gruntwork Homebrew Tap Updater".

## Step-by-step setup

### Step 1: Create the initial formula (new tools only)

If your tool already has a formula in homebrew-tap, skip to Step 2.

Open a PR against `gruntwork-io/homebrew-tap` adding `Formula/<tool>.rb`. Use this template, replacing all `<placeholders>`:

```ruby
class <ClassName> < Formula
  desc "<Short description of your tool>"
  homepage "<https://github.com/gruntwork-io/<tool> or product page URL>"
  version "<first-release-tag>"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/<tool>/releases/download/<tag>/<tool>_darwin_arm64"
      sha256 "<sha256>"
    else
      url "https://github.com/gruntwork-io/<tool>/releases/download/<tag>/<tool>_darwin_amd64"
      sha256 "<sha256>"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/<tool>/releases/download/<tag>/<tool>_linux_arm64"
      sha256 "<sha256>"
    else
      url "https://github.com/gruntwork-io/<tool>/releases/download/<tag>/<tool>_linux_amd64"
      sha256 "<sha256>"
    end
  end

  def install
    binary = Dir["<tool>_*"].first
    bin.install binary => "<tool>"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/<tool> <version-flag>")
  end
end
```

**Naming rules:**
- **Class name**: PascalCase of the tool name. Hyphens/underscores become word boundaries (e.g., `my-tool` → `MyTool`, `boilerplate` → `Boilerplate`).
- **Version flag**: Whatever your tool uses — `--version`, `version`, `-v`, etc.
- **SHA256**: Compute with `shasum -a 256 <file>` (macOS) or `sha256sum <file>` (Linux).

You can compute initial SHA256s by downloading the release binaries and running the test script (see Step 3).

### Step 2: Add the workflow to your tool repo

Copy the workflow template from [`maintainers/update-homebrew-template.yml`](./update-homebrew-template.yml) to `.github/workflows/update-homebrew.yml` in your tool's repo.

Before committing, set **`VERSION_CMD`** in the `env` block to the flag your tool uses for printing its version (e.g., `--version` or `version`). This is used in the formula's `test` block. Everything else (tool name, class name, SHA256s) is derived automatically at runtime.

### Step 3: Test locally before your first release

[`maintainers/test-homebrew-workflow.sh`](./test-homebrew-workflow.sh) lets you preview the generated formulae without pushing anything. Run it from your tool repo against an existing release:

```bash
./path/to/homebrew-tap/maintainers/test-homebrew-workflow.sh <release-tag>
```

For example:
```bash
./path/to/homebrew-tap/maintainers/test-homebrew-workflow.sh v1.0.0
```

The script will:
1. Download all 4 release binaries via `gh release download`
2. Compute SHA256 checksums
3. Generate both the unversioned and versioned formula files to a temp directory
4. Print them for you to inspect

It does **not** push anything to git or open PRs.

**Requirements**: The `gh` CLI must be installed and authenticated (`gh auth status`).

> **Note**: This script intentionally duplicates the formula generation logic from `update-homebrew-template.yml` so it can run standalone without a GitHub Actions environment. If you change the formula generation logic in one, update the other to match. See [Keeping the test script in sync](#keeping-the-test-script-in-sync) below.

### Step 4: Add secrets and publish a release

1. Add `HOMEBREW_TAP_APP_ID` and `HOMEBREW_TAP_APP_PRIVATE_KEY` as repository secrets in your tool repo (Settings → Secrets and variables → Actions).
2. Publish a GitHub Release. The workflow will automatically update homebrew-tap.

## Formula conventions

### Repository structure

```
Formula/
  <tool>.rb                          # unversioned, always tracks the latest release
  <tool>@<major>.<minor>.<patch>.rb  # versioned, pinned to an exact version
```

### Versioned formula naming

- **Filename**: `<tool>@<major>.<minor>.<patch>.rb` — uses only the numeric semver, stripped of any prefix (`v`, `beta-v`, etc.) and prerelease suffix (`-alpha1`, etc.)
- **Class name**: `@` becomes `AT`, dots are dropped (e.g., `BoilerplateAT0120`, `RunbooksAT052`)
- The `version` field inside the formula retains the full release tag (e.g., `v0.12.0-alpha1`, `beta-v0.5.2`)
- The versioned formula is otherwise identical to the unversioned one

### Examples

```
Formula/
  boilerplate.rb          # latest → v0.12.0-alpha1
  boilerplate@0.12.0.rb   # pinned to v0.12.0-alpha1
  runbooks.rb             # latest → beta-v0.5.2
  runbooks@0.5.2.rb       # pinned to beta-v0.5.2
```

## Authentication

Cross-repo access uses the **Gruntwork Homebrew Tap Updater** GitHub App (App ID: `2911684`).

The workflow uses [`actions/create-github-app-token@v2`](https://github.com/actions/create-github-app-token) to mint a short-lived token scoped to `gruntwork-io/homebrew-tap` at runtime. No long-lived PATs are involved.

### Required GitHub App permissions

- **Contents: Read & write** — to push branches and merge PRs
- **Pull requests: Read & write** — to create and approve PRs

The app is installed on `gruntwork-io/homebrew-tap` only.

### Branch protection

The `main` branch on homebrew-tap has a ruleset requiring 1 approval before merging. The GitHub App provides this approval automatically, enabling auto-merge. If CI checks are added later, add them as required status checks in the same ruleset and auto-merge will wait for them to pass.

Auto-merge must be enabled on the homebrew-tap repo (Settings → General → "Allow auto-merge").

## Keeping the test script in sync

`test-homebrew-workflow.sh` and `update-homebrew-template.yml` both contain formula generation logic. They are intentionally kept as independent, self-contained files — the workflow runs in GitHub Actions and the test script runs locally — but this means changes to one must be mirrored in the other.

The duplicated logic covers:
- PascalCase class name derivation (`perl -pe 's/(^|[-_])(\w)/uc($2)/ge'`)
- Semver extraction from the release tag (`sed -E 's/^[a-zA-Z]*-?v?//' | sed -E 's/-.*//'`)
- Versioned class name construction (`${CLASS_NAME}AT$(echo "$SEMVER" | tr -d '.')`)
- The formula Ruby template (structure, indentation, `assert_match` test block)

When modifying either file, verify the other still produces identical formula output by running the test script against a known release and comparing against the existing formula in `Formula/`.