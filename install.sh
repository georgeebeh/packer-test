#!/bin/bash
sudo apt update

echo "installing java-17"
sudo apt install openjdk-17-jdk

echo "Installing maven"
sudo apt install maven

echo "Downloading and installing packer"
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer

if [[ $? == 0]]

  echo "Installation complete"

else

  echo "Incomplete installation"
fi
