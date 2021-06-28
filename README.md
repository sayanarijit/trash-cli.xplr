trash-cli.xplr
==============

Trash files and directories using
[trash-cli](https://github.com/andreafrancia/trash-cli).


Requirements
------------

- [trash-cli](https://github.com/andreafrancia/trash-cli)
- [fzf](https://github.com/junegunn/fzf) (for restoring)


Installation
------------

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  package.path = os.getenv("HOME") .. '/.config/xplr/plugins/?/src/init.lua'
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
    trash_list_selector = "fzf -m | awk '{print $3}'"
  }

  -- Type `dd` to trash, `dr` to restore.
  ```


Features
--------

- Restore multiple files at once using fzf multi select.
