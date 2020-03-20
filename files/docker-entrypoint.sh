#! /bin/bash
set -eoux pipefail
echo eula=true > /data/eula.txt

if [ -n "$WEBHOOK" ]; then
   touch /data/logs/latest.log
   curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"content":"'"$TEXT_START"'"}' "$WEBHOOK";
   screen -AmdS info_minecraft bash /opt/log-info.sh
fi

java $JAVA_OPTIONS -jar /opt/minecraft/server.jar &
pid="$!"
trap "echo 'Stopping PID $pid'; kill -SIGTERM $pid" SIGINT SIGTERM

# A signal emitted while waiting will make the wait command return code > 128
# Let's wrap it in a loop that doesn't end before the process is indeed stopped
while kill -0 $pid > /dev/null 2>&1; do
    wait
done
