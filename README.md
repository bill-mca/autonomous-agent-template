# Autonomous agent project template

A starting point for a project that an AI coding agent, such as Claude Code, works on by itself over many sessions.

The template gives the agent three things it needs to work well alone: a clear statement of the goal, a place to plan, and a habit of leaving notes for whoever comes next.

## How to use it

1. Click **Use this template** on GitHub, or clone the repo and start a fresh history.
2. Fill in `scope.md` with the aims of your project.
3. Fill in the **Compute** section of `CLAUDE.md` with the machine the agent should use and any limits.
4. Start the Ralph loop with `ralph/ralph.sh`, or start a session by hand and ask the agent to read `CLAUDE.md` and `scope.md` and begin.

The agent will replace this README with one that describes the project as it stands.

## The Ralph loop

`ralph/ralph.sh` runs a fresh, headless Claude Code session over and over, in the manner of Geoffrey Huntley's [Ralph Wiggum technique](https://ghuntley.com/ralph/).
No session remembers the last; everything carries forward through the repo.

There are two kinds of run.

- **A tick** follows `ralph/tick.md`. It takes the first open job in `backlog.md`, does it, commits, and moves the job to `progress.md`. If it spots a chance to improve the project, it may add a job to the bottom of the backlog, labelled `[ralph]`. It may never delete, cancel or reorder anyone else's jobs.
- **A reflection** follows `ralph/reflect.md`. It runs when the backlog has no open jobs, and on every tenth tick. It does no job of its own. Instead it measures the project against `scope.md`, digs through `agent-logs/*.log` for the reasoning behind each job, cancels the jobs that no longer serve the goals, reorders the rest, and rewrites the backlog and specs to steer the next stretch of work. It writes its assessment to `spec/state-of-project.md`.

The loop stops when a reflection leaves no open jobs (the project is done, or everything left is waiting on you), when it reaches its tick limit, after three failed ticks in a row, or when you ask it to:

```sh
ralph/ralph.sh          # run until done
ralph/ralph.sh 5        # run at most five ticks
touch ralph/.state/STOP # stop after the current tick
```

The tick counter and a transcript of every run live in `ralph/.state/`, which git ignores.
Delete `ralph/.state/tick` to start counting again.

**A word on permissions.**
The loop runs with nobody watching, so the agent must be allowed to act without asking.
By default it passes `--permission-mode auto`, which lets Claude Code approve routine actions and refuse risky ones.
Change `RALPH_CLAUDE_ARGS` if you want something stricter or looser, and run the loop on a machine and repo you are content to let it work in.

## What's in the box

| File | Written by | Purpose |
| --- | --- | --- |
| `CLAUDE.md` | Owner | The rules the agent follows: conventions, git hygiene, logging and safety. |
| `scope.md` | Owner | The aims of the project. The most authoritative document here; agents never edit it. |
| `README.md` | Agent | The current state of the repo. |
| `backlog.md` | Agent | Outstanding tasks, one line each, linked to `spec/`. |
| `progress.md` | Agent | Finished tasks, one line each, with commits and logs. |
| `spec/` | Agent | Detailed descriptions of tasks and designs, and the latest reflection's `state-of-project.md`. |
| `ralph/` | Owner | The loop script and the prompts for ticks and reflections. |
| `agent-logs/` | Agent | One log per session, plus a `logs.json` index. |
| `.env.example` | Agent | Every environment variable the project needs. |

## Environment variables

Copy `.env.example` to `.env` and fill in the values.
`.env` is ignored by git, so local paths and secrets stay on your machine.

The template defines only the optional settings for the Ralph loop.
As the agent adds more, it will describe each one here.

| Variable | Default | Meaning |
| --- | --- | --- |
| `RALPH_MAX_TICKS` | `0` | Stop after this many ticks. `0` means no limit. A number given to `ralph/ralph.sh` overrides it. |
| `RALPH_REFLECT_EVERY` | `10` | Run a reflection on every Nth tick. |
| `RALPH_MAX_FAILURES` | `3` | Stop after this many failed ticks in a row. |
| `RALPH_CLAUDE_ARGS` | `--permission-mode auto` | Extra arguments passed to `claude -p`, such as `--model`. |
