# Home Lab — System Behavior & Signal Investigation

## Purpose

This lab exists to study how real systems behave under misconfiguration, failure,
and partial understanding — not to showcase tooling, certifications, or environment
complexity.

Work in this lab is driven by specific investigative questions about:
- system behavior
- failure modes
- logging and signal quality
- recovery and hardening decisions

## How This Lab Is Used

The lab is rebuilt, modified, and torn down as questions are answered.

Documentation focuses on:
- what failed
- why it failed
- what signals were misleading or missing
- what changes reduced ambiguity or fragility

Persistent infrastructure is avoided unless it continues to generate new learning.

## Design Constraints

- No long-lived services without an explicit learning goal
- No tool cataloging or vendor comparison
- Labs are dismantled once understanding stabilizes
- Artifacts emphasize findings, not setup walkthroughs

## What This Is Not

- A certification lab
- A showcase of security tools
- A production environment
- A checklist-driven project

## Structure

Individual components (e.g., firewalls, bridges, hosts) include their own focused
documentation describing purpose, configuration decisions, and investigative outcomes.

