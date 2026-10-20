This is a repo for you, as an autonomous agent, to learn to do a specific project.
You will build this repo of code for the project as you go.
In the end you will have a working package of well-tested code, along with documentation of the process by which you built it.

The human who owns this project is called the **owner** below.
The owner is usually not available while you work, so use your judgement, write down your reasoning, and keep moving.

## Documents and who writes them

- `scope.md` is written by the owner. It is their understanding of the aims of the project, and it is the most authoritative document in the repo.
- `scope.md` may not match the repo at any given moment. It can be behind or ahead. Infer which from the commit history, or ask the owner when they are available.
- You never edit `scope.md`.
- `README.md` is written by agents. It reflects the current state of the repo, not its ambitions.
- `spec/` holds detailed descriptions of tasks, designs and decisions. Write a spec whenever a task needs more than a line to explain.
- `backlog.md` is a list of outstanding jobs, most important first. Each is a single named line that links to its description in `spec/`.
- `progress.md` records finished work. When a job is done, move its line from `backlog.md` to the **Done** section of `progress.md`, and add the relevant commits and agent logs. Cancelled jobs go to its **Cancelled** section, with the reason.
- `spec/state-of-project.md` is the latest reflection's assessment of the project against `scope.md`.
- `BLOCKERS.md` is created only when something needs the owner's intervention.

Commit changes to the task files along with the code they describe.

## The Ralph loop

The project is usually driven by `ralph/ralph.sh`, which runs a fresh, headless agent over and over.
Each run is a **tick**.
If you were started by the loop, your prompt will say so, and the rules in `ralph/tick.md` or `ralph/reflect.md` apply on top of this file.

- A **tick** (`ralph/tick.md`) does the first open job in the backlog. It may add new jobs to the bottom, labelled `[ralph]`, but it may not delete, cancel or reorder other jobs.
- A **reflection** (`ralph/reflect.md`) runs when no open jobs remain, and on every tenth tick. It does not do a job. It weighs the project against `scope.md`, revisits the reasoning behind each job in the session logs, cancels jobs that do not serve the goals, and rewrites the backlog and specs to set the course.
- The loop stops when a reflection leaves no open jobs: either the project is finished, or everything left is `[blocked]` on the owner.

## Configuration

- Never write local paths into code or docs. Use environment variables, loaded from a git-ignored `.env`.
- Keep `.env.example` up to date with every variable the project needs.
- Describe every variable in `README.md`.

## Git

### What we track
- We track text and code.
- We do not track model weights, input data, output data or other generated artifacts.
- We do not track editor, environment or agent-tool clutter. Keep `.gitignore` up to date.

### Commits
- Commit early and often, one logical unit of work per commit.
- Use conventional commit messages: `type(scope): description`, where type is one of `feat`, `fix`, `refactor`, `docs`, `test` or `chore`.
- Before committing, run any linters, formatters and tests that exist, and make sure the code builds.

### Branches
- Work on the current branch unless told otherwise.
- Only ever add new commits.
- **Never** use `git reset --hard`, `git push --force`, `git commit --amend`, or rebase existing commits.

## Agent memory

Each session leaves a trail so the next agent can pick up where you left off.

- Log each session to a timestamped file in `agent-logs/`, such as `agent-logs/2026-01-31T09-00.log`. Ralph sessions add their kind and tick number, as in `agent-logs/2026-01-31T09-00-tick-3.log`.
- Append to the log as you go: what you tried, what you learned, and why you chose what you chose.
- Every time you make a commit, describe it carefully in the log.
- At the end of a session, write a ten-line summary at the bottom of the log.
- Then add a one-line summary, with the session's commits, to `agent-logs/logs.json`:

```json
{
  "log": "2026-01-31T09-00-tick-3.log",
  "kind": "tick",
  "tick": 3,
  "summary": "Built the data loader and its tests.",
  "commits": ["a1b2c3d", "e4f5a6b"]
}
```

Sessions started by hand use `"kind": "manual"` and leave out `"tick"`.

To understand earlier sessions quickly, read the git history and cross-check it against `agent-logs/logs.json`, then the individual logs for the reasoning.

## Errors

1. Record the error in your session log.
2. Fix it if the solution is clear.
3. If you are still stuck after three attempts, label the job `[blocked]` in `backlog.md`, explain why in its spec, and add it to `BLOCKERS.md` if it needs the owner.

## Code quality

- Follow the style and conventions already in the repo.
- Comment complex logic.
- Write tests for new functionality.
- Keep functions focused and reasonably sized.
- For Python, use `uv` and a virtual environment. Never install packages system-wide.

## File access and safety

- You have full read and write access to this repository.
- Other repositories are read-only references. Never modify files outside this repo.
- Never use `sudo`, never attempt privilege escalation, and never touch system files.
- Installing packages through package managers, fetching from git remotes and searching the web for documentation are all fine.
- Avoid downloading arbitrary executables.

## Compute

<!-- Owner: describe where work should run, and any limits. For example:
- All computation is done on <machine>, which has <GPU / RAM / disk>.
- Never run a job on a shared login node that will take more than 30 minutes.
-->

## Ending a session

1. Commit all pending changes.
2. Update `progress.md` and `backlog.md`.
3. Write the session summary to your log and to `agent-logs/logs.json`.
