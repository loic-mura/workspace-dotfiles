---
name: pr:update-description
description: Update PR description using your style while respecting repo templates
argument-hint: [optional context or instructions]
allowed-tools: Bash(gh *), Read, Glob
---

# PR Description Update Workflow

This skill updates a PR description to match your personal writing style while respecting the repository's PR template.

---

## Your PR Description Style

**Core Principles:**
- **Concise** - No fluff, straight to the point
- **Technical** - Uses code references with backticks
- **Context-driven** - Links to investigations/dashboards when relevant
- **No echo** - Doesn't repeat what's obvious from code

**Structure (flexible based on complexity):**
- **Significant changes**: `## Motivation` + `## Changes`
- **Straightforward changes**: Only `## Changes`
- **Simple/obvious changes**: Plain text or empty body

**Motivation Section** (when needed):
- Explains **why** the change is needed (problem/impact)
- 2-4 sentences max
- Links to investigations, notebooks, tickets
- Format:
  ```
  ## Motivation

  [Problem description in 1-2 sentences]

  [Impact or benefit in 1-2 sentences]

  [Optional: Link to investigation/ticket]
  ```

**Changes Section:**
- **High-level, logical changes** - NOT a list of all files/functions modified
- Describe WHAT changed from a feature/business perspective
- Use code references with backticks only for key entities (models, APIs, services)
- Nested bullets for related sub-changes
- Images/videos for UI changes (if provided)
- No verbose explanations
- **The diff shows HOW, the description shows WHAT**
- Format:
  ```
  ## Changes

  - Add new fields to PR model (title, created_at, closed_at)
  - Update API endpoint to return new fields
  - Add database migration for new columns
  ```

  **NOT:**
  ```
  ## Changes

  - Update `models/pull_request.go` to add Title field
  - Update `models/pull_request.go` to add CreatedAt field
  - Update `models/pull_request.go` to add ClosedAt field
  - Update `api/handlers/pr_handler.go` to serialize new fields
  - Update `api/handlers/pr_handler_test.go` to test new fields
  - Update `datastore/pr_store.go` to save new fields
  ```

**Special Cases:**
- **Reverts**: "Reverts [PR link]" + optional brief explanation
- **Version gates**: Simple statement like "No version gate because..."
- **Testing notes**: "I tested..." as direct statement
- **Empty body**: When title is completely self-explanatory

**What to AVOID:**
- No "This PR does X" or "This commit does Y"
- No verbose descriptions of what's obvious
- No excessive documentation
- No pleasantries or soft language
- No repetition of the title

---

## Workflow Steps

### Step 1: Get Current PR Information

1. Get the current PR number and repository:
   ```bash
   gh pr view --json number,title,body,url,baseRefName,headRefName
   ```

2. Get the PR diff summary to understand changes:
   ```bash
   gh pr diff --name-only
   ```

3. Get a concise summary of the actual changes:
   ```bash
   gh pr diff | head -200
   ```

### Step 2: Extract and Fetch JIRA Ticket Context

1. **Extract ticket from branch name:**
   - Branch names often follow the pattern: `loic.mura/CODEX-{ticket number}-{slug}`
   - Parse the branch name to extract the ticket number (e.g., `CODEX-1234`)
   - Common ticket patterns: `CODEX-XXX`, `DEVEX-XXX`, etc.

2. **If ticket found:**
   - Use `gh issue list` or check if there's a JIRA link in the repo
   - Try to get ticket context via JIRA API or Atlassian CLI if available
   - If no direct access, just note the ticket number for reference

3. **If no ticket found in branch name:**
   - Ask the user: "Is there a related JIRA ticket for this PR? If so, please provide the ticket number or URL for additional context."
   - If user provides ticket, fetch context
   - If user says no ticket, proceed without it

4. **Using ticket context:**
   - Use ticket description/summary to understand the **why** behind changes
   - Use ticket acceptance criteria to understand **what** needs to be done
   - **IMPORTANT**: Don't reference the ticket in the PR description unless it provides necessary context
   - The ticket is for YOUR understanding, not necessarily for the description

### Step 3: Detect Repository PR Template

1. Check for PR template in the repo:
   ```bash
   # Check common locations
   gh repo view --json name,owner
   # Then check for template files
   ```

2. Look for template in these locations:
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `docs/pull_request_template.md`

3. If template exists, read it to understand required sections

### Step 4: Analyze Changes

Based on the diff and files changed:

1. **Determine complexity level:**
   - **High complexity**: Multiple files, architectural changes, new features
     → Use `## Motivation` + `## Changes`
   - **Medium complexity**: Focused changes, bug fixes, refactoring
     → Use only `## Changes`
   - **Low complexity**: Trivial changes, obvious fixes
     → Use plain text or consider empty body

2. **Identify key changes (high-level):**
   - What's the core purpose of these changes?
   - What features/capabilities were added, modified, or removed?
   - What models/APIs/services were affected?
   - Are there any non-obvious implications?
   - **Think in terms of "what changed" not "what files were touched"**
   - Example: "Add new fields to PR model" NOT "Modified 15 files to add fields"

3. **Determine if motivation is needed:**
   - Is the "why" clear from the title?
   - Is there a problem being solved?
   - Is there a performance/bug/UX impact?

4. **If unclear about the high-level purpose:**
   - If you can't confidently identify the logical changes from the diff
   - If the changes seem scattered or unclear in purpose
   - If you're unsure how to group the changes logically
   - **ASK THE USER**: "I can see changes to [files/areas], but I'm not sure of the high-level purpose. Can you describe what this PR accomplishes in 1-2 sentences?"
   - Use their answer to write the description

### Step 5: Generate Description

**Rules for generation:**

1. **If using template:**
   - Preserve all template sections
   - Fill in only relevant sections
   - Remove or leave empty sections that don't apply
   - Keep content minimal within template sections

2. **Content generation:**

   **For Motivation (if needed):**
   - Start with the problem/why (1-2 sentences)
   - Add impact/benefit (1-2 sentences)
   - Add links if relevant (investigation notebooks, tickets, dashboards)
   - Total: 2-4 sentences max

   **For Changes:**
   - Use bullet points for **logical/functional changes**, not file-by-file changes
   - Group related changes together (don't list every file)
   - Reference key entities with backticks (models, services, APIs) but not every function
   - Use nested bullets for related sub-changes
   - Keep each bullet concise (5-15 words)
   - Focus on **what** changed from a feature perspective, not **how** it was implemented
   - **CRITICAL**: Think "feature changelog" not "git diff summary"

   **Examples:**

   Good (high-level):
   ```
   - Add new fields to PR model (title, created_at, closed_at)
   - `ResetIntegrationBranch`: fetch individual configs instead of all
   - Add database migration for new columns
   ```

   Bad (too low-level):
   ```
   - Update `models/pull_request.go` to add Title field
   - Update `models/pull_request.go` to add CreatedAt field
   - Update `models/pull_request.go` to add ClosedAt field
   - Update `api/handlers/pr_handler.go` to serialize Title
   - Update `api/handlers/pr_handler.go` to serialize CreatedAt
   - Update `api/handlers/pr_handler_test.go` to test new fields
   ```

   Also Bad (verbose):
   ```
   - This PR updates the GetIntegrationBranchesConfigs function to fetch individual configs instead of fetching all of them at once, which will improve performance
   ```

3. **Tone and style:**
   - Direct and technical
   - No softening language ("might", "could", "probably")
   - No pleasantries or apologies
   - Assume reader is technical

4. **When in doubt:**
   - If you're uncertain about the high-level purpose of the changes
   - If you can't confidently summarize the changes at a logical level
   - **ASK THE USER** rather than guessing or listing implementation details
   - Better to ask than to generate a poor description

### Step 5b: Detect Stack PRs

1. **Check if PR is part of a stack:**
   - If `baseRefName` from Step 1 is NOT `main` or `master`, this PR is likely stacked on another PR
   - Find the chain of PRs below the current one:
     ```bash
     # Get the base branch of the current PR
     gh pr view --json baseRefName --jq .baseRefName
     # Find the PR associated with that base branch
     gh pr list --head <baseRefName> --json number,url --jq '.[0]'
     ```
   - Repeat recursively until you reach a PR whose base is `main`/`master`

2. **If stacked, append a "Built on top of" section at the very bottom of the description:**
   ```
   ---

   Built on top of:
   - <PR link of the direct parent>
   - <PR link of grandparent, if any>
   - `main`
   ```
   - List PRs from closest parent to farthest (ending with `main`)
   - Use full PR URLs (e.g., `https://github.com/DataDog/dd-source/pull/123`)

3. **If NOT stacked (base is `main`/`master`):**
   - Do not add this section

### Step 6: Review and Update

1. **Present the generated description to the user:**
   - Show the new description
   - Explain key decisions (why Motivation was included/excluded, etc.)
   - Ask for approval before updating

2. **If approved, update the PR:**
   ```bash
   gh pr edit --body "$(cat <<'EOF'
   [generated description]
   EOF
   )"
   ```

3. **Confirm the update:**
   ```bash
   gh pr view --json body --jq .body
   ```

---

## Additional Notes

- **HIGH-LEVEL CHANGES**: The #1 mistake is listing implementation details instead of logical changes. Think "feature changelog" not "file-by-file diff". Group related changes, don't enumerate every file touched.
- **JIRA tickets**: Extract ticket number from branch name (e.g., `loic.mura/CODEX-1234-fix-bug`). Use ticket context to understand the why/what, but don't reference the ticket in the description unless it adds necessary context. If no ticket in branch name, ask the user.
- **Version gates**: If you notice version gate changes, add a note like "No version gate because [reason]" as plain text
- **Testing**: If testing was done, add "I tested [what/where]" as a simple statement
- **Reverts**: For revert PRs, keep it minimal: "Reverts [PR#]" with optional 1-sentence explanation
- **Empty body**: It's OK to suggest an empty body if the title is completely self-explanatory
- **Stack PRs**: When the base branch is not `main`/`master`, walk the chain of parent PRs and append a "Built on top of" section at the bottom with links to each parent PR, ending with `main`. This section is always separated by a `---` and placed at the very end of the description.

---

## Example Outputs

### Example 1: Significant Change

```markdown
## Motivation

The increased memory usage is linked to the ephemeral branch migration which added extra activity calls for all integration branches. `GetIntegrationBranchesConfigs` starts many parallel activities and waits for them at once, causing high goroutine usage.

This should also reduce activity schedule-to-start latency (around 50s) by reducing the amount of calls.

[Investigation](https://app.datadoghq.com/notebook/...)

## Changes

- `ResetOrUpdateOutdatedIntegrationBranches`:
  - Fetch individual configs instead of all
  - Remove fetching config when resetting (handled within reset workflow)
- `ResetIntegrationBranch`: fetch default branch only when needed, use cache to reduce quota
```

### Example 2: Straightforward Change

```markdown
## Changes

- `DevflowUser`: refactor to store `Identity` directly instead of embedded fields
- `devflow-routing-worker`: use `GetGithubUsernameForOrg` for dynamic EMU/non-EMU selection
- Add `GetGithubUsernameForOrg` to `TriggeredByUser` to simplify org-specific lookups
- Use organization from event instead of hardcoded `DataDog`

Tested `/ping` and `/freeze` in staging in both `DataDog/devflow-staging` and `ddoghq/devflow-staging`.
```

### Example 3: Simple Change (Plain Text)

```markdown
No version gate because it's the error path just before a return.
```

### Example 4: Stack PR

```markdown
## Changes

- Add `ResolveConflicts` activity to handle merge conflicts automatically
- Update `MergeBranch` workflow to call conflict resolution before retrying

---

Built on top of:
- https://github.com/DataDog/dd-source/pull/456
- https://github.com/DataDog/dd-source/pull/455
- `main`
```

### Example 5: Very Simple (Empty Body)

```markdown
[empty - title is self-explanatory]
```

---

## User Request

$ARGUMENTS
