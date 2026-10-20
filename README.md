# Autonomous agent project template

A starting point for a project that an AI coding agent, such as Claude Code, works on by itself over many sessions.

The template gives the agent three things it needs to work well alone: a clear statement of the goal, a place to plan, and a habit of leaving notes for whoever comes next.

## How to use it

1. Click **Use this template** on GitHub, or clone the repo and start a fresh history.
2. Fill in `scope.md` with the aims of your project.
3. Fill in the **Compute** section of `CLAUDE.md` with the machine the agent should use and any limits.
4. Start a session and ask the agent to read `CLAUDE.md` and `scope.md` and begin.

The agent will replace this README with one that describes the project as it stands.

## What's in the box

| File | Written by | Purpose |
| --- | --- | --- |
| `CLAUDE.md` | Owner | The rules the agent follows: conventions, git hygiene, logging and safety. |
| `scope.md` | Owner | The aims of the project. The most authoritative document here; agents never edit it. |
| `README.md` | Agent | The current state of the repo. |
| `backlog.md` | Agent | Outstanding tasks, one line each, linked to `spec/`. |
| `progress.md` | Agent | Finished tasks, one line each, with commits and logs. |
| `spec/` | Agent | Detailed descriptions of tasks and designs. |
| `agent-logs/` | Agent | One log per session, plus a `logs.json` index. |
| `.env.example` | Agent | Every environment variable the project needs. |

## Environment variables

Copy `.env.example` to `.env` and fill in the values.
`.env` is ignored by git, so local paths and secrets stay on your machine.

The template defines no variables yet.
As the agent adds them, it will describe each one here.
