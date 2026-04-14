---
name: feature
description: create a feature
---

# Feature Implementation Workflow

**Task:** $ARGUMENTS

---

## Setup

1. Derive the jira ticket number from the prompt or the branch name or ask the user. When deducing from the branch name, ask the user for confirmation.
2. If the current branch name doesn't correspond to the current task:
   1. Derive a kebab-case slug from the task description (e.g., "rename an SD" → `rename-sd`)
   2. Create a new branch name `loic.mura/{ticket}-{slug}` from the latest version of the default branch (except if working on a stack PR)

**Note:** Directory creation and PROMPT.md are delayed until Phase 1, after determining the appropriate plan location based on code exploration.

---

## Phase 1: Analysis & Questions

Your task is NOT to implement yet, but to fully understand and prepare.

**Responsibilities:**

- Analyze and understand the existing codebase thoroughly - use Read, Glob, Grep tools extensively
- Determine exactly how this feature integrates, including dependencies, structure, edge cases (within reason, don't go overboard), and constraints

**CRITICAL: Determine Plan Location**

After initial exploration and before writing questions:

1. **Determine the plan directory path**:
   - Find the Git repository root.
   - Plan path will be: `{repository_root}}/.plans/{branch-name}/`
     If the `{branch-name}` contains any `/`, replace them by `-` to not create any sub-folders.
   - Look for markers like service boundaries, module roots, or logical component groupings
2. **Create the plan directory** and **save PROMPT.md** with the exact $ARGUMENTS text

Once plan location is established:

- Clearly identify anything unclear or ambiguous in the description or current implementation
- Ask SPECIFIC, DETAILED questions - not vague yes/no questions
- Cover: Architecture decisions, API design, data models, error handling, testing approach, edge cases, integration points
- Write all questions or ambiguities to `{plan-dir}/QUESTIONS-1.md`

**Quality of questions matters:**

- Ask about specific technical decisions (e.g., "Should the endpoint return just {id} or include {id, name, status}?")
- Ask about error cases (e.g., "What should happen when X fails?")
- Ask about constraints (e.g., "What's the expected scale/volume?")
- Ask about integration (e.g., "Should this use the existing AuthService or create new?")
- Be thorough - 5-10 well-thought-out questions is better than 2-3 vague ones

**Important:**

- Do NOT assume any requirements or scope beyond explicitly described details
- Do NOT implement anything yet - just explore, plan, and ask questions
- This phase is iterative: after user answers QUESTIONS-1.md, you may write QUESTIONS-2.md, etc.
- Continue until all ambiguities are resolved

**ITERATIVE Q&A:**

- ASK AS MANY ROUNDS OF QUESTIONS AS YOU NEED - Don't rush to planning!
- QUESTIONS-1, wait for answers, then QUESTIONS-2, wait for answers, then QUESTIONS-3, etc.
- After each round of answers, if ANYTHING is still unclear or ambiguous, ASK MORE QUESTIONS
- Only when you are 100% confident you understand everything should you move to planning
- It's BETTER to ask too many questions than to make assumptions

**When the user says "I've answered your questions. Please continue.":**

- Review what you know from ALL answered questions
- If ANYTHING is still unclear, ambiguous, or needs clarification → ASK MORE QUESTIONS (QUESTIONS-{N+1})
- Only when you are 100% confident you understand EVERYTHING should you create a plan
- If in doubt, ASK - don't assume

**DO NOT create a plan until:**

1. You have asked all necessary questions
2. You have received and reviewed all answers
3. You have NO remaining ambiguities or assumptions
4. You are completely confident in your understanding

**Questions File Template:**

When creating QUESTIONS-\*.md files, use this format:

```markdown
<!-- INSTRUCTIONS FOR ANSWERING QUESTIONS -->
<!--
- Answer each question inline below the question
- You can edit the questions if they're unclear
- Add your answers under each question
- When done, save the file and let me know
-->

## Q1: Your first question here

## Q2: Your second question here

---

## Anything else you'd like to mention?

**Additional context or clarifications:**

<!-- Save this file when you're done -->
```

**⏸ CHECKPOINT**: When you have no more questions, say "No more questions. Say 'continue' for Phase 2"

---

## Phase 2: Plan Creation

Based on the full exchange, produce a markdown plan document (`{plan-dir}/PLAN.md`).

**Before writing the plan:**

- **Read ALL `AGENTS.md` files** in every directory likely to be touched by this feature
- **Read ALL `CLAUDE.md` files** (project root and nested) for coding style, naming conventions, commit rules, and project-specific requirements
- Note any conventions, mandatory doc updates, or constraints that the plan must account for
- If any convention conflicts with the planned approach, flag it now rather than discovering it post-implementation

**Requirements for the plan:**

- Include clear, minimal, concise steps
- Track the status of each step using these emojis:
  - 🟩 Done
  - 🟨 In Progress
  - 🟥 To Do
- Include dynamic tracking of overall progress percentage (at top)
- Do NOT add extra scope or unnecessary complexity beyond explicitly clarified details
- Steps should be modular, elegant, minimal, and integrate seamlessly within the existing codebase
- Use TDD: tests MUST be written BEFORE implementation code (strict TDD)
- Every task should have corresponding test tasks
- Test commands should be listed for each task
- If you make subsidiary plan files, todos files, memory files, etc., link them from PLAN.md
- As subsidiary plans change through implementation, update the top level plan as well

**CRITICAL FORMAT REQUIREMENTS:**

- First line MUST be: **Overall Progress:** `0%`
- Use checkbox format: `- [ ]` (space between brackets)
- EVERY task MUST have an emoji: 🟥 (To Do), 🟨 (In Progress), or 🟩 (Done)
- Start all tasks as 🟥 (To Do)
- Use **bold** for task names
- Nest sub-tasks with indentation
- Group into phases if complex
- Tests BEFORE implementation (TDD)

** Plan Maintenance **

- _Every step_ must end with a subitem to update plan documents
- Plan documents include:
  - `PLAN.md` the top-level plan with overall progress
  - `PLAN-PHASE-{N}.md` - detailed phase plans (when overall plan is big enough)
- the update subitem should reflect progress percentage, step statuses, and any deviations from the original plan
- If phase plans exist, update both the phase plan and the top-level PLAN.md

**Template Example:**

```markdown
# Feature Implementation Plan

**Overall Progress:** `0%`

## Phase 1: Authentication Module

- [ ] 🟥 **Task 1.1: Setup authentication service**
  - [ ] 🟥 Write test: Test authentication service initialization
  - [ ] 🟥 Implement: Create authentication service class
  - [ ] 🟥 Test: Run `npm test auth.service.test.js`
  - [ ] 🟥 Update PLAN.md (and PLAN-PHASE-1.md if exists)

- [ ] 🟥 **Task 1.2: JWT token handling**
  - [ ] 🟥 Write test: Test JWT generation and validation
  - [ ] 🟥 Implement: Add JWT token handling methods
  - [ ] 🟥 Test: Run `npm test jwt.test.js`
  - [ ] 🟥 Update PLAN.md (and PLAN-PHASE-1.md if exists)

## Phase 2: Frontend Login UI

- [ ] 🟥 **Task 2.1: Login page component**
  - [ ] 🟥 Write test: Test component rendering and interaction
  - [ ] 🟥 Implement: Design login page component
  - [ ] 🟥 Test: Run `npm test LoginPage.test.jsx`
  - [ ] 🟥 Update PLAN.md (and PLAN-PHASE-2.md if exists)
```

**⏸ CHECKPOINT**: When PLAN.md is ready, say "Plan created. Say 'continue' for Phase 3"

---

## Phase 3: Plan Critique

Review the plan in PLAN.md as a staff engineer using this comprehensive checklist.

**IMPORTANT:** Ensure the plan follows TDD (Test-Driven Development):

- Tests should be written BEFORE implementation code
- Every task should have corresponding test tasks
- Test commands should be listed

### Review Checklist

#### 1. Task Sequencing & Visibility (Including TDD)

- Tests written FIRST, then implementation (strict TDD)
- Early tasks show visible progress without extra work
- Tasks that don't belong are identified for removal
- Missing tasks are identified and added
- Each implementation task has corresponding test task(s)

#### 2. Dependencies & Task Ordering

- Prerequisites completed before dependent tasks
- Independent tasks identified for parallel execution
- Read/understand steps precede modification steps

#### 3. Risk Management & Validation

- High-risk/uncertain tasks scheduled early (fail-fast principle)
- Verification/validation step exists for each major change
- Rollback strategy defined if changes break functionality

#### 4. Scope Control

- Task granularity appropriate (neither too fine nor too coarse)
- Scope creep and tangential work avoided
- Clear stopping point defined (not open-ended)

#### 5. Technical Readiness

- Required files, dependencies, and permissions identified
- Breaking changes identified and mitigation planned
- Backwards compatibility addressed if needed

#### 6. Efficiency & Reuse

- Existing solutions checked before building new ones
- Existing patterns/code identified for reuse
- Unnecessary exploration avoided when path is known

#### 7. Convention & Compliance Pre-Check

- Plan accounts for all rules in `AGENTS.md` and `CLAUDE.md` files (coding style, naming, doc updates, commit format, etc.)
- Tasks that produce doc-mandated side effects (e.g., README updates, CHANGELOG entries) are explicitly included in the plan
- No planned changes contradict project conventions — if a deviation is intentional, it is flagged with justification
- Files outside the feature scope are not modified unless required by a convention (e.g., an index file that must be updated)

#### 8. Communication & Checkpoints

- Natural checkpoints exist to show user progress
- User input/decisions required identified upfront
- Output/deliverable clearly defined

**Additional requirements:**

- PLAN sections should link to QUESTIONS or other .md files where relevant
- This phase may generate questions - write them to `{plan-dir}/QUESTIONS-PLAN-1.md` (and iterate as needed)
- After review, if you identify any ambiguities or missing information, ask questions in QUESTIONS-PLAN-\*.md files

**⏸ CHECKPOINT**: When plan is finalized, say "Plan finalized. Say 'continue' for Phase 4"

---

## Phase 4: Implementation

Now implement precisely as planned, in full.

**Implementation Requirements:**

- Write elegant, minimal, modular code
- Adhere strictly to existing code patterns, conventions, and best practices
- Include clear comments/documentation within the code where needed
- As you implement each step:
  - Update PLAN.md with emoji status and overall progress percen
- Follow TDD: write failing tests first, then implement to make them pass
- Update PLAN.md if implementation reality differs from the original plan
- Update PROMPT.md if new requirements are given by the user

**⏸ CHECKPOINT**: Always pause before commits and ask for user approval

---

## Phase 5: Compliance & Documentation Review

**BEFORE YOU BEGIN - Phase Gate Check:** Verify that Phase 4 (Implementation) is complete and all tests pass. If implementation is not done, STOP and go back to Phase 4.

Launch a **subagent** to perform this review. The subagent must independently verify, do NOT self-review your own work.

**Subagent instructions:**

You are a compliance reviewer. Your job is to verify that all chang4es in this branch respect project conventions and that documentation is up to date. Be thorough and critical - do not rubber stamp.

**Before reviewing, read all files within {plan-dir}.** User answers in those files represent intentional, validated decisions. Do not flag them as violations, they take precedence over general guidelines in `AGENTS.md`/`CLAUDE.md`.

### 1. Convention Compliance

- **Read ALL `AGENTS.md` files** in every directory touched by the changes. Verify every instructions was followed, including ones, that seem trivial (doc updates, formatting rules, ...).
- **Read ALL `CLAUDE.md` files** (project root and any nested ones). Verify coding style, naming conventions, commit message format, and any project-specific rules were respected.
- **Check for scope creep**: Compare the diff against the original task description in `PROMPT.md`. Flag any changes that go beyond what was requested.

### 2. Documentation Accuracy

- For every new or modified public function, type, endpoint or config option: verify that relevant documentation (READMEs, inline docs, API docs, comments) accurately reflects the current code.
- For every removed or renamed symbol: verify that stale references were cleaned up across docs, comments and configuration files.
- If `AGENTS.md` or any project docs mandate doc updates for certain change types, verify those updates were made.

### 3. Consistency Check

- Verify new code follows existing patterns in the codebase (naming, file structure, error handling, test patterns, ...)
- Verify no files were modified outside the scope of the feature.
- Verify test coverage: every new behavior has corresponding tests, and tests actually run and pass.

**Output Format:**

Write findings to `{plan-dir}/REVIEW.md` using this structure:

```markdown
# Compliance & Documentation Review

## ✅ Passing

- [list what's good]

## ⚠️ Suggestions

- [non-blocking improvements]

## 🚫 Must Fix

- [blocking issues that violate AGENTS.md, CLAUDE.md, or leave docs inaccurate]
```

After subagent completes:

1. Read `REVIEW.md`
2. If there are **🚫 Must Fix** items: address them all, then re-run this phase
3. If only ✅ and ⚠️: present findings to user

**⏸ CHECKPOINT**: When review passes with no Must Fix items, say "Compliance review passed. Say 'continue' to finalize."

---

## Phase 6: Submit code

- Update the PROMPT.md file to add all the prompts from this conversation but exclude the `continue`
- Push the code to the remote
- Open a pull request as a draft for the user to review or update the description so that it's accurate with the current modifications, use this format as title: `<service>: <title>`

**⏸ CHECKPOINT**: When code is submitted, say "Ask for user feedback on the current Pull Request"

If the user wants some modifications or additional implementation, go back to Phase 4.

If the user is happy with the current changes and that the current work is associated with a JIRA ticket, ask the user if the ticket should be marked as "In Review".

Once done, move the plan to `{repository_root}}/.plans/archived/{branch-name}/`.
