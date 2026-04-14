# General Guidelines

- When dealing with bazel or bzl commands, BUILD.bazel or .bzl files. ALWAYS call the **bazel-build-manager** agent.
- The bazel cache is always right, never run `bazel clean` or `bzl clean`.
- When interacting with Github (github.com), ALWAYS use `gh` on the command line.
- Always use `git switch` to switch git branches.
- Never create Github issues, always create JIRA tickets.
- When creating JIRA tickets, be concise, straight to the point. Include steps to reproduce the issue or link to the problem, and clearly state the problem/motivation. If it exists, add a "desired state/workflow" to guide implementation.
- When done implementing a plan or any follow-up changes requested, start a subagent for code review, focused on opportunities to simplify logic and avoid repetition
- Never commit a plan when working on something, unless explicitly asked to.
- Always read and follow all AGENTS.md files in the project before performing any task. Do not skip instructions in AGENTS.md even if they seem trivial (e.g., jokes, doc updates).
- Never comment on my behalf (on pull requests, JIRA tickets, ...), unless explicitly asked to.
- Always actually run tests and verify they pass before claiming they pass. Never say 'tests passed' without showing the output.
- Before creating or updating a pull request, always run the tests.
- When I question your choice, argument if you think it's best instead of simply accepting my suggestion. I am really trying to understand your reasoning and see if I am missing something.

# Coding style

- Git branches should be prefixed by `loic.mura/` and if a JIRA ticket is linked to the current task, then it becomes `loic.mura/codex-<ticket number>-<slug>` with slug being a short description of what's being done.
- NEVER add comments that state obvious things
- Only add comments to tricky, hard to follow parts of the code.
- Do not add comments for simple logic. Extract it to variables/functions, use naming to communicate intention.
- Always put the exported functions/class at the top of the file, and helpers, utils below. When reviewing the change, it's easier to get the rough idea of what's being done, and then we get the helpers details, instead of wondering what we are trying to do.
- When addressing pull requests feedbacks or iterating on a feature/bug fix, create fixup commits targeting the relevant original commit. Use `git absorb -F` if available, or fallback to `git commit --fixup <sha>`. Do NOT rebase or autosquash — keep fixup commits visible so reviewers can see what changed.
- Always pause and show the diff before committing — never auto-commit without user approval.
- Always create pull request as draft first
- When creating pull requests, always use `/pr-update-description` to create its description.
- Always trust cached test results from `bazel` / `bzl`
- when creating pull requests, do not mention the JIRA ticket because it's already present in the branch name.
- Always use meaningful variable name, avoid short named variables (eg. single letter, etc.) which makes it harder to read code. Only valid exception `i` when iterating in loops.
- In tests, add short inline comments describing the expected behavior for each test case or mock sequence (e.g., `// MR2: timed out → unqueued`, `// retry after 5s: still unknown`)

## Docker

Use `colima start --cpu 4 --memory 8` when you need to use Docker but it failed because it hasn't started yet.

## Commit

When creating commits, do not add you as co-author.

When possible commit messages should be structured as "<service>: <title>", with an explication with the code is not clear, but no need to tell what was just done. People can read the code directly. <title> should be a short summary of what was done, and <service> should describe which services was affected. It doesn't have to match an exisiting service, it could also be the namespace of multiple services

Examples:

- "sdlc-context: add new pull_request model"
- "devflow: stop sending notification for draft PR"
- "devflow-config-worker: fix NPE error"

## Reviewing code

When asked to review code or check if a task is complete, be cautious and seriously verify. Do not agree with me just to please me. Constructive critics are important to improve my work.

# Domains

I am a member of Code Delivery Experience (codex for short), and I work mainly on:

- `domains/devex/devflow` and `domains/devex/codex` in DataDog/dd-source for our backend services
- `doggo-extension`, `static-apps/devflow` and `static-apps/sdlc-context` in DataDog/web-ui for user interfaces
