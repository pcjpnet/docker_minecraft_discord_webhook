#!/bin/bash
set -eoux pipefail

tail -F /data/logs/latest.log |
while read m_time m_server m_type m_user m_msg; do

if [[ $m_type == 'thread/INFO]:' ]]; then
  if [[ $m_msg == 'joined the game' ]]; then
  msg="$TEXT_LOGIN_LEFT $m_user $TEXT_LOGIN_RIGHT";
  curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"content":"'"$msg"'"}' "$WEBHOOK";
  elif [[ $m_msg == 'left the game' ]]; then
  msg="$TEXT_LOGOUT_LEFT $m_user $TEXT_LOGOUT_RIGHT";
  curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"content":"'"$msg"'"}' "$WEBHOOK";
  fi
fi


done
