When interacting with Github (github.com), ALWAYS use `gh` on the command line.

- Always use `git switch` to switch git branches.
- Never create Github issues, always create JIRA tickets.
- When creating JIRA tickets, be concise, straight to the point. Include steps to reproduce the issue or link to the problem, and clearly state the problem/motivation. If it exists, add a "desired state/workflow" to guide implementation.
- When done implementing a plan or any follow-up changes requested, start a subagent for code review, focused on opportunities to simplify logic and avoid repetition
- Never commit a plan when working on something, unless explicitly asked to.
- Always read and follow all AGENTS.md files in the project before performing any task. Do not skip instructions in AGENTS.md even if they seem trivial (e.g., jokes, doc updates).
- Never comment on my behalf (on pull requests, JIRA tickets, ...), unless explicitly asked to.
- Always actually run tests and verify they pass before claiming they pass. Never say 'tests passed' without showing the output.
- Before creating or updating a pull request, always run the tests.

# Coding style

- Git branches should be prefixed by `loic.mura/` and if a JIRA ticket is linked to the current task, then it becomes `loic.mura/codex-<ticket number>-<slug>` with slug being a short description of what's being done.
- Only add comments to tricky, hard to follow parts of the code.
- Do not add comments for simple logic. Extract it to variables/functions, use naming to communicate intention.
- Always put the exported functions/class at the top of the file, and helpers, utils below. When reviewing the change, it's easier to get the rough idea of what's being done, and then we get the helpers details, instead of wondering what we are trying to do.
- When addressing pull requests feedbacks or iterating on a feature/bug fix, prefer amending existing commits than creating new ones. You can use `git absorb -F --and-rebase` if available or fallback to `git commit --fixup`
- Always create pull request as draft first
- When creating pull requests, always use `/pr-update-description` to create its description.
- Always trust cached test results from `bazel` / `bzl`
- when creating pull requests, do not mention the JIRA ticket because it's already present in the branch name.
