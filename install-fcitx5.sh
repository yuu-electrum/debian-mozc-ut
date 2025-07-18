docker run -itd --name debian-mozc-ut debian-mozc-ut:latest
docker cp debian-mozc-ut:/build-packages/. ./build-packages
sudo dpkg -i build-packages/mozc-data*.deb build-packages/mozc-server*.deb build-packages/mozc-utils-gui*.deb build-packages/fcitx5-mozc*.deb build-packages/fcitx-mozc-data_*.deb
docker stop debian-mozc-ut
docker rm debian-mozc-ut
rm -rf build-packages
