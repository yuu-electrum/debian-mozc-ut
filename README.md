# debian-mozc-ut

A helper for building and installing Mozc with UT Dictionary.

## Demo

![Demo](Demo.gif)

# System Requirements

Make sure you have installed below:

- __Docker Engine__ (Can be installed with Docker Desktop but not mandatory. Rootless docker is also suitable to use this helper.)
- __Fcitx5__ (I didn't test the helper on other input method frameworks)
- __Debian 13 (trixie) RC2__ (I've only tested the helper only on it, which yet might be able to work well with Debian 12 (bookworm) and its derivative distributions.)

# How to use

```bash
git clone https://github.com/yuu-electrum/debian-mozc-ut.git
cd debian-mozc-ut
# You need to join groups that allows sudo to members.
# Type your account password when sudo asks
make install-fcitx5
# Creating a backup of this folder is recommended!
rm ~/.config/mozc
sudo reboot
```

# Special Thanks

These script would NEVER exist without websites / repositories mentioned below and I show great appereciation for them.

## [google/mozc](https://github.com/google/mozc)

A multi-platform input method editor developed by Google.

## [utuhiro78/merge-ut-dictionaries](https://github.com/utuhiro78/merge-ut-dictionaries)

A toolset, which aims to merge Mozc UT dictionaries for extensive word vocabulary

## [phoepsilonix/mozc-deb](https://github.com/phoepsilonix/mozc-deb)

Files and patches for building deb files available on Debian and Ubuntu.

Here's a detailed step-by-step guide for how to use, which I referred to make the helper: [Qiita: UbuntuでMozcの新しいバージョンをビルドするには](https://qiita.com/phoepsilonix/items/613ff9f904c5dae8a183)