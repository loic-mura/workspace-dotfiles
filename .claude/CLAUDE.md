When interacting with Github (github.com), ALWAYS use \`gh\` on the command line.

# Coding style

- Git branches should be prefixed by `loic.mura/` and if a JIRA ticket is linked to the current task, then it becomes `loic.mura/codex-<ticket number>-<slug>` with slug being a short description of what's being done.
- Only add comments to tricky, hard to follow parts of the code.
- Do not add comments for simple logic. Extract it to variables/functions, use naming to communicate intention.
- Always put the exported functions/class at the top of the file, and helpers, utils below. When reviewing the change, it's easier to get the rough idea of what's being done, and then we get the helpers details, instead of wondering what we are trying to do.
