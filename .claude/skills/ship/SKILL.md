---
name: ship
description: Commit all uncommitted changes (staged, unstaged, untracked), push to a branch, and open a PR against the default branch. Uses current branch unless it is the default branch, in which case asks for a Jira ticket and branch description. Use when user says "ship it", "push and open PR", "/ship".
---

# Ship PR

Commit all local changes, push, open PR to default branch.

## Steps

1. **Inspect repo state** (run in parallel):
   - `git status --porcelain` — if empty, stop and tell user nothing to commit.
   - `git branch --show-current`
   - `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` (fallback: `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`)
   - `git diff HEAD` and `git status` to understand changes (read untracked files too if relevant).

2. **Resolve branch + ticket**:
   - **Current branch != default**: use it. Extract Jira key with regex `[A-Z][A-Z0-9]+-[0-9]+` from branch name. If none found, ask user for ticket via AskUserQuestion.
   - **Current branch == default**: ask user (AskUserQuestion, free-text via "Other") for:
     - Jira ticket key (e.g. `JIRA-1234`)
     - Short branch description
     Build branch name: `<TICKET>-<description-kebab-case>` (lowercase description, non-alphanumerics → `-`, collapse repeats, trim, max ~50 chars). Example: `JIRA-1234-add-order-retry-logic`.
     Run `git checkout -b <branch>`.

3. **Fetch ticket context** (optional but preferred): use Atlassian MCP `getJiraIssue` for the ticket key to get summary/description. Use it to sharpen commit title and PR description. If lookup fails, continue without it.

4. **Commit**:
   - `git add -A`
   - Title format: `[<TICKET>] <imperative summary of change>` — e.g. `[JIRA-1234] Add retry logic to order submission`. Keep ≤72 chars.
   - `git commit -m "<title>"` (add body only if needed for non-obvious why).
   - If pre-commit hooks fail: fix issue, re-stage, create NEW commit (never `--amend`, never `--no-verify`).

5. **Push**: `git push -u origin <branch>`.

6. **Open PR**:
   - If PR already exists for branch (`gh pr view --json url` succeeds), report URL and stop (pushed commits update it).
   - Otherwise:
     ```
     gh pr create --base <default> --head <branch> --title "<commit title>" --body "$(cat <<'EOF'
     - <high-level change 1>
     - <high-level change 2>
     EOF
     )"
     ```
   - Title = commit title. If branch has multiple commits ahead of default, summarize the whole set (`git log <default>..HEAD`, `git diff <default>...HEAD`).
   - Body: **bullet points only**, high-level summary of changes. Optionally one leading line linking/referencing the ticket context if it adds clarity. NO headings — no "Summary", "Testing", "Test plan", etc.

7. **Report**: print branch name and PR URL.

## Rules

- Never push to or commit on the default branch directly.
- Never force-push.
- Don't commit obvious secrets (`.env`, credentials, keys) — warn user and exclude them.
- Ticket key always uppercase in commit title and branch name.
