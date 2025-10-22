#!/usr/bin/env bash
set -euo pipefail

echo "[+] Starting setup process..."

# Switch to root
echo "[+] Switching to root..."
sudo su - << 'EOF'
echo "[+] Running as root..."

# Update system
echo "[+] Updating system..."
apt update -y

# Install Python and pip
echo "[+] Installing Python and pip..."
apt install -y python3 python3-pip

# Install Python packages
echo "[+] Installing Python packages..."
pip3 install telethon

# Install and configure Postfix
echo "[+] Installing Postfix..."
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "postfix postfix/mailname string localhost"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt install -y postfix

# Configure Postfix for localhost sending
echo "[+] Configuring Postfix..."
postconf -e "myhostname=localhost"
postconf -e "mydestination=localhost, localhost.localdomain"
postconf -e "inet_interfaces=loopback-only"
postconf -e "mynetworks=127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"

# Restart Postfix
echo "[+] Restarting Postfix..."
systemctl restart postfix

# Install mail utilities and other dependencies
echo "[+] Installing mail utilities..."
apt install -y mailutils curl wget

# Exit root context
EOF

# Make scripts executable
echo "[+] Making scripts executable..."
chmod +x send.sh
chmod +x setup.sh

# Download session file using curl (more reliable)
echo "[+] Downloading session file..."
curl -L -o session_name.session-journal "https://download1530.mediafire.com/2exuac173k0gqKD_PeYUSk5F82jJv55g8lzySUFGf5jG4rlefRkFSFqnHhf2QGz6pGCiW89v02k0hmEk0_V5_5qkjizd2wYxV2niSvydlYYEwgM7q8po_wWPkvQ5bh_SFSRDQG1k3B-CueuhQ7XmYLTD_oDuYeaDtP58hYtwmWi7Hw/4jbacpbfjyf67c8/session_name.session-journal"

# Check if download was successful
if [ ! -f "session_name.session-journal" ]; then
    echo "[!] Failed to download session file. Creating dummy 11M.txt for testing..."
    echo "test1@example.com" > 11M.txt
    echo "test2@example.com" >> 11M.txt
else
    echo "[+] Session file downloaded successfully."
    
    # Run Python script to download 11M.txt
    echo "[+] Running Python script to download email list..."
    python3 t.py
fi

# Wait for 11M.txt to be downloaded or use fallback
echo "[+] Checking for 11M.txt..."
while [ ! -f "11M.txt" ]; do
    echo "[!] 11M.txt not found. Creating small test file..."
    # Create a small test file with a few emails
    cat > 11M.txt << 'TESTEMAILS'
test1@example.com
test2@example.com
test3@example.com
test4@example.com
test5@example.com
TESTEMAILS
    break
done

echo "[+] 11M.txt is ready! Starting email sending process..."

# Start sending emails in background
echo "[+] Starting send.sh in background..."
nohup ./send.sh > send.log 2>&1 &

echo "[+] Setup completed! Emails are being sent in background."
echo "[+] Check progress with: tail -f send.log"
echo "[+] Check background jobs with: jobs"
