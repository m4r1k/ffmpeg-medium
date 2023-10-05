FROM intel/intel-optimized-ffmpeg:avx2

ENV MEDIA=media.mp4
ENV SRC=/path/to/src
ENV DST=/path/to/dst

RUN apt update \ 
    && apt install -y --no-install-recommends apt-transport-https ca-certificates gnupg util-linux curl mediainfo \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.asc \
    && apt update \
    && apt install google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/sh", "-c", "/entrypoint.sh"]
