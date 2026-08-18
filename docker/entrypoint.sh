#!/usr/bin/env bash
set -e

g='\033[0;32m'; n='\033[0m'

# --- Lab admin bootstrap -----------------------------------------------------
# VERIFIED 2026-07-24 against catalyst v0.15.7:
#   `catalyst admin create <email> <password>` seeds a login into the SQLite data
#   dir (it also runs the DB migrations on first run). There is NO env var or serve
#   flag for this — the subcommand is the real mechanism.
#
# The data dir is CWD-relative (`catalyst_data/`), and the Dockerfile sets
# WORKDIR=/usr/local/bin, so it resolves to the declared VOLUME
# (/usr/local/bin/catalyst_data). That means the seeded admin persists in the
# `catalyst-lab-data` named volume across `docker run --rm` restarts.
#
# Idempotency: a sentinel file inside the (persisted) data dir ensures we only
# seed once. Repeated `admin create` calls do NOT error but can create duplicate
# records, so the sentinel is what keeps restarts clean.
DATA_DIR="/usr/local/bin/catalyst_data"
SENTINEL="${DATA_DIR}/.lab-admin-created"
ADMIN_EMAIL="${CATALYST_ADMIN_EMAIL:-admin@catalyst.lab}"
ADMIN_PASSWORD="${CATALYST_ADMIN_PASSWORD:-changeme123}"

if [ ! -f "$SENTINEL" ]; then
  echo "First run: seeding the lab admin account (${ADMIN_EMAIL})..."
  # Tolerate a pre-existing account (e.g. a re-used volume) — still mark it seeded.
  /usr/local/bin/catalyst admin create "$ADMIN_EMAIL" "$ADMIN_PASSWORD" >/dev/null 2>&1 || \
    echo "  (admin may already exist — continuing)"
  mkdir -p "$DATA_DIR"
  touch "$SENTINEL"
fi

echo
echo -e "   __   __   __   ___ "
echo -e "  /  \` /  \ |  \ |__  "
echo -e "  \__, \__/ |__/ |___ "
echo -e "   __       ___       "
echo -e "  |__)  /\   |   |__|  "
echo -e "  |    /--\  |   |  |  "
echo -e "        __   __   ___  "
echo -e "  ${g}\|/  ${n}/  \ |__) / _   "
echo -e "  ${g}/|\  ${n}\__/ |  \ \__/  "
echo
echo -e "Welcome to the ${g}Incident Response (Catalyst) Lab${n} environment!"
echo
echo "GETTING STARTED:"
echo -e " ${g}*${n} Open Catalyst in your browser:  http://localhost:8080  (or the host port you mapped)"
echo -e " ${g}*${n} Log in with:"
echo -e "     Email:    ${g}${ADMIN_EMAIL}${n}"
echo -e "     Password: ${g}${ADMIN_PASSWORD}${n}"
echo -e " ${g}*${n} Follow along with the instructions at:"
echo -e "\thttps://github.com/codepath/opencyber-catalyst-lab"
echo -e " ${g}*${n} This shell is your lab box — do the work in the browser above. Type '${g}exit${n}' here (or close the terminal) to shut the lab down."
echo

# --- Work around an upstream restart crash -----------------------------------
# `catalyst serve` re-runs its feature-flag setup on EVERY boot with a plain
# INSERT. On the second run against a persisted DB that row already exists, so
# the server dies at startup with: "UNIQUE constraint failed: features.key".
# Clear the flags table first and let serve repopulate it cleanly. Incident data
# (tickets/tasks/comments/timeline/links/files/users/…) lives in other tables and
# is untouched, so student work still persists across restarts; this is a no-op on
# first run (empty table). python3 ships in the pinned base image (v0.15.7).
if [ -f "${DATA_DIR}/data.db" ]; then
  python3 - "${DATA_DIR}/data.db" <<'PY' 2>/dev/null || true
import sqlite3, sys
db = sqlite3.connect(sys.argv[1])
try:
    db.execute("DELETE FROM features")
    db.commit()
finally:
    db.close()
PY
fi

# Start the Catalyst server in the BACKGROUND, then drop the student into an interactive
# shell — the same model as the other OpenCyber labs. The student works in their browser;
# this shell is the lab "box". When they `exit` (or close the terminal), PID 1 ends, the
# container stops, and the backgrounded server shuts down with it. /entrypoint.sh runs
# `catalyst serve` and inherits WORKDIR=/usr/local/bin (the same data dir seeded above).
/entrypoint.sh >/var/log/catalyst.log 2>&1 &

exec su - student
