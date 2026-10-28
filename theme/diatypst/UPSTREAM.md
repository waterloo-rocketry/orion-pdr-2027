# Vendored Diatypst

- Upstream: https://github.com/skriptum/Diatypst
- Version: 0.9.3
- Commit: `7ef2c94cc5d4d97d377a6473bad7f6fa83c51ea5` (2026-08-23)
- License: MIT-0 (see `LICENSE`)

This is a copy of the upstream source, not a submodule, so that `lib.typ` can
be edited freely for the Orion theme. Only `lib.typ`, `LICENSE`, `typst.toml`
and the markdown docs (`docs-upstream/`, for reference) were copied.

## Pulling upstream changes

```sh
git clone https://github.com/skriptum/Diatypst /tmp/diatypst
git -C /tmp/diatypst diff 7ef2c94 HEAD -- lib.typ > /tmp/diatypst.patch
git apply --3way /tmp/diatypst.patch   # run from theme/diatypst
```

Then update the commit hash above.

## Local modifications

List every change made to `lib.typ` here so upstream merges stay manageable.

- New parameters: `colors` (palette dict: bg, fg, muted, accent, on-accent,
  surface, surface-strong, rule), `logo`,
  `toc-title`. Colours not given are derived from `title-color` like upstream.
- Body text colour set from `colors.fg` (upstream assumed black on light).
- Header rebuilt as a grid: title (accent bar + text) on the left, counter on
  the right; replaces upstream's negative-`v()` positioning.
- Dot counters share one `dot()` helper; filled dots use `accent`, empty dots
  use `muted`.
- Footer (normal theme): thin rule, `title | subtitle` left, logo right.
- Section slides: left content (SECTION 0N label, title, accent rule) and an
  accent panel on the right with a large faded number; logo bottom-left on
  the dark side.
- Title slide: logo top-left, title, accent rule, subtitle; plain accent panel
  on the right. Logos are never placed on the accent colour. Laid out as a flowing grid (no `place()`), so
  long titles push content instead of overlapping it.
- `authors` entries may be plain names or `(name: ..., role: ...)`; the title
  slide shows one column per author with the role underneath.
- Outline targets level-1 headings only; entries are `0N  Title` rows.
- Tables: minimal, 0.8em text. No frame or vertical lines; one rule under
  the header, full-width hairlines between body rows, columns separated by cell
  padding.
- Quotes, terms, code, refs and figure captions use palette colours.
