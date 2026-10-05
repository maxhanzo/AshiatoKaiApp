# Ashiato Kai — 足跡・改

**Ashiato Kai** is an open-source iOS application for exploring historical
records of Japanese immigration to Brazil.

It is built with **SwiftUI + Combine** using **MVVM + Coordinator**, targets
**iOS 18+**, and connects to the public
[Ashiato Kai API](https://github.com/maxhanzo/ashiato-kai-api).

The project has two purposes:

1. make an important historical dataset easier for descendants and researchers
   to explore on a modern mobile device; and
2. provide a real-world, open-source SwiftUI/Combine codebase that developers
   can study and extend.

> **The footprints remain. Ashiato Kai helps us follow them.**

## Why "Ashiato Kai"?

**Ashiato (足跡)** means *footprints* or *traces left behind*.

The name honours the original **Projeto ASHIATO**, associated with the
**Museu Histórico da Imigração Japonesa no Brasil / Bunkyo
(Sociedade Brasileira de Cultura Japonesa e de Assistência Social)**.
Volunteers from the Japanese-Brazilian community worked to transcribe,
romanise and digitise historical Japanese immigration records so that this
material could be preserved and searched by later generations.

**Kai (改)** means *revision*, *renewal* or *reworking*.

Ashiato Kai revisits that material with modern software. It does not attempt
to replace the historical project from which the data originated; instead, it
provides another way to explore the records, understand the names and journeys
they contain, and identify entries that may deserve further historical
investigation.

## A living historical dataset

The records exposed by Ashiato Kai should not be treated as a perfectly
normalised modern database.

They originate in historical documents and have passed through several stages
of transcription, interpretation, romanisation and digitisation. As a result,
the dataset contains historical spellings, name variants, missing information,
placeholders and, occasionally, entries that may require correction or further
research.

Ashiato Kai deliberately makes this material searchable.

One of the project's goals is to help descendants, researchers and members of
the Japanese-Brazilian community recognise people, families and journeys in
the records. People familiar with individuals represented in the dataset have
already helped identify data issues, and some records have subsequently been
reviewed and corrected.

The objective is not to silently rewrite the historical source. It is to
improve the quality and understanding of the digital dataset while respecting
the material from which it originated.

This also means that the project may evolve as additional records are reviewed
and better historical information becomes available.

## What Ashiato Kai can — and cannot — tell you

A search result is a **research lead**, not proof of identity, ancestry or
kinship.

People with identical or similar names may be unrelated. Likewise, people
recorded in the same travelling group may be relatives, friends,
acquaintances, co-workers or simply passengers associated with the same group.
Ashiato Kai therefore does **not** infer family relationships from a name match
or group membership.

Japanese names are presented according to the information available in the
dataset. The application does not invent Kanji or Kana from a Romaji name, and
historically meaningful placeholders or uncertain values are not treated as
confirmed facts.

Ashiato Kai helps people **find the footprints**.

Determining whose footprints they are, how people are related, and what those
records mean within a family history requires additional genealogical and
historical research.

## Project philosophy

Ashiato Kai is intentionally:

- **open source** — its implementation can be studied, reviewed and improved;
- **read-only** — the public historical-data API does not require user
  accounts or store personal genealogy research;
- **source-conscious** — historical spellings, variants and placeholders are
  preserved where they carry meaning;
- **non-inferential** — the software does not claim kinship merely because
  names match or records appear together;
- **community-oriented** — knowledge from descendants and researchers can help
  identify records that deserve further investigation; and
- **educational** — the repository is also intended as a practical example of
  a reactive SwiftUI/Combine application with a REST API and explicit
  architectural boundaries.

Ashiato Kai is therefore both a software project and an experiment in making
historical information more accessible to the generations that came after the
immigrants represented within it.

## What the app does

The application currently focuses on historical exploration:

- search immigration records by name and additional voyage/origin criteria;
- inspect individual records and travelling groups;
- explore recorded Japanese names in Romaji and Kanji/Kana;
- visualise Japanese character stroke order;
- copy recorded Japanese names for further research;
- browse immigration statistics, including surnames and prefectures;
- inspect geographic information associated with Japanese prefectures and
  historical places of origin; and
- navigate the application through a reactive Combine-based Coordinator.

The app consumes the public, GET-only Ashiato Kai API. User accounts, private
family trees, personal research notes and other authenticated genealogy
features are deliberately outside the scope of this public project.

## Open and run

1. Open `AshiatoKai.xcodeproj` in Xcode 16 or later with an iOS 18+ SDK.
2. Select the `AshiatoKai` scheme and an iOS 18+ simulator, then Run.
3. For a physical device, select your development team under
   **Signing & Capabilities** and use an appropriate bundle identifier.

The application requires network access to retrieve data from the Ashiato Kai
API.

## Architecture

Ashiato Kai uses:

- **SwiftUI** for the user interface;
- **Combine** for reactive state, networking and navigation;
- **MVVM** for presentation logic;
- a **reactive Coordinator** for navigation;
- **Repository** abstractions between domain logic and remote data;
- **Use Cases** for application operations;
- `URLSession.DataTaskPublisher` for REST networking; and
- dependency injection through `AppContainer`.

The project uses Swift 5 language mode with explicit `MainActor` isolation for
UI objects; this is not a claim of Swift 6 strict-concurrency validation.

A simplified dependency flow is:

```text
AshiatoKaiApp
     |
     v
 AppContainer
     |
     +--> APIClient
     |
     +--> Repositories
     |
     +--> Use Cases
     |
     v
AppCoordinator
     |
     +--> SearchViewModel
     |
     +--> StatisticsViewModel
     |
     v
 SwiftUI Views
```

The Coordinator owns application navigation state and subscribes to navigation
events published by ViewModels. Views do not manipulate navigation subjects
directly.

Factory-created destination ViewModels are owned by their destination views,
while root ViewModels are retained by the Coordinator. This keeps ViewModel
lifetimes aligned with their navigation lifetimes.

## Reactive search behaviour

Search is modelled as a Combine pipeline rather than as an imperative network
callback chain.

User actions become publishers, and requests are transformed into inner
publishers. `switchToLatest()` ensures that a newer search supersedes an older
one, so stale responses cannot replace the result of a more recent request.

Loading, results, empty and failure conditions are represented explicitly in
the search state.

Form state is also reactive. Validation determines whether a search can be
submitted, and navigation events are published separately from view state.

This separation keeps networking, presentation state and navigation concerns
independent while preserving cancellation semantics throughout the pipeline.

## REST API

The app uses the public Ashiato Kai API:

`https://ashiato-kai-api.ashiato-kai.workers.dev`

Source code and API documentation:

`https://github.com/maxhanzo/ashiato-kai-api`

The API is intentionally read-only. Its responsibilities include historical
immigrant records, travelling groups, statistics and geographic information.

The iOS application maps transport DTOs into domain models rather than exposing
the API representation directly to SwiftUI views.

## Data responsibility

Historical and genealogical data require particular care.

Ashiato Kai distinguishes between **what is recorded** and **what can be
concluded from a record**. The application should not transform a probable
match into an assertion about a person's identity or family relationship.

When data is corrected, the aim is to do so on the basis of better historical
information or knowledge supplied by people familiar with the relevant
records, while retaining respect for the provenance of the source material.

If you recognise an entry and believe that some of its information may be
incorrect, please provide as much context and supporting information as
possible when reporting it.

## Contributing

Contributions to the application are welcome, particularly improvements that
preserve the project's architectural boundaries and historical-data
principles.

For data corrections, please distinguish clearly between:

- what appears in the existing record;
- what you believe the corrected value should be; and
- the source or family/historical context supporting the correction.

A name match alone is not sufficient evidence of identity or ancestry.

## Related repository

The backend is maintained separately:

**Ashiato Kai API**  
https://github.com/maxhanzo/ashiato-kai-api

Its README documents the public endpoints, dataset semantics and API-specific
behaviour.

## Disclaimer

Ashiato Kai is a research and historical-exploration tool.

The presence of a person in the dataset, similarity between names, membership
in a travelling group, or any other search result must not be interpreted by
itself as proof of ancestry, kinship or identity.

Historical records may contain omissions, transcription errors, spelling
variants and uncertain information. Important genealogical conclusions should
be checked against additional primary or reliable secondary sources.

## Licence and data provenance

Original Ashiato Kai software source code and project documentation are
licensed under the **Apache License 2.0**. See `LICENSE` and `NOTICE`.

The Apache License applies to the software authored for this project; it does
**not** automatically relicense the historical immigration dataset,
transcriptions, third-party geographic material, artwork, fonts or other
third-party assets. Such material remains subject to its own provenance,
copyright and licensing terms.

In particular, the historical records explored by Ashiato Kai originate from
material associated with Japanese immigration to Brazil and the Projeto
ASHIATO initiative associated with the Museu Histórico da Imigração Japonesa
no Brasil / Bunkyo. Their presence in, or use by, this project should not be
interpreted as an assertion that those records are owned by or licensed under
Apache-2.0 by the Ashiato Kai project.

See `NOTICE` for the project's attribution and third-party-material statement.
