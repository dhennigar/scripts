# i3::Utils

A collection of Perl scripts for controlling i3/sway.

## Installation

- `git clone https://github.com/dhennigar/i3-utils`
- `cd i3-utils`
- `perl Makefile.PL`
- `make`
- `make test`
- `make install`

## Usage

`i3-title-status` - prints clock and battery info to the focused window's title bar. basic replacement for a status bar.

`i3-run-or-raise <app_id or class> <exec>` - focus app_id if it exists. else, launch a new instance.

`i3-new-workspace [--take]` - open the lowest available empty workspace. optionally take the current window with you.

`i3-cycle-focus [--reverse]` - emulate "alt-tab" cycling of windows on the current workspace.

`i3-file-picker [--dmenu-command COMMAND --show-hidden]` - use any dmenu-compatible menu as a simple file explorer, opening your selection with `xdg-open`.

`i3-select-window [--dmenu-command COMMAND]` - use any dmenu-compatible menu to select a window and focus it.

`i3-clam-shell` - simple utility to ensure my laptop display is turned off with lid switch events.
