local xplr = xplr

local q = xplr.util.shell_quote

local function create_restore_action(
  help,
  mode,
  key,
  grep,
  list_bin,
  restore_bin,
  selector
)
  grep = grep or ""
  xplr.config.modes.builtin[mode].key_bindings.on_key[key] = {
    help = help,
    messages = {
      {
        BashExec0 = q(list_bin)
            .. " | "
            .. grep
            .. " "
            .. selector
            .. [===[ |
                  while IFS= read -r line; do
                    if ([ -n "$line" ] && yes 0 | ]===]
            .. q(restore_bin)
            .. [===[ -- "$line" > /dev/null); then
                      "$XPLR" -m "FocusPath: %q" "$line"
                      "$XPLR" -m "LogSuccess: %q" "Restored $line"
                    else
                      "$XPLR" -m "LogError: %q" "Failed to restore $line"
                    fi
                  done

                "$XPLR" -m ExplorePwdAsync
              ]===],
      },
      "PopMode",
    },
  }
end

local function setup(args)
  if args == nil then
    args = {}
  end

  args.trash_bin = args.trash_bin or "trash-put"
  args.trash_mode = args.trash_mode or "delete"
  args.trash_key = args.trash_key or "d"

  args.restore_bin = args.restore_bin or "trash-restore"
  args.restore_mode = args.restore_mode or "delete"
  args.restore_key = args.restore_key or "r"

  args.global_restore_mode = args.global_restore_mode or "delete"
  args.global_restore_key = args.global_restore_key or "R"

  args.trash_list_bin = args.trash_list_bin or "trash-list"
  args.trash_list_selector = args.trash_list_selector or "fzf -m | cut -d' ' -f3-"

  -- Trash: delete
  xplr.config.modes.builtin[args.trash_mode].key_bindings.on_key[args.trash_key] = {
    help = "trash",
    messages = {
      {
        BashExecSilently0 = [===[
          while IFS= read -r -d "" line; do
            if ]===] .. args.trash_bin .. [===[ "${line:?}"; then
              "$XPLR" -m "LogSuccess: %q" "Trashed $line"
            else
              "$XPLR" -m "LogError: %q" "Failed to trash $line"
            fi
          done < "${XPLR_PIPE_RESULT_OUT:?}"
          "$XPLR" -m ExplorePwdAsync
        ]===],
      },
      "PopMode",
    },
  }

  -- Trash: restore
  create_restore_action(
    "restore",
    args.restore_mode,
    args.restore_key,
    'grep " $PWD/" |',
    args.trash_list_bin,
    args.restore_bin,
    args.trash_list_selector
  )

  -- Trash: restore (global)
  create_restore_action(
    "global restore",
    args.global_restore_mode,
    args.global_restore_key,
    nil,
    args.trash_list_bin,
    args.restore_bin,
    args.trash_list_selector
  )
end

return { setup = setup }
