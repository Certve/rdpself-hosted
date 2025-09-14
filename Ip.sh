_ERR=$(grep "command failed" < .pinggy.log)

if [[ -z "$_ERR" ]]; then
    echo $(grep -o -E "tcp://(.+)" < .pinggy.log | sed "s/tcp:\/\//ssh $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)@/" | sed "s/:/ -p /")
else
    echo "$_ERR"
    exit 4
fi
rm -f .pinggy.log
./pinggy --remote-management $(jq -r '.inputs.authtoken' $GITHUB_EVENT_PATH)
./pinggy tcp 22 --log ".pinggy.log" &
sleep 10
echo "Pinggy Setup Completeed"