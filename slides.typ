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

== Go Stack

Replacing the current Python stack with a Go stack.

- It is a #accent[typed] language, aligning with our goal of having typed messages schemas and interfaces.
- It compiles to a binary, which
  - is less dependent on the runtime environment,
  - is easier to deploy, and
  - is easier to distribute.

== Go Stack - Key Changes

- Central Processing Server: switching from Python to Go
- Sink and Source modules: switching from Python to Go
- Dependency Management: switching from `uv` to Go's own dependency management tool.
- Testing Framework: switching from `pytest` to Go's built-in testing framework.
  - We might consider using other more feature-rich testing frameworks if it's deemed necessary during development.
- Networking: switching from WebSockets to Protobuf messages over gRPC,
  - it allows for typed messages, and
  - it supports both unary (request-response) and streaming operations, which is useful for supporting both command/info routing and telemetry data streaming.

== Deployment

We continue to deploy on Raspberry Pi.

- Raspberry Pi OS, Docker, and Ansible are kept as they allow the deployment to be reproducible and can be used to redeploy the system quickly and consistently.
- Docker container may be further simplified compared to the Python stack, as the new stack is less dependent on the runtime environment and has fewer dependencies.
- Deliver a single binary, and use different CLI flags to configure the binary to run as different modules (e.g. server, sink, source, etc.), which is easier to deploy and maintain.

== Launch App

#lorem(10)

== Data Studio

We are building Data Studio as a intended replacement for the current Omnibus "Data Processing" scripts, which are not well maintained and not intuitive to use.

#accent[Goal]: a graphical app to review logs and export data, without needing to figure out how to use command-line scripts.

- *Import* Omnibus, Orion and other agreed log formats.
  - For Orion, it strictly follows the Orion data model and API.
- *Plot & Select* series and time ranges interactively.
- *Export* the selection as CSV, images, or other formats.

== Data Studio - Proposed Stack

We want to use a modern web stack (e.g. React + TypeScript + D3.js) for Data Studio frontend, and use Go for the logic and data processing backend, which stays consistent with the rest of Orion system. #link("https://wails.io/")[`Wails`] is the proposed framework for this stack.

- We might consider Vue for the frontend.
- Wails is sort of Electron, but it uses Go as the backend.
  - It is considered usable for the forseeable future and is actively maintained.
  - The newest version (v3.0.0) just released October 26th, 2026.\ The previous version (v2.17.0) was released mid-October 2026.
  - It was actively maintained with regular commits.
  - Unfortunately, it is not as popular and no public record shows that well-known companies or projects are using or backing it.

A dedicated PDR for Data Studio is planned for the near future.

= Data Modeling

= Deployment Architecture

= Testing

= Project Management

== Timelines, and Reviews

#lorem(10)

= Action Items
