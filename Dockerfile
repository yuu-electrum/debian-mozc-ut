FROM debian:trixie

# Installs dependencies
RUN apt-get update && apt-get install -y sudo apt-utils wget && sed 's/Types: deb *$/Types: deb deb-src/' -i /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get build-dep -y mozc
RUN apt-get install -y build-essential dpkg-dev make git qt6ct qt6-base-dev \
    libfcitx5-qt6-dev curl unzip python3 zip unzip openjdk-21-jdk aria2 \
    fakeroot apt-transport-https curl gnupg locales locales-all dialog

# Installs Bazel required to build Mozc
WORKDIR /root
RUN aria2c -c https://github.com/bazelbuild/bazel/releases/download/7.3.2/bazel-7.3.2-installer-linux-x86_64.sh
RUN bash bazel-7.3.2-installer-linux-x86_64.sh --user && bash ~/.bazel/bin/bazel-complete.bash
ENV PATH="$PATH:/root/bin"
RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg && mv bazel-archive-keyring.gpg /usr/share/keyrings
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | \
    tee /etc/apt/sources.list.d/bazel.list
RUN apt-get update && apt-get install -y bazel
RUN curl -Lo /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-linux-amd64 && chmod +x /usr/local/bin/bazel

# Fetches latest sourcecode of mozc, and files needed to make deb files
RUN mkdir -p build && cd build
RUN git clone --recursive --filter=tree:0 https://github.com/google/mozc.git mozc && \
    git clone --filter=tree:0 -b main https://github.com/phoepsilonix/mozc-deb.git mozc-deb

# Applies patches to Mozc
WORKDIR /root/mozc
RUN cp -a ../mozc-deb/debian ./ && patch -p1 -t -i ../mozc-deb/debian-12.patch && ls debian/patches/*.patch | xargs -n1 -t patch -p1 -i || exit 0

# Fetches and merge UT Dictionary for extensive vocabulary
RUN git clone --depth 1 https://github.com/utuhiro78/merge-ut-dictionaries.git
WORKDIR /root/mozc/merge-ut-dictionaries/src/merge
RUN sed -i 's/#alt_cannadic="true"/alt_cannadic="true"/g' ./make.sh && \
    sed -i 's/#edict2="true"/edict2="true"/g' ./make.sh && \
    sed -i 's/#neologd="true"/neologd="true"/g' ./make.sh && \
    sed -i 's/#skk_jisyo="true"/skk_jisyo="true"/g' ./make.sh
RUN ln -s /usr/bin/python3 /usr/bin/python && bash make.sh && cat mozcdic-ut.txt >> ../../../src/data/dictionary_oss/dictionary00.txt

# Finally builds Mozc and deb files needed
WORKDIR /root/mozc
RUN touch WORKSPACE && fakeroot debian/rules binary
RUN mkdir /build-packages && cp /root/*.deb /build-packages/
