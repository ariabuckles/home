# foldercat: if i fits, i sits

function cat {
  for file in "$@"; do
    if [[ -d "$file" ]]; then
      ls "$ls_color" "$file"
    else
      command cat "$file"
    fi
  done
}
