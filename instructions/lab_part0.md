# Incident Response (Catalyst) Lab: Part 0 — Setup

[*(back to home)*](https://github.com/codepath/opencyber-catalyst-lab)

Lab Parts:

0. [Setup: Run the lab environment with Docker.](./lab_part0.md) (✅ You are here!)
1. [Learn: The Phishing Incident](./lab_part1.md)
2. [Apply: The Brute-Force Incident](./lab_part2.md)
3. [Challenge: CSIRT — PathCode Malware Investigation](./lab_part3.md)

## Part 0 | Setup: Run the lab environment with Docker

**Estimated Time:** 15 minutes

**Environment:** Your own computer (Docker + a web browser)

**Tools Needed:** Docker, a web browser


## Overview

Catalyst is an incident-response (IR) platform: a central place to create, track, and document security incidents. In this lab you'll run Catalyst locally in a single Docker container, then use it to work three incidents — a phishing case, a brute-force case, and an independent malware investigation.

Catalyst (v0.15.7) is a single SQLite-backed binary, so the whole platform runs from **one `docker run` command** on your own machine — no cloud VM and no separate services to manage.

By the end of Part 0 you'll have Catalyst running at `http://localhost:8088` and be logged in as the lab admin — ready to work the incidents in Parts 1–3.

## What you'll learn

By the end of this lab you'll be able to:

- **Triage and document a security incident** in a real IR platform — capturing the timeline, evidence, and analyst notes so the case tells a coherent story.
- **Research indicators of compromise (IOCs)** with external tools and record a defensible verdict for each one instead of a gut call.
- **Close a case cleanly** and write a Lessons Learned / post-incident review that a teammate could actually act on.
- **Audit a first responder's report for gaps** — spotting the missing evidence, unverified claims, and loose ends before signing off.

## Instructions

### Step 1: Install and start Docker

- [ ] Make sure you have Docker installed and running on your computer.
  - **Mac**: [Download Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
  - **Windows**: [Download Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
  - **Linux**: [Install Docker Engine](https://docs.docker.com/engine/install/) (or [Docker Desktop for Linux](https://docs.docker.com/desktop/install/linux/))
  - Once installed, open Docker Desktop and confirm it's running before continuing.

- [ ] Open a terminal on your computer:
  - **Mac**: Open **Terminal** (search "Terminal" in Spotlight with ⌘+Space)
  - **Windows**: Open **Command Prompt** or **PowerShell** (search either in the Start menu)
  - **Linux**: Open your system's terminal emulator

### Step 2: Run the lab container

- [ ] Pull and run the lab image:

  ```bash
  docker run --rm -it -p 8088:8080 -v catalyst-lab-data:/usr/local/bin/catalyst_data ghcr.io/codepath/opencyber-catalyst-lab:latest
  ```

  What the flags do:
  - `-p 8088:8080` maps the Catalyst web UI to `http://localhost:8088`.
  - `-v catalyst-lab-data:/usr/local/bin/catalyst_data` stores your incident data in a named Docker volume so your work survives restarts (see the note at the bottom of this page).

- [ ] Wait for the container to print the **"Welcome to the Incident Response (Catalyst) Lab"** banner and drop you to a shell prompt inside the lab box (`student@…`). On the very first run it also seeds the lab admin account and applies the database setup, which takes a few extra seconds. You'll do the actual incident work in your **browser** (next step) — this shell just keeps the lab running (and the server comes up in the background a couple seconds after the banner).

> [!TIP]
> **Port 8088 already in use?** You'll see an error like `port is already allocated` and the UI won't load. Map the web UI to a different **host** port instead: change the number to the *left* of the colon, e.g. `-p 9090:8080`, then open `http://localhost:9090`. With the makefile it's `HOST_PORT=9090 make run`. The lab still uses `8080` *inside* the container — only the host side changes.

> [!TIP]
> Prefer a shorter command? If you cloned this repository, a `makefile` is included:
>
> ```bash
> make run       # builds the image locally, then runs it with the volume mount above
> ```

> [!TIP]
> **Build from source (optional).** The lab image is built on top of the upstream Catalyst image, which is published for **amd64 only** — so the Dockerfile pins `--platform=linux/amd64`. On Apple Silicon it runs fine under emulation (you may see a harmless `platform ... does not match` warning; ignore it). To build it yourself:
>
> ```bash
> git clone https://github.com/codepath/opencyber-catalyst-lab.git
> cd opencyber-catalyst-lab
> docker build -t opencyber-catalyst-lab:local -f docker/Dockerfile .
> docker run --rm -it -p 8088:8080 -v catalyst-lab-data:/usr/local/bin/catalyst_data opencyber-catalyst-lab:local
> ```

### Step 3: Open Catalyst and log in

- [ ] Open your web browser and navigate to `http://localhost:8088`.
- [ ] Log in with the lab admin credentials (they're also printed in your terminal banner):
  - **Email:** `admin@catalyst.lab`
  - **Password:** `changeme123`

> [!NOTE]
> These credentials are intentionally simple because this is a throwaway local lab — nothing here is exposed to the internet. In a real deployment you would never ship a shared, guessable admin password. Worth pausing on: *why* is it acceptable here but not in production?

> [!TIP]
> **Login rejected?** The admin account is seeded automatically on the container's first start. If the credentials above don't work — usually because a first run was interrupted before seeding finished — stop the container, clear the data volume with `docker volume rm catalyst-lab-data`, and run the image again so it seeds a fresh admin.

> [!NOTE]
> The click-by-click steps throughout this lab match **Catalyst v0.15.7**. If you're on a future version and a button or field is named differently, trust what's on your screen.

🎯 **Checkpoint 0.1**: If you can see the Catalyst dashboard at `http://localhost:8088`, your environment is ready. Click around and get a feel for the navigation before moving on. [**Proceed to Part 1**](./lab_part1.md).

> [!IMPORTANT]
> The lab runs for as long as this container is open. When you're done, type `exit` in the lab shell (or close the terminal) to shut it down. Your incident data **persists between sessions** through the `catalyst-lab-data` named volume, so you can stop and restart the container without losing your work. If you ever want a completely clean slate, remove the volume with `docker volume rm catalyst-lab-data` (this deletes all incidents you created).
