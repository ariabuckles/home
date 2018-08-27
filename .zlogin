if [[ "$USER" = "ariashell" ]]; then
  echo "zlogin not activating: use a non-login shell to log into ariashell"
elif `id ariashell &>/dev/null`; then
  exec sudo -u ariashell -s
fi