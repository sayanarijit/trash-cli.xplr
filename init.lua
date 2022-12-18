local function setup(args)
  local xplr = xplr

  if args == nil then
    args = {}
  end

  if args.trash_mode == nil then
    args.trash_mode = "delete"
  end

  if args.trash_key == nil then
    args.trash_key = "d"
  end

  if args.restore_mode == nil then
    args.restore_mode = "delete"
  end

  if args.restore_key == nil then
    args.restore_key = "r"
  end

  if args.trash_list_selector == nil then
    args.trash_list_selector = "fzf -m | cut -d' ' -f3-"
  end

  -- Trash: delete
  xplr.config.modes.builtin[args.trash_mode].key_bindings.on_key[args.trash_key] = {
    help = "trash",
    messages = {
      {
        BashExecSilently0 = [===[
          while IFS= read -r -d "" line; do
            if trash-put -- "${line:?}"; then
              "$XPLR" -m "LogSuccess: 'Trashed $line'"
            else
              "$XPLR" -m "LogError: 'Failed to trash $line'"
            fi
          done < "${XPLR_PIPE_RESULT_OUT:?}"
          "$XPLR" -m ExplorePwdAsync
        ]===],
      },
      "PopMode",
    },
  }

  -- Trash: restore
  xplr.config.modes.builtin[args.restore_mode].key_bindings.on_key[args.restore_key] = {
    help = "restore",
    messages = {
      {
        BashExec0 = [===[
          trash-list | grep " $PWD/" | ]===] .. args.trash_list_selector .. [===[ |
            while IFS= read -r line; do
              if ([ -n "$line" ] && yes 0 | trash-restore -- "$line" > /dev/null); then
                "$XPLR" -m "FocusPath: %q" "$line"
                "$XPLR" -m "LogSuccess: 'Restored $line'"
              else
                "$XPLR" -m "LogError: 'Failed to restore $line'"
              fi
            done

          "$XPLR" -m ExplorePwdAsync
        ]===],
      },
      "PopMode",
    },
  }
end

return { setup = setup }
