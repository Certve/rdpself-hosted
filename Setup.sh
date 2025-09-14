# Add user & setup pinggy
sudo useradd -m $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)
sudo adduser $(jq -r '.inputs.username' $GITHUB_EVENT_PATH) sudo
echo $(jq -r '.inputs.username' $GITHUB_EVENT_PATH):$(jq -r '.inputs.password' $GITHUB_EVENT_PATH) | sudo chpasswd
sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $(jq -r '.inputs.computername' $GITHUB_EVENT_PATH)
wget https://s3.ap-south-1.amazonaws.com/public.pinggy.binaries/cli/v0.2.5/linux/amd64/pinggy
chmod +x ./pinggy
echo -e "$(jq -r '.inputs.password' $GITHUB_EVENT_PATH)\n$(jq -r '.inputs.password' $GITHUB_EVENT_PATH)" | sudo passwd "$USER"
rm -f .pinggy.log
./pinggy authtoken $(jq -r '.inputs.authtoken' $GITHUB_EVENT_PATH)
./pinggy tcp 22 --log ".pinggy.log" &
sleep 10
echo "Pinggy Setup Completeed"
