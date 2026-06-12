---
name: sync-architecture-docs
description: 'Update and align project documentation after code or architecture changes. Use when modifying flows, states, modules, dependencies, contracts, or file structure in SignalEA_v1.'
argument-hint: 'Describe what changed (files, flows, states, dependencies) and what docs should be updated.'
user-invocable: true
---

# Sync Architecture Docs

## When to Use
- You changed execution flow (OnInit/OnTick/OnDeinit).
- You added or modified states, enums, structs, or class responsibilities.
- You changed module dependencies or folder structure.
- You introduced architectural placeholders or deferred implementations.

## Primary Targets
- [ARCHITECTURE.md](../../../ARCHITECTURE.md)
- [README.md](../../../README.md)

## Procedure
1. Collect changed files and identify architecture-impacting changes only.
2. Update architecture docs first:
   - Contracts (enums/structs/interfaces)
   - Runtime flow and sequencing
   - State model and ownership
   - Dependencies and module boundaries
3. Keep docs implementation-neutral when logic is intentionally deferred.
4. Add a short "Recent Architecture Changes" section with bullet points.
5. Verify consistency:
   - Names in docs match source names exactly.
   - No references to non-existent files/classes.
   - No claims of implemented trading logic if still placeholder.
6. Run workspace diagnostics and confirm there are no new errors.
7. Validate with [Documentation Sync Checklist](./references/doc-checklist.md).

## Output Format
- Modified files list.
- Short summary of what changed in docs.
- Any open follow-ups (if docs intentionally defer details).

## Guardrails
- Do not implement trading logic while syncing docs.
- Do not invent modules not present in the codebase.
- Prefer concise, maintenance-friendly wording.
