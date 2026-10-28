#import "theme/theme.typ": *

#show: orion-slides.with(
  title: [Next-Gen Ground Support \ Software System (Orion)],
  subtitle: "Preliminary Design Review",
  date: datetime.today().display("[month repr:long] [day], [year]"),
  authors: (
    (name: "Qian Qian", role: "Software Lead"),
    (name: "Shrey Shingala", role: "Software Lead"),
  ),
  footer-title: "Orion PDR",
)

= Overview

== Overview <overview>

- Omnibus is a data bus that transfers data from a set of data sources
  ("sources") to a set of consumer data sinks ("sinks")
- Key #accent[design drivers]
  - Nested point
    - Third level

== Requirements

+ Add support for a WebSocket transport
+ Standardize message types within the Omnibus library
+ Minimum unit test coverage >= 85%

/ Term: Definition block styling check

= Design

== Key Stack Choices

Dependency management with `uv`; see @overview.

```python
def bridge(msg: Message) -> None:
    # Forward a message to all WebSocket clients
    sio.emit("message", msg.to_dict(), namespace="/omnibus")
```

#quote[All technologies used are founded in industry best practices.]

== Key Stack Choices

#table(
  columns: 3,
  [Layer], [Choice], [Reason],
  [Transport], [Socket.IO], [Rooms, acks],
  [Frontend], [React + Vite], [Tooling],
  [Packaging], [Electron], [Desktop apps],
)

= Action Items

== Action Items

+ Build WebSocket bridge
+ Build Docker infra
+ Define bindings for Omnibus messages
