# Tmux Documentation

## Introduction

Tmux (Terminal Multiplexer) is a terminal management tool that allows users to run multiple terminal sessions simultaneously. Each session can contain multiple windows, and each window can be split into multiple panes. Below is a comprehensive guide to using Tmux effectively.

---

## Tmux Commands and Shortcuts

### 1. Prefix Key

- **Default Prefix:** `Ctrl + b`
  - The prefix key is required before any Tmux command.

---

### 2. Session Management

- **Detach from Session:** `Ctrl + b` followed by `d`

  - Detaches from the current session without closing it.

- **List Sessions:**

  - Command: `tmux list-sessions` or `tmux ls`
  - Lists all available Tmux sessions.

- **Attach to Session:**

  - Command: `tmux attach` or `tmux a`
  - Reattaches to the last detached session.
  - Attach to a specific session: `tmux attach -t session-name` or `tmux a -t session-name`

- **Rename Session:**

  - Command: `tmux rename-session new-name`
  - Shortcut: `Ctrl + b` followed by `$`

- **Select and Switch Sessions:**

  - `Ctrl + b` followed by `s`
  - Displays a list of sessions for quick switching.

- **Kill (Delete) Session:**

  - Command: `tmux kill-session -t session-name`
  - Shortcut: `Ctrl + b` followed by `:` then type `kill-session`

  - **Kill All Sessions:**
    - Command: `tmux kill-server`
    - Kills the tmux server and all sessions.

---

### 3. Window Management

- **Create a New Window:**

  - `Ctrl + b` followed by `c`

- **Switch to Next Window:**

  - `Ctrl + b` followed by `n`

- **Switch to Previous Window:**

  - `Ctrl + b` followed by `p`

- **Switch to a Specific Window:**

  - `Ctrl + b` followed by the window number.

- **Rename Window:**

  - Command: `tmux rename-window new-name`
  - Shortcut: `Ctrl + b` followed by `,`

- **Kill (Close) Window:**
  - `Ctrl + b` followed by `&`

---

### 4. Pane Management

- **Split Window Vertically:**

  - `Ctrl + b` followed by `%`

- **Split Window Horizontally:**

  - `Ctrl + b` followed by `"`

- **Navigate Between Panes:**

  - `Ctrl + b` followed by arrow keys (←, →, ↑, ↓)`

- **Resize Panes:**

  - Hold `Ctrl + b`, then use arrow keys to adjust pane size.

- **Kill (Close) Pane:**
  - `Ctrl + b` followed by `x`

---

### 5. Summary of Common Commands

| Action                     | Shortcut/Command                    |
| -------------------------- | ----------------------------------- |
| Prefix Key                 | `Ctrl + b`                          |
| Detach from Session        | `Ctrl + b`, `d`                     |
| List Sessions              | `tmux list-sessions` or `tmux ls`   |
| Attach to Session          | `tmux attach` or `tmux a`           |
| Attach to Specific Session | `tmux a -t session-name`            |
| Rename Session             | `Ctrl + b`, `$`                     |
| Kill Session               | `tmux kill-session -t session-name` |
| Kill All Sessions          | `tmux kill-server`                  |
| Create New Window          | `Ctrl + b`, `c`                     |
| Switch to Next Window      | `Ctrl + b`, `n`                     |
| Switch to Previous Window  | `Ctrl + b`, `p`                     |
| Rename Window              | `Ctrl + b`, `,`                     |
| Kill Window                | `Ctrl + b`, `&`                     |
| Split Window Vertically    | `Ctrl + b`, `%`                     |
| Split Window Horizontally  | `Ctrl + b`, `"`                     |
| Navigate Between Panes     | `Ctrl + b` + Arrow Keys             |
| Resize Panes               | Hold `Ctrl + b`, Arrow Keys         |
| Kill Pane                  | `Ctrl + b`, `x`                     |
| Select Session             | `Ctrl + b`, `s`                     |

---

## Conclusion

With these commands and shortcuts, you can efficiently manage terminal sessions, windows, and panes in Tmux. Mastering these will enhance your productivity and allow for smoother terminal workflows.
