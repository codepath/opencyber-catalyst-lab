# docker/Dockerfile — opencyber-catalyst-lab (CYB102 U6)
# Single-container Incident Response lab on CURRENT Catalyst (v0.15.7): a SQLite-backed
# single Go binary. This retires the legacy 5-service sp24 stack
# (nginx + ArangoDB + MinIO + Authelia + Catalyst v0.10.3) — one container, one `docker run`.
#
# Base on the upstream Catalyst image and add a CodePath banner + a first-run admin bootstrap.
# The upstream image ships the `catalyst` binary + /entrypoint.sh (runs
# `catalyst serve --http 0.0.0.0:8080`) and declares VOLUME /usr/local/bin/catalyst_data.
#
# CONFIRMED (2026-07-23): tag `ghcr.io/securitybrewery/catalyst:v0.15.7` is published and pulls cleanly.
# It is amd64-only (no arm64 variant) — pin the platform so it's deterministic; runs under emulation
# on Apple silicon, the same approach the Splunk lab uses.
FROM --platform=linux/amd64 ghcr.io/securitybrewery/catalyst:v0.15.7

# IMPORTANT (verified 2026-07-24): the catalyst binary resolves its data directory RELATIVE to the
# current working directory (it writes `catalyst_data/data.db`, NOT an absolute path). The upstream
# image leaves WORKDIR unset (= "/"), so data would land in /catalyst_data — which is NOT the
# declared VOLUME (/usr/local/bin/catalyst_data). Setting WORKDIR to /usr/local/bin makes the
# CWD-relative `catalyst_data` resolve to the declared VOLUME, so a `-v catalyst-lab-data:/usr/local/bin/catalyst_data`
# mount actually persists incident data (and the seeded admin). This applies to BOTH `admin create`
# and `serve`, so both must share the same WORKDIR.
WORKDIR /usr/local/bin

# Add an unprivileged 'student' shell user. Catalyst work happens in the browser; the
# entrypoint drops the student into this shell (consistent with the other OpenCyber labs)
# and exiting it shuts the lab down. The server itself runs in the background as root.
RUN useradd -m -s /bin/bash student

# CodePath wrapper: print a banner, seed a known lab admin on first run, start the server
# in the background, then drop the student into an interactive shell (exit = stop the lab).
COPY --chmod=755 docker/entrypoint.sh /usr/local/bin/cp-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/cp-entrypoint.sh"]
