// Diatypst 0.9.3, customized for the Orion deck.
// See UPSTREAM.md for the list of local modifications.

#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)

// Two-digit section number, e.g. 3 -> "03".
#let section-number(n) = if n < 10 { "0" + str(n) } else { str(n) }

#let slides(
  content,
  title: none,
  subtitle: none,
  footer-title: none,
  footer-subtitle: none,
  date: none,
  authors: (),
  layout: "medium",
  ratio: 4/3,
  title-color: none,
  first-slide: true,
  bg-color: white,
  count: "dot",
  footer: true,
  toc: true,
  toc-title: "Contents",
  theme: "normal",
  // Orion additions --------------------------------------------------------
  // Palette overrides; any key left out is derived from title-color/bg-color
  // the same way upstream Diatypst does it.
  colors: (:),
  // Logo for the bg colour (footer, title and section slides). It is never
  // placed on accent-coloured panels.
  logo: none,
) = {

  // Parsing
  if layout not in layouts {
      panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height

  if count not in (none, "dot", "number", "dot-section", "number-short") {
    panic("Unknown Count, valid counts are 'dot', 'dot-section' and 'number', 'number-short', or none")
  }

  if theme not in ("normal", "full") {
      panic("Unknown Theme, valid themes are 'full' and 'normal'")
  }

  // Colors
  if title-color == none {
      title-color = blue.darken(50%)
  }
  let c = (
    bg: bg-color,
    fg: black,
    muted: gray.darken(30%),
    accent: title-color,
    on-accent: bg-color,
    surface: title-color.lighten(90%),
    surface-strong: title-color.lighten(65%),
    rule: title-color.lighten(50%),
  ) + colors
  let block-color = c.surface
  let body-color = c.surface-strong
  let header-color = c.surface-strong
  let fill-color = c.rule

  if (type(authors) != array) {
    authors = (authors,)
  }
  // Authors are plain names or (name: ..., role: ...) dictionaries; `authors`
  // is normalized to dictionaries, `author-names` keeps just the names.
  authors = authors.map(a => if type(a) == dictionary { (role: none) + a } else { (name: a, role: none) })
  let author-names = authors.map(a => a.name)

  // Setup
  set document(
    title: title,
    author: author-names,
  )
  set text(fill: c.fg)
  set heading(numbering: "1.a")
  let section_counter = counter("section")

  // Dot used by the page counters: filled up to the current page.
  let dot(i, current, radius) = link((page: i, x: 0pt, y: 0pt), box(
    circle(
      radius: radius,
      fill: if i <= current { c.accent } else { none },
      stroke: 0.8pt + if i <= current { c.accent } else { c.muted },
    ),
  ))

  // PAGE----------------------------------------------
  set page(
    fill: c.bg,
    width: width,
    height: height,
    margin: (x: 0.5 * space, top: space, bottom: 0.6 * space),
  // HEADER
    header: [
      #set align(top)
      #v(space * 0.3)
      #grid(
        columns: (1fr, auto),
        column-gutter: 0.5em,
        align: (left + horizon, right + horizon),
        rows: space * 0.5,
        // Slide title ----------------------------------------------------
        context {
          let page = here().page()
          let headings = query(selector(heading.where(level: 2)))
          let heading = headings.rev().find(x => x.location().page() <= page)

          if heading != none {
            if (theme == "full") {
              block(
                width: 100%,
                fill: c.accent,
                height: space * 0.85,
                outset: (x: 0.5 * space)
              )[
                #set text(1.4em, weight: "bold", fill: c.on-accent)
                #heading.body
              ]
            } else if (theme == "normal") {
              // Accent bar + title, continuation slides get a muted (ii).
              box(
                width: 0.2em, height: 1.1em, fill: c.accent,
                baseline: 0.15em,
              )
              h(0.45em)
              text(1.35em, weight: "bold", fill: c.fg, heading.body)
              if not heading.location().page() == page {
                h(0.3em)
                text(1.1em, weight: "medium", fill: c.muted,
                  numbering("(i)", page - heading.location().page() + 1))
              }
            }
          }
        },
        // COUNTER ========================================================
        context {
          let last = counter(page).final().first()
          let current = here().page()

          if count == "dot" {
            if last > 20 {
              // Two rows of smaller dots for long decks.
              let limit = calc.ceil(last / 2)
              set par(leading: 0.25em)
              stack(
                spacing: 0.12cm,
                range(1, limit + 1).map(i => dot(i, current, 0.055cm)).join(h(0.06cm)),
                range(limit + 1, last + 1).map(i => dot(i, current, 0.055cm)).join(h(0.06cm)),
              )
            } else {
              range(1, last + 1).map(i => dot(i, current, 0.07cm)).join(h(0.08cm))
            }
          } else if count == "dot-section" {
            let sections = query(heading.where(level: 1))
            let current_section_nr = section_counter.get().at(0)
            let current_section_page = if current_section_nr > 0 {
              sections.at(int(current_section_nr - 1)).location().page()
            } else { 1 }
            let next_section_page = if current_section_nr < int(sections.len()) {
              sections.at(int(current_section_nr)).location().page()
            } else { last + 1 }
            let arrow(angle) = box(rotate(angle, polygon.regular(
              stroke: 0.8pt + c.accent, size: 0.2cm, vertices: 3,
            )))
            if next_section_page - current_section_page >= 3 {
              link((page: current_section_page, x: 0pt, y: 0pt), arrow(-90deg))
              h(0.1cm)
              range(current_section_page + 1, next_section_page)
                .map(i => dot(i, current, 0.07cm)).join(h(0.08cm))
              if next_section_page <= last {
                h(0.1cm)
                link((page: next_section_page, x: 0pt, y: 0pt), arrow(90deg))
              }
            }
          } else if count in ("number", "number-short") {
            set text(weight: "bold", fill: if theme == "full" { c.on-accent } else { c.accent })
            if count == "number" [#current / #last] else [#current]
          }
        },
      )
    ],
    header-ascent: 0%,
  // FOOTER ----------------------------------------------------
    footer: [
      #if footer == true {
        set text(0.6em, fill: c.muted)
        let left-text = if footer-title != none { footer-title } else { title }
        let right-text = if footer-subtitle != none {
          footer-subtitle
        } else if subtitle != none {
          subtitle
        } else if authors != () {
          author-names.join(", ", last: " and ")
        } else [#date]

        if (theme == "full") {
          grid(
            columns: (1fr, 1fr),
            block(width: 100%, outset: (left: 0.5 * space), height: 0.3 * space,
              fill: c.accent, inset: (right: 3pt),
              align(right + horizon, text(fill: c.on-accent, smallcaps(left-text)))),
            block(width: 100%, outset: (right: 0.5 * space), height: 0.3 * space,
              fill: c.surface, inset: (left: 3pt),
              align(left + horizon, right-text)),
          )
        } else if (theme == "normal") {
          line(length: 100%, stroke: 0.5pt + c.rule)
          v(-0.15cm)
          grid(
            columns: (1fr, auto),
            align: (left + horizon, right + horizon),
            [#text(weight: "semibold", left-text) #h(0.4em) #text(fill: c.accent)[|] #h(0.4em) #right-text],
            if logo != none { box(height: 0.3 * space, logo) },
          )
        }
      }
    ],
    footer-descent: 0.15 * space,
  )


  // SLIDES STYLING --------------------------------------------------
  // Section Slides: content and logo on the left, accent panel with the
  // section number on the right.
  show heading.where(level: 1): x => {
    section_counter.step()
    set page(header: none, footer: none, margin: 0cm)
    let n = counter(heading).at(x.location()).first()
    grid(
      columns: (2fr, 1fr),
      rows: 100%,
      block(width: 100%, height: 100%, inset: (x: 0.5 * space, y: 0.5 * space), grid(
        rows: (1fr, auto),
        align(left + horizon)[
          #text(0.9em, weight: "semibold", fill: c.accent, tracking: 0.15em,
            upper[Section #section-number(n)])
          #v(0.1em)
          #text(2em, weight: "bold", fill: c.fg, x.body)
          #v(0.3em)
          #line(length: 2.5cm, stroke: 3pt + c.accent)
        ],
        if logo != none { box(height: 0.35 * space, logo) },
      )),
      block(width: 100%, height: 100%, fill: c.accent, inset: 0.5 * space,
        place(left + horizon,
          text(5em, weight: "bold", fill: c.on-accent.transparentize(80%), section-number(n)))),
    )
  }
  show heading.where(level: 2): pagebreak(weak: true) // this is where the magic happens
  show heading: set text(1.1em, fill: c.accent)


  // ADDITIONAL STYLING --------------------------------------------------
  // Terms
  show terms.item: it => {
    stack(
      block(width: 100%, inset: 5pt, fill: header-color, radius: (top: 0.2em, bottom: 0cm),
        text(fill: c.accent, strong(it.term))),
      block(width: 100%, inset: 5pt, fill: block-color, radius: (top: 0cm, bottom: 0.2em), it.description),
    )
  }


  // Code
  show raw.where(block: false): it => {
    box(fill: block-color, inset: (x: 2pt), outset: (y: 2pt), radius: 2pt)[#text(it)]
  }

  show raw.where(block: true): it => {
    block(radius: 0.4em, fill: block-color, stroke: (left: 2pt + c.accent),
          width: 100%, inset: 1em, it)
  }

  // Bullet List
  show list: set list(marker: (
    text(fill: c.accent)[•],
    text(fill: c.accent)[‣],
    text(fill: c.accent)[–],
  ))

  // Enum
  let color_number(nrs) = text(fill: c.accent)[*#nrs.*]
  set enum(numbering: color_number)

  // Table
  show table: set table(
    stroke: (x, y) => (
      x: none,
      bottom: 0.8pt + c.fg,
      top: if y == 0 { 0.8pt + c.fg } else if y == 1 { 0.4pt + c.fg } else { 0pt },
    )
  )

  show table.cell.where(y: 0): set text(
    style: "normal", weight: "bold", fill: c.accent) // for first / header row

  set table.hline(stroke: 0.4pt + c.fg)
  set table.vline(stroke: 0.4pt + c.fg)

  // Figures
  show figure.caption: set text(0.8em, fill: c.muted)

  // Quote
  set quote(block: true)
  show quote.where(block: true): it => {
    v(-5pt)
    block(
      fill: block-color, inset: 5pt, radius: 1pt,
      stroke: (left: 3pt + c.accent), width: 100%,
      outset: (left: -5pt, right: -5pt, top: 5pt, bottom: 5pt)
      )[#it]
    v(-5pt)
  }

  // Link
  show link: it => {
    if type(it.dest) != str { // Local Links
      it
    }
    else {
      underline(stroke: 0.5pt + c.accent)[#it] // Web Links
    }
  }

  // Outline: one numbered row per section.
  set outline(
    target: heading.where(level: 1),
    indent: auto,
    title: toc-title,
  )
  show outline: set heading(level: 2) // To not make the TOC heading a section slide by itself
  show outline.entry: it => {
    let n = counter(heading).at(it.element.location()).first()
    v(0.35em)
    set text(1.15em)
    link(it.element.location(), grid(
      columns: (2.2em, 1fr),
      text(weight: "bold", fill: c.accent, section-number(n)),
      text(weight: "medium", it.element.body),
    ))
  }

  // Bibliography
  set bibliography(
    title: none
  )

  // References
  show ref: it => {
    // Filter only for links, not for citations
    if it.element != none {
      let el = it.element
      set text(size: 0.7em, fill: c.on-accent)
      box(
        fill: c.accent, outset: (x: 0.0em, y: 0.2em),
        radius: 0.8em,  height: 0.8em, inset: (x:0.5em),
      )[
        // if no supplement is passed
        #if el.func() == heading and it.supplement == auto {
          link(el.location(), el.body)
        } else if el.func() == heading { // if a supplement is passed
          link(el.location(), it.supplement.text)
        } else { // everything else (equations, figures etc)
          it
        }
      ]
    } else { // these are the citations
      return it
    }
  }


  // CONTENT---------------------------------------------
  // Title Slide
  if (title == none) {
    panic("A title is required")
  } else if (first-slide == false) {
    // Remove the first page for custom arrangements
  } else {
    set page(footer: none, header: none, margin: 0cm)
    grid(
      columns: (2fr, 1fr),
      rows: 100%,
      block(width: 100%, height: 100%, inset: (x: 0.5 * space, y: 0.5 * space), grid(
        rows: (auto, 1fr, auto),
        // Logo
        if logo != none { box(height: 0.45 * space, logo) },
        // Title, accent rule, subtitle
        align(left + horizon, {
          set par(leading: 0.45em)
          text(2em, weight: "bold", fill: c.fg, title)
          v(0.1em)
          line(length: 2.5cm, stroke: 3pt + c.accent)
          if subtitle != none {
            v(0.1em)
            text(1.25em, weight: "semibold", fill: c.accent, subtitle)
          }
        }),
        // Authors (one column each: name, role underneath), then date
        {
          set text(0.85em, fill: c.muted)
          if authors != () {
            grid(
              columns: authors.len(),
              column-gutter: 1.5em,
              ..authors.map(a => block(
                stroke: (left: 2pt + c.accent),
                inset: (left: 0.5em, y: 0.1em),
                {
                  text(fill: c.fg, weight: "semibold", a.name)
                  if a.role != none { linebreak(); a.role }
                },
              )),
            )
          }
          if date != none { v(0.4em); date }
        },
      )),
      block(width: 100%, height: 100%, fill: c.accent),
    )
  }

  // Outline
  if (toc == true) {
    outline()
  }
  // The body of the slides
  content

}
