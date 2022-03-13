export PATH=$HOME/.nodebrew/current/bin:$PATH

if which yarn > /dev/null; then
  cd ./Binding && yarn && yarn build
else
  echo "warning: Yarn not installed."
fi
