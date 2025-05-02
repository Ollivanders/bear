APT_NON_INTERACTIVE_OPTIONS=' -yq -o APT::Get::AllowUnauthenticated=yes -o Acquire::Check-Valid-Until=false -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confmiss '

if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
  apt-get $APT_NON_INTERACTIVE_OPTIONS update
  apt-get $APT_NON_INTERACTIVE_OPTIONS upgrade
  apt-get $APT_NON_INTERACTIVE_OPTIONS autoremove
  apt-get $APT_NON_INTERACTIVE_OPTIONS clean
elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
  ~/.script/installBrew.sh 2>&1
  ~/.script/macInstall.sh 2>&1
else
  echo "Sorry ${OSTYPE} unsupported"
  exit 0
fi

~/.script/softwareInstall.sh
