local function setup(args)
  local xplr = xplr

  if args == nil then
    args = {}
  end

  args.trash_bin = args.trash_bin or "trash-put"
  args.trash_mode = args.trash_mode or "delete"
  args.trash_key = args.trash_key or "d"

  args.restore_bin = args.restore_bin or "trash-restore"
  args.restore_mode = args.restore_mode or "delete"
  args.restore_key = args.restore_key or "r"

  args.trash_list_bin = args.trash_list_bin or "trash-list"
  args.trash_list_selector = args.trash_list_selector or "fzf -m | cut -d' ' -f3-"

  -- Trash: delete
  xplr.config.modes.builtin[args.trash_mode].key_bindings.on_key[args.trash_key] = {
    help = "trash",
    messages = {
      {
        BashExecSilently0 = [===[
          while IFS= read -r -d "" line; do
            if ]===] .. args.trash_bin .. [===[ -- "${line:?}"; then
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
  xplr.config.modes.builtin[args.restore_mode].key_bindings.on_key[args.restore_key] = {
    help = "restore",
    messages = {
      {
        BashExec0 = args.trash_list_bin
          .. ' | grep " $PWD/" | '
          .. args.trash_list_selector
          .. [===[ |
            while IFS= read -r line; do
              if ([ -n "$line" ] && yes 0 | ]===]
          .. args.restore_bin
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

return { setup = setup }
