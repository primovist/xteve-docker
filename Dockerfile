FROM alpine
LABEL maintainer="primovist" \
        org.label-schema.name="xteve" \

# Dependencies
RUN apk --no-cache add curl vlc ffmpeg tzdata bash && \
rm -rf /var/cache/apk/*

# Add xteve binary
ADD https://github.com/xteve-project/xTeVe-Downloads/raw/master/xteve_linux_amd64.zip /tmp/xteve_linux_amd64.zip

# Unzip the Binary
RUN mkdir -p /xteve && \
unzip -o /tmp/xteve_linux_amd64.zip -d /xteve && \
rm /tmp/xteve_linux_amd64.zip && \
chmod +x /xteve/xteve && \

# Expose Ports for Access
EXPOSE 34400

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --retries=3 --timeout=10s \
  CMD curl -f http://localhost:34400/ || exit 1

# Entrypoint should be the base command
ENTRYPOINT ["/xteve/xteve"]

# Command should be the basic working
CMD ["-port=34400"]
