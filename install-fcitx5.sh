OCI_CONTAINER="${RUNNER:docker}"

$OCI_CONTAINER run -itd --name debian-mozc-ut debian-mozc-ut:latest
$OCI_CONTAINER cp debian-mozc-ut:/build-packages/. ./build-packages
sudo dpkg -i build-packages/mozc-data*.deb build-packages/mozc-server*.deb build-packages/mozc-utils-gui*.deb build-packages/fcitx5-mozc*.deb build-packages/fcitx-mozc-data_*.deb
$OCI_CONTAINER stop debian-mozc-ut
$OCI_CONTAINER rm debian-mozc-ut
rm -rf build-packages
