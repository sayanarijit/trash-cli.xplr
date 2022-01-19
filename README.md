# trash-cli.xplr

Trash files and directories using
[trash-cli](https://github.com/andreafrancia/trash-cli).

[![xplr-trash-cli.gif](https://s6.gifyu.com/images/xplr-trash-cli.gif)](https://gifyu.com/image/Ah1L)

## Requirements

- [trash-cli](https://github.com/andreafrancia/trash-cli)
- [fzf](https://github.com/junegunn/fzf) (for restoring)

## Installation

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  local home = os.getenv("HOME")
  package.path = home
  .. "/.config/xplr/plugins/?/init.lua;"
  .. home
  .. "/.config/xplr/plugins/?.lua;"
  .. package.path
  ```

- Clone the plugin

  ```bash
  mkdir -p ~/.config/xplr/plugins

  git clone https://github.com/sayanarijit/trash-cli.xplr ~/.config/xplr/plugins/trash-cli
  ```

- Require the module in `~/.config/xplr/init.lua`

  ```lua
  require("trash-cli").setup()

  -- Or

  require("trash-cli").setup{
    trash_mode = "delete",
    trash_key = "d",
    restore_mode = "delete",
    restore_key = "r",
    trash_list_selector = "fzf -m | cut -d' ' -f3-"
  }

  -- Type `dd` to trash, `dr` to restore.
  ```

## Features

- Restore multiple files at once using fzf multi select.
