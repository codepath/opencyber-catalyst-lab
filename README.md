# Incident Response Lab

This is the README documentation for the Incident Response Lab, produced and maintained by [CodePath.org](https://codepath.org).

## Quick Start

Want to jump into the lab? Navigate to the [Part 0 Instructions](./instructions/lab_part0.md) to get started!

## About this Lab

<img src="https://i.imgur.com/Wkagn25.png" style="width: 75%; min-width: 350px;" alt="Screenshot of provided Docker Container printing welcome message for Incident Response Lab"></img>

The Incident Response Lab is designed to teach you the full lifecycle of handling a security incident — triage, document, investigate, close, debrief — inside Catalyst, a real open-source IR platform running in your browser. You'll work two fully guided cases (a phishing-delivered malware incident and a brute-force incident), researching indicators of compromise with external tools and recording a defensible verdict for each. Then you'll run an independent malware investigation on your own, and audit a first responder's report for the gaps a careful analyst catches. Reporting is a core cybersecurity skill, and this lab treats it like one.

### Learning Objectives

- Triage and document a security incident in a real IR platform — capturing the timeline, evidence, and analyst notes so the case tells a coherent story
- Research indicators of compromise (IOCs) with external tools and record a defensible verdict for each one instead of a gut call
- Close a case cleanly and write a Lessons Learned / post-incident review a teammate could act on
- Audit a first responder's report for gaps — spotting missing evidence, unverified claims, and loose ends before signing off

### Lab Activities

0. [Setup: Run the lab environment with Docker](./instructions/lab_part0.md)
1. [Learn: The Phishing Incident](./instructions/lab_part1.md)
2. [Apply: The Brute-Force Incident](./instructions/lab_part2.md)
3. [Challenge: CSIRT — PathCode Malware Investigation](./instructions/lab_part3.md)

## Technical Details

### Provided Tools

In Parts 1–3 you'll work primarily in your web browser:

- **Catalyst** - an open-source incident-response platform, served from the container at `http://localhost:8088` (login details are in [Part 0](./instructions/lab_part0.md))
- Three incident reports, bundled into the lab so it's fully self-contained
- External IOC lookup tools - [VirusTotal](https://www.virustotal.com/) and [AbuseIPDB](https://www.abuseipdb.com/) - for researching indicators

Incident data persists across container restarts in a named Docker volume, so you can pick a case back up where you left off.
