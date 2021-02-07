FROM alpine
LABEL maintainer="primovist" \
        org.label-schema.name="xteve" \
        org.label-schema.version=2.32-r0

# Dependencies
RUN apk --no-cache add curl=7.67.0-r0 vlc=3.0.8-r7 ffmpeg=4.2.1-r3 tzdata=2020a-r0 bash=5.0.11-r1 && \
rm -rf /var/cache/apk/*

# Add xteve binary
ADD https://github.com/xteve-project/xTeVe-Downloads/raw/master/xteve_linux_amd64.zip /tmp/xteve_linux_amd64.zip

# Unzip the Binary
RUN mkdir -p /xteve && \
unzip -o /tmp/xteve_linux_amd64.zip -d /xteve && \
rm /tmp/xteve_linux_amd64.zip && \
addgroup -S xteve && \
adduser -S xteve -G xteve && \
chmod +x /xteve/xteve && \
chown xteve:xteve /xteve/xteve

# Set user contexts
USER xteve

#Create folder structure for backups and tmp files
RUN mkdir /home/xteve/.xteve/ &&b mkdir /home/xteve/.xteve/backup/ && \
mkdir /tmp/xteve && \
chown xteve:xteve /home/xteve/.xteve/ && \
chown xteve:xteve /home/xteve/.xteve/backup/ && \
chown xteve:xteve /tmp/xteve

# Volumes
VOLUME /home/xteve/.xteve

# Expose Ports for Access
EXPOSE 34400

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --retries=3 --timeout=10s \
  CMD curl -f http://localhost:34400/ || exit 1

# Entrypoint should be the base command
ENTRYPOINT ["/xteve/xteve"]

# Command should be the basic working
CMD ["-port=34400"]
