# foldercat: if i fits, i sits

function cat {
  for file in "$@"; do
    if [[ -d "$file" ]]; then
      ls "$ls_color" "$file"
    else
      bat -pp "$file"
    fi
  done
}
