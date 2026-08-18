# Incident Response (Catalyst) Lab: Part 3 — Challenge

[*(back to home)*](https://github.com/codepath/opencyber-catalyst-lab)

Lab Parts:

0. [Setup: Run the lab environment with Docker.](./lab_part0.md)
1. [Learn: The Phishing Incident](./lab_part1.md)
2. [Apply: The Brute-Force Incident](./lab_part2.md)
3. [Challenge: CSIRT — PathCode Malware Investigation](./lab_part3.md) (✅ You are here!)

## Part 3 | Challenge: CSIRT — PathCode Malware Investigation

**Estimated Time:** 60 minutes

**Environment:** Your web browser (`http://localhost:8088`)

**Tools Needed:** Catalyst (running in Docker — see [Part 0](./lab_part0.md) for setup), plus external IOC lookup tools ([VirusTotal](https://www.virustotal.com/), [AbuseIPDB](https://www.abuseipdb.com/))

**[Back to home](https://github.com/codepath/opencyber-catalyst-lab)**

## Overview

You're the **relay analyst** on PathCode's CSIRT. A first responder — **Sam Johnson** — already triaged a malware incident and filed an initial IR report. Your job is to pick up where they left off: document the incident in Catalyst, research each indicator, and then write the analysis that turns a first-responder's notes into a real post-incident record.

This mirrors how CSIRT work actually gets done. The first responder captures *what happened*; a second analyst does the deeper documentation, IOC follow-up, and critique. That relay — and how much the second analyst can do depends entirely on how well the first documented — is the role you're stepping into.

Your deliverable is a short **written analysis** that turns Sam's raw notes into a real post-incident record. Its three analytical pieces — a **gap analysis**, a **detection gap**, and a **recommendation** — are exactly the moves you practiced in [Part 2, Step 5](./lab_part2.md); now you do them on a fresh incident, on your own.

> [!NOTE]
> **Scope:** this lab is the *reactive* side of incident response — handling and documenting an incident that has already been detected. The *proactive* side — hunting for intrusions no one has reported yet — is a separate OpenCyber lab (the **Threat Hunt** lab).

> [!NOTE]
> You'll work from [`reports/ir_report_malware.md`](./reports/ir_report_malware.md). Read it closely — not just for the facts, but as a critic looking for what's *missing*. Then continue the investigation through the Catalyst UI at `http://localhost:8088`.

> [!NOTE]
> You should already be logged in to Catalyst as the lab admin from [Part 0](./lab_part0.md) (`admin@catalyst.lab` / `changeme123`). If not, revisit Part 0.

## The incident, in brief

From Sam's report ([`reports/ir_report_malware.md`](./reports/ir_report_malware.md)): incident **`IR-2023-002`**. User **Jordan Anderson** clicked a link in a social-media post that they thought was a news article, visited a malicious domain, and downloaded a file that turned out to be a **Remote Access Trojan (RAT)**, which executed on **PC-002**. Sam isolated the machine, backed it up, removed the malware, and returned the system — all within about 90 minutes.

Their three indicators:

| Indicator Type | Value | Source |
|----------------|-------|--------|
| Malware Hash (MD5) | `3AADBF7E527FC1A050E1C97FEA1CBA4D` | AntiVirus |
| Malicious IP | `93[.]184[.]216[.]34` | VirusTotal |
| Malicious Domain | `hxxp[:]//bad-weather-app[.]net/download123.doc` | AbuseIPDB |

## Instructions

### Step 1: Pick up the handed-off incident

- [ ] Create the incident in Catalyst from Sam's report (same workflow as Parts 1–2): in the left sidebar under **Tickets** → **Incidents** → **New Ticket**, set the **Name** to the incident ID **`IR-2023-002`**, write a **description in your own words**, and pick a **Severity**. There's no TLP field in this build — you'll justify both severity and TLP in your write-up (not in Catalyst).
- [ ] As you read, note what Sam **did** capture and what they **didn't**. You're not just re-typing their report — you're auditing it. Keep a running list of anything a thorough CSIRT record would want that isn't there.

> [!TIP]
> There's no single correct severity or TLP. What matters is whether your reasoning is specific to *this* incident (a RAT — remote attacker control — on a user endpoint, delivered by social-media social engineering) rather than generic to "malware."

🎯 **Checkpoint 3.1**: The incident exists in Catalyst, and you have notes on what Sam recorded vs. what's missing.

### Step 2: Research the IOCs

- [ ] Document all **three** indicators on the incident — the cleanest way is to **Add Task** for each (hash, IP, domain) so you have a checklist. De-fang the values when you look them up (`93.184.216.34`; `http://bad-weather-app.net/download123.doc`). This domain also has its **colon** defanged — `hxxp[:]//bad-weather-app[.]net` becomes `http://bad-weather-app.net` (`hxxp`→`http`, `[:]`→`:`, `[.]`→`.`).
- [ ] Research **at least two of the three** in [VirusTotal](https://www.virustotal.com/) and [AbuseIPDB](https://www.abuseipdb.com/). Record findings as a **Comment** per indicator (value + type, what the tools said, and your **verdict** — malicious / safe / unknown — in plain words).
- [ ] Find **at least one thing the report didn't say** — a malware family name, a first-seen date, additional abuse reports, associated infrastructure, or even a result that *contradicts* Sam's "malicious" label. Second-tier analysis means going past what the first responder captured.

> [!TIP]
> If a VirusTotal or AbuseIPDB report is dense, ask an AI assistant to pull out the key details — malware classification, confidence level, first-seen date, notable community comments. Verify against the actual report; don't take the summary on faith.

> [!NOTE]
> VirusTotal and AbuseIPDB may disagree about the same indicator — and an indicator may even come back clean. That's normal and worth writing down; disagreement between sources *is* a finding.

🎯 **Checkpoint 3.2**: All three IOCs are documented on the incident (a task or comment each); at least two have a lookup **Comment** with a written verdict; you've flagged at least one finding that adds to or differs from Sam's report.

### Step 3: Gap analysis

Read Sam's report **as a critic**. Find at least one piece of information a thorough CSIRT analyst would want that's **missing or underspecified**. It doesn't have to be a catastrophic flaw — just something a real incident record would normally capture.

- [ ] Write **1–3 sentences**: *what* is missing, and *why it matters* for the investigation or for the next analyst.

<details>
<summary>What makes a strong gap analysis (criteria — not the answer)</summary>

You did this move in [Part 2, Step 5](./lab_part2.md). A strong gap analysis:

- points to something a thorough CSIRT record *would* contain that this one **doesn't** (or leaves vague) — a specific missing fact, not "it could be more detailed";
- explains **why the absence matters** — what the next analyst can't do, or what risk stays open, because it isn't there;
- is grounded in *this* incident (a RAT that ran on an endpoint), not generic.

Read Sam's report and its timeline as a critic and find your own. A good test: can you finish the sentence *"we can't be sure this incident is fully closed because the report never says ___"*?

</details>

🎯 **Checkpoint 3.3**: Your gap analysis is written (1–3 sentences, specific).

### Step 4: Identify the detection gap

A user clicked a link in a social-media post, downloaded a file, and a RAT executed on a company machine. Something in the defensive stack should have stopped that — and didn't.

- [ ] Name the **specific control** that was absent or insufficient. Not "poor security posture" — the actual layer that didn't exist or didn't hold. Where in the chain (link click → domain resolution → file download → execution) did the failure have the most leverage?

<details>
<summary>How specific is specific enough? (criteria — not the answer)</summary>

Use the **defender's-toolkit map from [Part 2, Step 5](./lab_part2.md)**: trace this incident along its chain (link click → domain resolution → file download → execution) and find the step where a control was missing or too weak.

- **Too vague:** *"they needed better security."*
- **Specific enough:** names *one concrete control* (not a posture), says *which step of the chain* it sits at, and says *what it would have stopped*.

Pick the layer where blocking would have broken the chain **earliest** and say why. There's more than one defensible answer — what matters is that it's a specific control tied to a real step in *this* attack.

</details>

🎯 **Checkpoint 3.4**: The detection gap is described, naming a specific control and where in the chain it failed.

### Step 5: Make one concrete recommendation

Propose **one** specific change — to a tool, policy, process, or training practice — that would reduce the likelihood or impact of a similar incident.

- [ ] Write the recommendation so that **someone who doesn't know your org could understand exactly what to implement and how it helps.**

> [!IMPORTANT]
> Two bars to clear. **(1) Specificity:** name the control, the mechanism, and the effect — *"train users on phishing"* doesn't clear it; a good recommendation reads like something an engineer could go implement. **(2) A different layer than Step 4:** your detection gap named the control missing at one point in the chain; your recommendation should add protection at a *different* point (if the gap was at the network, recommend something at the endpoint or at authentication, or vice-versa). That's **defense-in-depth** — you don't want the whole box to depend on one control holding.

🎯 **Checkpoint 3.5**: One concrete, specific, actionable recommendation is written.

> [!NOTE]
> As a final IR step: pick an **incident classification** — True Positive, False Positive, Indeterminate, or Duplicate — and write 1–2 sentences on your reasoning.

### Step 6: Argue the other side (optional stretch)

- [ ] Stress-test your own call. Write two or three sentences making the **strongest case against** one of your verdicts — the most reasonable *counter*-classification, or a defensible *different* severity — and name the one piece of evidence that would settle it. Good analysts know where their own conclusion is soft; finding that yourself is how you close the gap before someone else points at it.

## You're done when

Your written analysis **stands on its own as text** — an assessor (or you, later) could follow the full reasoning without seeing your Catalyst screen. It pulls together:

- **Triage justification** — a sentence or two each on **severity** and **TLP**, specific to this incident.
- **IOC research** — for at least two of the three indicators: what VirusTotal/AbuseIPDB said, plus **one finding that adds to or differs from** Sam's report.
- **Gap analysis** — one specific thing Sam's report is missing, and why it matters.
- **Detection gap** — one specific control that was absent, and where in the chain it sits.
- **Recommendation** — one specific control *at a different layer* than your detection gap (name it, its mechanism, its effect).

This is judgment work, so there's no answer key — but you can hold each piece to the bar yourself. Check:

- [ ] Is every claim **specific to this incident**, not generic to "malware"?
- [ ] Does each analytical piece name a **concrete thing** (a missing fact, a named control) rather than a posture like "better security"?
- [ ] Do your **detection gap and recommendation name two *different* controls/layers** — not the same one twice?
- [ ] Could someone outside your org act on the recommendation exactly as written?

Four yeses means you've met the bar.

**Also do (hands-on — confirms your Catalyst work, not part of the written analysis):** take a screenshot of your completed case showing the incident **Name (`IR-2023-002`)** and at least one indicator you documented (a Comment or a Task). An image can't carry your reasoning, which is why the written analysis has to stand on its own.

### Tips for Success

- **Can't log in to Catalyst?** Use the credentials from the Part 0 banner (`admin@catalyst.lab` / `changeme123`). If they're rejected, the admin account may not have seeded — stop the container, run `docker volume rm catalyst-lab-data` to clear the stale data volume, then re-run the image so it seeds a fresh admin.
- **Page won't load at `http://localhost:8088`?** Give the server a few seconds after startup; confirm you mapped the port (`-p 8088:8080`) and that nothing else is using `8088` (see Part 0).
- **Not sure what "good enough" looks like?** Re-read your [Part 2, Step 5](./lab_part2.md) answers — you already did the gap analysis and detection gap once; Part 3 is the same bar on a new incident.
- **Leverage AI tools:** paste a dense VirusTotal/AbuseIPDB page into an AI assistant to pull out the key facts (malware family, confidence, first-seen) — then verify against the real report before you trust the summary.
