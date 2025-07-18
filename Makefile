build:
	docker build -t debian-mozc-ut:latest . 

install-fcitx5: build
	bash ./install-fcitx5.sh
