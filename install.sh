#!/bin/bash
sudo apt update

echo "installing java-17"
sudo apt install openjdk-17-jdk -y

echo "Installing maven"
sudo apt install maven -y


echo "Downloading and installing packer"
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

file="/usr/share/keyrings/hashicorp-archive-keyring.gpg"

if [[ -f "$file" ]]; then
    echo "$file exists."
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install packer -y
else
    echo "$file does not exist. Please check the wget command and try again."
fi

if [[ $? == 0 ]]; then

  echo "Installation complete"

else

  echo "Incomplete installation"
fi
