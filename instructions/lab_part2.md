# Incident Response (Catalyst) Lab: Part 2 — Apply

[*(back to home)*](https://github.com/codepath/opencyber-catalyst-lab)

Lab Parts:

0. [Setup: Run the lab environment with Docker.](./lab_part0.md)
1. [Learn: The Phishing Incident](./lab_part1.md)
2. [Apply: The Brute-Force Incident](./lab_part2.md) (✅ You are here!)
3. [Challenge: CSIRT — PathCode Malware Investigation](./lab_part3.md)

## Part 2 | Apply: The Brute-Force Incident

**Estimated Time:** 30 minutes

**Environment:** Your web browser (`http://localhost:8088`)

**Tools Needed:** Catalyst (running in Docker — see [Part 0](./lab_part0.md) for setup), plus external IOC lookup tools ([VirusTotal](https://www.virustotal.com/), [AbuseIPDB](https://www.abuseipdb.com/))

**[Back to home](https://github.com/codepath/opencyber-catalyst-lab)**

## Overview

Same workflow as Part 1 — **triage → document → investigate → close → debrief** — this time on a brute-force incident, and more on your own. A new wrinkle: this report has **four** indicators, including a *malicious domain* and a *tool signature*, which stretch how you document indicators.

> [!NOTE]
> You'll work from [`reports/ir_report_brute_force.md`](./reports/ir_report_brute_force.md). Read it first, then enter its data through the Catalyst UI at `http://localhost:8088`.

> [!TIP]
> The steps mirror Part 1. Try each one from memory first; if you get stuck, jump back to the matching section in [Part 1](./lab_part1.md).

## Instructions

### Step 1: Create and triage the incident

The report header: incident **`IR-2023-003`**, a **High**-severity **brute-force** attack handled by Riley Adams against **Server-001**, where the attacker planted **persistence** malware (a hidden foothold that survives reboots and lets them back in) after getting in. The IDS caught it.

- [ ] In the left sidebar under **Tickets**, click **Incidents**, then **New Ticket**. In the **"Create a new Incident ticket."** dialog, set the **Name** to the incident ID (`IR-2023-003`), write a short **Description** in your own words, and pick a **Severity** (Low / Medium / High) — the same field order the dialog shows. Click **Save**. (See [Part 1 § Step 1](./lab_part1.md#step-1-create-and-triage-the-incident) if you need the full how-to.)
- [ ] Note a one-line justification for your **severity** choice. There's still **no TLP field** in this build — decide the TLP you'd assign and record it (with reasoning) for your Lessons Learned, just like Part 1.

<details>
<summary>Hint: how should I think about severity here?</summary>

The report says High. Reason from the facts: the attacker didn't just *attempt* access — they **succeeded** and **established persistence** on a server (not a single user's PC). Persistence on a server is a bigger deal than a single infected endpoint. That supports High (arguably higher than the phishing case). Whatever you pick, justify it from *this* incident, not just "brute force = High."

</details>

🎯 **Checkpoint 2.1**: The brute-force incident exists in Catalyst with a Name (`IR-2023-003`), severity, and description set. Your severity justification and the TLP you'd assign are noted for the write-up.

### Step 2: Document the indicators

This report lists four indicators:

| Indicator Type | Value | Source |
|----------------|-------|--------|
| Tool Signature | `Hydra` (brute-force tool) | IDS |
| Malware Hash (MD5) | `5a064113d8863eb34253dbee7a271974` | AntiVirus |
| Attacker IP | `95[.]181[.]152[.]9` | IDS |
| Malicious Domain | `hxxp://epcdiagnostic[.]com` | IDS |

- [ ] Give yourself a checklist: in the **Tasks** section, **Add Task** for each indicator you'll research — the attacker IP, the malware hash, and the malicious domain. De-fang the values when you look them up: `95[.]181[.]152[.]9` → `95.181.152.9`, and `hxxp://epcdiagnostic[.]com` → `http://epcdiagnostic.com` (the `hxxp` and brackets are sanitization, exactly like the IPs in Part 1).
- [ ] Record the **tool signature** (`Hydra`). This isn't a network indicator to look up — Hydra is the *tool* the attacker used. Capture the fact somewhere on the incident: a **Comment** (*"IDS attributed the activity to the Hydra brute-force tool"*) is the simplest home for it, or note it as a **Timeline** item. What matters is that it's documented on the case.

🎯 **Checkpoint 2.2**: You have a task per lookup-able indicator (IP, hash, domain), and the Hydra tool signature is recorded on the incident as a comment or timeline item.

### Step 3: Investigate the IOCs and document them

- [ ] Look up the **attacker IP** (`95.181.152.9`) in both VirusTotal and AbuseIPDB.
- [ ] Look up the **malware hash** (`5a064113d8863eb34253dbee7a271974`) in VirusTotal.
- [ ] (Optional) Look up the **domain** (`epcdiagnostic.com`) in VirusTotal.
- [ ] Record what you find as a **Comment** per indicator (value + type, what the tools said, and your **verdict** — malicious / safe / unknown — in plain words), then mark each task done. (Same mechanism as [Part 1 § Step 3](./lab_part1.md#step-3-investigate-the-iocs-and-document-them).)

> [!NOTE]
> Don't be surprised if a domain or IP comes back clean or unknown — indicators age, and hosts get recycled (see the note in [Part 1 § Step 3](./lab_part1.md#step-3-investigate-the-iocs-and-document-them)). "Unknown" backed by a real lookup is a legitimate, honest verdict. Note *when* the data is from.

🎯 **Checkpoint 2.3**: Each researched IOC has a Comment recording the lookup and a written verdict.

### Step 4: Close the incident and write Lessons Learned

- [ ] Capture the **resolution** (the report's timeline: detected by IDS → isolated → backed up → malware removed → restored → returned to service) in your own words as a **Comment**, **Timeline** item, or edited **Description**. Then type a short summary in the **"Closing reason"** box at the bottom of the ticket and click **Close Incident**. (The closed case moves to the **Closed** filter tab — see [Part 1 § Step 4](./lab_part1.md#step-4-close-the-incident).)
- [ ] Write a **Lessons Learned** for the brute-force incident, using the same outline as Part 1 (Incident Summary, TTPs, Response Effectiveness, Improvement Areas, Future Changes) and pick a **classification** with reasoning.

<details>
<summary>What's different to think about for a brute-force case?</summary>

The TTPs differ from phishing: this was credential attack → successful access → persistence, not a user-clicked lure. That changes the "Future Changes" recommendation — think account lockout policies, MFA, monitoring failed-auth spikes, and firewall/IDS tuning, rather than email filtering and phishing training. Let the *specific* attack drive the recommendation.

</details>

🎯 **Checkpoint 2.4**: The incident is Closed/Resolved and your Lessons Learned (with a classification) is written.

### Step 5: Analyze the gaps — the Part 3 skills, practiced here

Part 3 asks you to do three short written analyses on a *new* incident, unaided. Two of them you haven't done yet — so practice them here, on this brute-force case, where you can sanity-check your thinking against the report you just worked.

- [ ] **Gap analysis.** Re-read Riley's report as a *critic*. Name **one** piece of information a thorough CSIRT record would contain that this one is missing or leaves vague — plus one sentence on why its absence would hurt the investigation or the next analyst. (A strong gap is *specific* — e.g. "the report never says whether other accounts were checked for the same compromise" — not "it could be more detailed.")

- [ ] **Detection gap.** A defender's job is to name *which control's absence* let the attack land. First, the map — most attacks move through a chain, and a different control can break it at each step:

  > **The defender's toolkit — where controls sit in an attack:**
  > - **Delivery** (a lure or probe reaches you — a phishing email, a social link, a login service exposed to the internet): *email/URL filtering*, *user-awareness training*.
  > - **Access** (the attacker gets in, or the victim connects out): *MFA* and *account-lockout* (stop credential attacks like this one); *DNS/web filtering* (block connections to known-bad domains).
  > - **Payload delivery** (a file is fetched): *web-proxy / download scanning*, *EDR* (Endpoint Detection & Response — software that watches endpoints for malicious behavior).
  > - **Execution** (code actually runs): *EDR*, *application allowlisting* (only approved programs may run).
  >
  > A **detection gap** is just: which of these was missing or too weak at the point where blocking it would have stopped *this* attack earliest?

  Now apply it to the brute-force incident (repeated logins → success → persistence on a server): name the **specific** control that was absent or insufficient, and where in the chain blocking it would have had the most leverage. ("Account lockout after N failed attempts," or "MFA on the exposed service" — not "better security.")

- [ ] **Pair it with a second layer.** Name one *more* control — at a **different** point in the chain than the gap you just named — that would still protect the box if the first control failed. (Named account-lockout at the access step? A second layer might be failed-auth alerting, or network segmentation of the server.) Not depending on one control is **defense-in-depth**, and Part 3 will ask you to turn this pairing into a recommendation.

🎯 **Checkpoint 2.5**: You've written a specific gap analysis, named a specific detection gap, and paired it with a second-layer control — the exact three analytical moves Part 3 asks you to do on your own.

### Step 6: Reconcile disagreeing sources (optional stretch)

Real IOC research isn't tidy — two tools often disagree about the same indicator.

- [ ] Take one indicator (say the attacker IP) and look it up in **both** VirusTotal and AbuseIPDB. If they disagree — different confidence, one flags it and the other doesn't, or the data is stale — write **two sentences** on how you'd adjudicate: which source you'd weight more *for this indicator* and why (recency? number of reports? the kind of abuse each source tracks?). A verdict like "malicious per AbuseIPDB (87%, 40 reports, last seen this month) though VirusTotal is clean — likely a recycled host, treating as suspicious" beats ten that just say "malicious."

When your Lessons Learned and both analyses are written, [**proceed to Part 3**](./lab_part3.md) — the challenge.
