# Incident Response (Catalyst) Lab: Part 1 — Learn

[*(back to home)*](https://github.com/codepath/opencyber-catalyst-lab)

Lab Parts:

0. [Setup: Run the lab environment with Docker.](./lab_part0.md)
1. [Learn: The Phishing Incident](./lab_part1.md) (✅ You are here!)
2. [Apply: The Brute-Force Incident](./lab_part2.md)
3. [Challenge: CSIRT — PathCode Malware Investigation](./lab_part3.md)

## Part 1 | Learn: The Phishing Incident

**Estimated Time:** 45 minutes

**Environment:** Your web browser (`http://localhost:8088`)

**Tools Needed:** Catalyst (running in Docker — see [Part 0](./lab_part0.md) for setup), plus external IOC lookup tools ([VirusTotal](https://www.virustotal.com/), [AbuseIPDB](https://www.abuseipdb.com/))

**[Back to home](https://github.com/codepath/opencyber-catalyst-lab)**

## Overview

You're an analyst on an incident-response team. A phishing email slipped through, a user opened the attachment, and malware ran on their machine. Your job is to turn that raw report into a documented, investigated, closed incident inside Catalyst — the same workflow a real CSIRT follows: **triage → document → investigate → close → debrief.**

This is the fully guided case. Work through every step; in Parts 2 and 3 you'll do the same thing with less step-by-step guidance.

> [!NOTE]
> You'll work from the incident report at [`reports/ir_report_phishing.md`](./reports/ir_report_phishing.md). **Read the whole report first**, then enter its data into Catalyst through the UI at `http://localhost:8088`. Catalyst is where the incident lives; the report is your source material.

## Some vocabulary before you start

An **incident** in Catalyst is a **ticket** (of type *Incident*) — a container that holds everything about one security event: its severity, a description, the tasks worked, comments recording your analysis, and a timeline of what happened. A few terms you'll use:

- **Phishing** — a social-engineering attack that tricks someone into revealing information or running malicious code, usually through a deceptive email or message that impersonates a trusted sender. The lure in this incident was a phishing email carrying a malicious attachment.
- **IOC (Indicator of Compromise)** — a value that points to malicious activity: an IP address, a file hash, a domain, an email address. Each indicator has a **type** (IP, hash, domain, …). You confirm whether an indicator is genuinely malicious by researching it (Step 3). This build of Catalyst has no dedicated "observables" table, so you'll record each indicator — and your verdict on it — as a **Comment** on the incident. (The right-hand **Details** panel also has a **Links** and a **Files** section for attaching related URLs or evidence files, but the analysis itself lives in your comments.)
- **Verdict** — your judgment on an indicator after researching it: **malicious**, **safe**, or **unknown**. There's no verdict dropdown in this build, so you'll state the verdict in plain words inside your comment.
- **TLP (Traffic Light Protocol)** — a convention for how widely information may be shared:
  - **Red** — do not disclose outside the immediate handlers.
  - **Amber** — keep it within the organization.
  - **Green** — may be shared with the wider security community, but keep it out of public channels.
  - **Clear / White** — no sharing restrictions.

  This Catalyst build has **no TLP field**, so you won't set it in the tool. Instead, you'll note what TLP you'd assign (and why) in your write-up / Lessons Learned — the reasoning is the skill, not the click.
- **Severity** — how much this incident should be prioritized. In Catalyst v0.15.7 this is a dropdown with **Low / Medium / High**, set when you create the incident and editable later from the Details panel.
- **Triage** — the first pass on an incident: quickly size up *what it is*, *how bad it is* (severity), and *how widely to share it* (TLP), so the right response starts without delay.

## Instructions

### Step 1: Create and triage the incident

Read [`reports/ir_report_phishing.md`](./reports/ir_report_phishing.md). The header row tells you this is **incident `IR-2023-001`**, a **High**-severity malware incident delivered by a phishing email, handled by Alex Doe, affecting user Casey Smith on system PC-001.

- [ ] In Catalyst's left sidebar, under the **Tickets** heading, click **Incidents**. Then click the **New Ticket** button (top of the incidents view). A **New Ticket** dialog opens (with the line *"Create a new Incident ticket."* under the title) containing exactly three fields: **Name**, **Description**, and **Severity**.

> [!WARNING]
> **Don't click outside the dialog while you're filling it in.** Clicking anywhere off the pop-up form dismisses it and discards whatever you've typed. Fill all three fields and click **Save** before you click elsewhere — and if it does vanish, just click **New Ticket** again and re-enter the fields.

- [ ] Fill in the dialog using the report. Use these values, and jot a one-line justification for each triage choice (you'll reuse the reasoning in your Lessons Learned):

<details>
<summary>✅ What to enter — Name</summary>

Use the report's **incident ID** as the **Name** — copy it exactly:

```
IR-2023-001
```

(This build has no separate "title" field — the Name *is* the ticket's headline.) Using the canonical ID keeps the Catalyst record traceable back to the source report.

</details>

<details>
<summary>✅ What to enter — Description</summary>

Write 2–3 sentences **in your own words**, not a copy-paste of the report. Imagine a teammate opening this case cold. Something like: *"User Casey Smith (PC-001) received a phishing email with a malicious attachment. Opening it executed known-malicious code on the endpoint. System was isolated and restored; documenting IOCs and follow-up."* (You can revise this later with the **Edit** button next to the Description on the ticket page.)

</details>

<details>
<summary>✅ What to enter — Severity</summary>

The **Severity** dropdown offers **Low / Medium / High**. The report rates this **High**, which is defensible: malware (a ransomware variant) actually executed on an endpoint — this isn't a blocked attempt. Note your reasoning: *"High — malware executed on a user endpoint, not merely attempted."*

</details>

<details>
<summary>✅ What to note — TLP</summary>

There's no TLP field in the create dialog (or anywhere in this build). Don't look for one. Instead, decide what TLP you'd assign and **write it down for your Lessons Learned**: **Green** is a reasonable default for a training case — the indicators (a known-bad hash and IP) are the kind of thing you'd share with the security community, but you'd keep the internal details (user, system) confidential. Note: *"Green — indicators shareable with the community; internal specifics stay confidential."*

</details>

- [ ] Click **Save**. Catalyst opens the new ticket's detail page: a type badge (**Incident**), a clickable **Open** status badge, the **Description** with an **Edit** button, and sections for **Tasks**, **Comments**, and **Timeline**, plus a right-hand **Details** panel (Severity, Links, Files).

🎯 **Checkpoint 1.1**: The phishing incident exists in Catalyst with a Name (`IR-2023-001`), a High severity, and a description. You have a one-line severity justification noted, and a TLP you'd assign (with reasoning) written down for your Lessons Learned.

### Step 2: Set up the investigation

The phishing report lists two indicators under **Indicators of Compromise (IoCs)**:

| Indicator Type | Value | Source |
|----------------|-------|--------|
| Malware Hash (MD5) | `44d88612fea8a8f36de82e1278abb02f` | AntiVirus |
| Malicious IP | `45[.]142[.]166[.]228` | VirusTotal |

You'll research each of these in Step 3 and record your findings as a **Comment**. To keep the work organized, give yourself a checklist first using the incident's **Tasks** section.

- [ ] On the ticket page, find the **Tasks** section and click **Add Task**. Add one task per indicator:
  - *Investigate the malware hash (MD5)*
  - *Investigate the malicious IP*

  Tasks are your to-do list for this incident. As you finish researching each indicator in Step 3, you can mark its task done — the same way a real analyst tracks outstanding work on a case.

> [!NOTE]
> **Why is the IP written `45[.]142[.]166[.]228`?** That's **defanging** (sanitization) — the brackets stop the value from becoming a clickable/typo-navigable link so no one accidentally connects to a malicious host. When you look it up in a tool that expects a real IP, you'll remove the brackets → `45.142.166.228`. Sites like VirusTotal understand the defanged form too, but not every tool does. Always handle potentially malicious indicators carefully.

🎯 **Checkpoint 1.2**: You have a task on the incident for each of the two indicators, ready to investigate.

### Step 3: Investigate the IOCs and document them

An indicator only becomes useful when you know its reputation. You'll research each one with two free external tools, then record what you found — and your verdict — as a **Comment** on the incident. That comment is the analysis a second analyst would rely on; it's the heart of this lab.

**VirusTotal** ([virustotal.com](https://www.virustotal.com/)) — reputation for file hashes, IPs, URLs, and domains, aggregated across many antivirus engines.

- [ ] Open VirusTotal in a new browser tab.
- [ ] Search the **malware hash** (`44d88612fea8a8f36de82e1278abb02f`). Note the detection ratio, any malware family names, and the first-seen date.
- [ ] Search the **IP** (`45.142.166.228` — remove the defang brackets). Note how many engines flag it and any associated malicious activity.

**AbuseIPDB** ([abuseipdb.com](https://www.abuseipdb.com/)) — community-reported abuse history for IP addresses.

- [ ] Open AbuseIPDB in a new tab and search the **IP** (`45.142.166.228`). Note the abuse-confidence score, the number of reports, and what categories of abuse were reported.

> [!TIP]
> If a VirusTotal or AbuseIPDB report is dense, paste the key section into an AI assistant (e.g. ChatGPT) and ask it to summarize the reputation, malware family, confidence level, and first-seen date. Use it to make sure you didn't miss anything — not as a substitute for reading the report.

- [ ] Back in Catalyst, open the **Comments** section and click **Add Comment**. An inline *"Type a comment…"* box appears with **Save** / **Cancel**. Write **one comment per indicator** (or one combined comment covering both — your call), and in each, record:
  - the **indicator value and type** (e.g. *"MD5 hash `44d88612…`"* / *"IP `45.142.166.228`"*),
  - **what the tools said** — the detection ratio, abuse-confidence score, malware family, first-seen date, or anything notable,
  - your **verdict in plain words** — *malicious*, *safe*, or *unknown* — and one line on *why*.

  Click **Save**. This is the context the next analyst needs, and — because there's no verdict dropdown in this build — your written verdict *is* the record.

- [ ] Back in the **Tasks** section, mark each indicator's task done now that you've investigated and documented it.

> [!NOTE]
> **Are "known malicious" IPs always reliable?** Not necessarily. Attackers spin up short-lived hosts on cloud providers; an IP flagged as malicious last year may have been recycled to a legitimate service since. Different tools also disagree, because they weigh sources and time windows differently. Always factor in **how recent** the data is when you judge an indicator — and note it in your comment when two tools disagree.

🎯 **Checkpoint 1.3**: Each indicator has a Comment on the incident recording its value/type, what the lookups said, and a written verdict (malicious / safe / unknown) that matches your research. Both investigation tasks are marked done.

### Step 4: Close the incident

You've established what happened, confirmed the indicators, and documented your findings. Per the report's timeline, the system was already isolated, backed up, cleaned, and returned to the user — so there's nothing further to do. Time to close the case.

- [ ] Add the **resolution details** to the incident: what was done (isolation, backup, malware removal, restoration), and what you'd change going forward. The report's timeline gives you the actions; put them in your own words. You can capture this as a **Comment**, add key moments to the **Timeline** (via **Add Timeline Item**), or refine the **Description** with its **Edit** button — pick whatever keeps the case readable for the next analyst.
- [ ] Scroll to the bottom of the ticket. Type a short summary in the **"Closing reason"** box (e.g. *"Malware removed, endpoint restored and verified; IOCs documented as malicious."*), then click **Close Incident**.

> [!NOTE]
> After you close it, the incident moves out of the default open list. To find it again, use the **"Closed"** filter tab in the incidents view. Closing means the response process is complete: indicators documented, findings recorded, resolution captured.

🎯 **Checkpoint 1.4**: The phishing incident is closed in Catalyst (with a closing reason), and its resolution details are captured on the case. It now appears under the **Closed** filter tab.

### Step 5: Write the Lessons Learned

The final phase of incident response is the **Lessons Learned** (a.k.a. *Post-Incident Activity* or *After-Action Review*). This is where you turn one incident into a better response next time. It's a writing task — and reporting is a core cybersecurity skill, not busywork.

First, two things to know:

**Incident classification.** Every handled incident gets classified:
- **True Positive** — a confirmed, genuine security event that needed a response.
- **False Positive** — a false alarm; no real threat.
- **Indeterminate** — not enough information to decide; may need more investigation.
- **Duplicate** — the same event as an already-tracked incident.

**The write-up.** Write a Lessons Learned for the phishing incident. Assume your reader already knows the basic facts — lead with analysis, not a retelling. Use this outline:

- [ ] **Incident Summary** — What happened, and what was the impact?
- [ ] **TTPs (Tactics, Techniques, and Procedures)** — How did the attacker get in (phishing email → malicious attachment → execution)? What did the malware do?
- [ ] **Response Effectiveness** — What worked? Was the issue identified, contained, and eradicated quickly? (The timeline shows ~90 minutes from identification to return-to-user — is that good?)
- [ ] **Improvement Areas** — What could have been handled better? Detection delays? Gaps in communication or tooling?
- [ ] **Future Changes** — What specific change would reduce the chance or impact of a repeat (tools, policies, procedures, training)?
- [ ] **Classification** — Pick one of the four classifications above and explain your reasoning in 1–2 sentences.

> [!TIP]
> Keep your Lessons Learned in a separate document (you'll write more of these in Parts 2 and 3, and the Part 3 write-up is the one you'll do fully on your own). You can also paste it into a **Comment** on the Catalyst incident if you like. This is also where your **TLP** decision lives — you couldn't set it in the tool, so record here what TLP you'd assign and why.

🎯 **Checkpoint 1.5**: Your Lessons Learned is written and you've chosen a classification with reasoning. When you're comfortable with this workflow, [**proceed to Part 2**](./lab_part2.md).
