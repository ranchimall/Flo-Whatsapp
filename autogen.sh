#!/bin/sh
echo "----------Welcome to FLO-Whatsapp AutoGen----------"

if [ -f start ]; then
	echo "FLO-Whatsapp is already AutoGen"
	echo "To start run :\n./start <server-password>"
	exit 0
fi

echo "----------Installing TOR----------"
sudo apt-get install tor
echo "----------Configuring Tor for FLO-Whatsapp----------"
echo $PWD
sudo cat <<EOT >> /etc/tor/torrc
HiddenServiceDir $PWD/.hidden_service/
HiddenServicePort 8000 127.0.0.1:8000
EOT
sudo chmod 700 $PWD
echo "----------Finished Configuring----------"
echo "----------Creating Start script----------"
cat > start << EOF
#!/bin/sh
if [ -z "\$1" ];then 
	echo "Enter server password as argument"
	exit 0
fi
app/websocket_chat \$1 &
tor &
sleep 5s
OA=\$(cat .hidden_service/hostname)
zenity --info --text="Open link '\$OA:8000' in onion browser"
wait
EOF
chmod u+x start
echo "----------Finished AutoGen----------"
echo "To start run :\n./start <server-password>"
