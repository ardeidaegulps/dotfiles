---
name: rust-docs
description: Look up documentation and source code for a Rust crate, module, struct, trait, or function using docs.rs only — never by reading source code from the local registry cache, a cloned repo, or crates.io. Use this whenever the user asks about a Rust crate's API, usage, behavior, or implementation.
license: MIT
---

# docs.rs Lookup Skill

Use this skill whenever Rust crate documentation would help answer a question
or complete a task (e.g. figuring out a dependency's API, checking a struct's
fields/methods, or confirming a function's signature/behavior).

**Always use docs.rs for both documentation and source code — never read
source code any other way.** This means:

- Do NOT grep/read a local `~/.cargo`/`target` registry cache or vendored
  source.
- Do NOT clone or fetch the crate's GitHub/GitLab repository.
- Do NOT fetch source from crates.io or any mirror other than docs.rs.
- Do NOT guess at behavior from memory or ask the user instead of checking
  docs.rs.

If you need to see how something is implemented, use docs.rs's own rendered
source view (the `/src/...rs.html` URLs below) — do not fall back to any
other source of the crate's code.

## Instructions

1. Identify the crate name (and version, if known) relevant to the question.
   Check `Cargo.toml` in the current project for the exact version/features if
   available.
2. Fetch the relevant docs.rs page(s) using the `fetch`/web-access tool
   available to you. Useful URL patterns:
   - Crate root: `https://docs.rs/<crate>/latest/<crate>/`
   - Specific item: `https://docs.rs/<crate>/latest/<crate>/<path>/<Item>.html`
   - Search within a crate: `https://docs.rs/<crate>/latest/<crate>/?search=<query>`
   - Specific version: replace `latest` with the exact version, e.g.
     `https://docs.rs/<crate>/1.2.3/<crate>/`
   - Crate names with hyphens are normalized to underscores in the path
     (e.g. `serde-json` -> `serde_json`).
   - Actual source code (not just doc text): use the "Source" link on any
     item's doc page, or fetch directly at
     `https://docs.rs/<crate>/<version>/src/<crate>/<path/to/file>.rs.html`.
     If the rendered/converted page is truncated or hard to read, retry with
     `raw: true` and a larger `max_length` on the same docs.rs URL.
3. Read the fetched page(s) and extract only the information needed to answer
   the question or complete the task (signatures, trait bounds, examples,
   feature flags, etc.).
4. Cite the docs.rs URL you used when giving the answer.
5. If docs.rs doesn't have the crate/version at all (e.g. a private/local-only
   crate), say so explicitly rather than silently reading the source another
   way — do not fall back to the repository or crates.io source.
