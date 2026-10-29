#import "theme/theme.typ": *

#show: orion-slides.with(
  title: [Next-Gen Ground Support \ Software System (Orion)],
  subtitle: "Preliminary Design Review",
  date: datetime(
    year: 2026,
    month: 10,
    day: 29,
  ).display("[month repr:long] [day], [year]"),
  authors: (
    (name: "Qian Qian", role: "Software Lead"),
    (name: "Shrey Shingala", role: "Software Lead"),
  ),
  footer-title: "Orion - NG Ground Support Software System",
)

= Overview, Motivation & Feasibility

== Overview

#lorem(10)

== Motivation

- Source-level breaking changes currently propagate across the stack, often requiring coordinated changes to dashboards and other consumers.
- Data contracts and system state are spread across multiple components, making behaviour harder to reason about and changes harder to validate.
- Adding new data sources and tooling increases maintenance overhead under the current architecture.
- We want a simpler, more reliable stack with stronger guarantees around shared data structures and interfaces.

== Feasibility

#lorem(10)

= Requirements

== Requirements Overview

The GitHub issues #link("https://github.com/waterloo-rocketry/2026-2027-software-issues/issues/51")[`2026-2027-software-issues#51`] contains and is the root parent of issues containing:

- general technical directions
- design (tasks and decisions)
  - specification
  - API Protocol and Data Model
- implementation (requirements and tasks)

#accent[Please review its content.]

== General Requirements

#table(
  columns: (1fr, 1fr),
  [Requirement], [Motivation],
  [Omnibus MUST remain production-ready until Orion is fully production-ready and is fully replacing Omnibus.], [Allow smooth transition and ensure fallback option exists while issues are ironed out.],
  [Orion SHOULD provide one authoritative API server for telemetry, shared state and command routing.], [Provides a stable boundary between sources and consumers, and avoid system-wide breaks when a source or consumer is updated.],
  [Public interfaces SHOULD be typed, versioned, documented and machine-checked.], [Standardized interfaces to ensure safe interaction and validation of data.],
  [Complete and well organized documentation MUST be provided for all public interfaces, including API, data model, and configuration.], [Ensure that the system is usable and mainytainable by future developers and users.],
  [The deployment of the system MUST be reproducible.], [Ensure that the system can be deployed in a consistent manner.],
  [The system MUST be easy to configure and the configuration methods MUST be documented.], [Ensure that the system can be configured by all users. (Abandoning the current Python-script-based configuration system.)],
)

= Explanation of Key Technological Choices

= Data Modeling

= Deployment Architecture

= Testing

= Project Management

== Timelines, and Reviews

#lorem(10)

= Action Items
