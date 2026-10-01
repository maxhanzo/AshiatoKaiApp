# Ashiato Kai — iOS 18 starter

SwiftUI + Combine, MVVM and a reactive Coordinator. No third-party dependencies.
The project uses Swift 5 language mode with explicit MainActor isolation for UI
objects; it is not a claim of Swift 6 strict-concurrency validation.

## Open and run

1. Open `AshiatoKai.xcodeproj` in Xcode 16 or later with an iOS 18+ SDK.
2. Select the AshiatoKai scheme and an iOS 18+ simulator, then Run.
3. For a physical device, choose your team under Signing & Capabilities and
   replace `com.example.AshiatoKai` with your own bundle identifier.

The app has Search and Options tabs. Search uses fictional local records with a
short artificial delay. Submit an empty form to see all three records, search
for `Tanaka`, or enter `1920` to see two records. All criteria are combined with
AND; text matching ignores case and diacritics. Prefecture is currently free
text because no authoritative API list has been supplied.

Results appear below the form; selecting one pushes a read-only detail screen.
Options is intentionally a placeholder pending product requirements. No app
icon or store submission assets are included.

## Architecture and ownership

- AppContainer is the composition root and injects SearchRepository.
- The app owns AppCoordinator through StateObject.
- AppCoordinator retains SearchViewModel and subscribes to its read-only
  navigation publisher. Views never receive the navigation subject itself.
- SearchViewModel owns form validation, user actions and request state. It has
  no dependency on SwiftUI or a concrete Coordinator.
- AppCoordinator owns selectedTab and the typed Search navigation path.
  SwiftUI's path binding handles back buttons and swipe-to-go-back.
- Each tab has a NavigationStack. Options has no routes yet.
- SearchRepository describes domain operations. MockSearchRepository supplies
  fixtures. URLSessionAPIClient is a separate, reusable transport adapter.
- The detail and Options views have no business logic, so they do not need
  empty ViewModel classes.

This separates responsibilities, permits repository substitution and keeps the
ViewModel dependent on an abstraction. Additional abstractions should follow
real responsibilities rather than adding a protocol for every class.

## Combine behaviour

Search and cancel actions become inner publishers. `switchToLatest()` cancels
the previous subscription whenever another action arrives. Request values are
scheduled on the main queue inside each inner publisher, before switching.
`catch` also lives inside the request publisher, keeping the action stream alive
after an error. Loading, empty, success and failure are explicit states.

Submitting while a request is running replaces it. Cancel and Clear replace it
with idle state. Switching tabs preserves the search and does not cancel it.
Editing fields does not submit automatically; the displayed results belong to
the last submitted search until another search, Cancel or Clear occurs.

The form fields use @Published state, and canSearch and validationMessage are
derived with Combine. Navigation is another typed Combine stream. UI methods
are MainActor isolated; request output reaches UI state on the main queue.
Subscriptions use weak captures where needed and are cancelled with their owner.

## Connect the real REST API later

Do not wire the mock model directly to JSON. Once the contract arrives:

1. Define DTOs matching the real response, including pagination if applicable.
2. Add RemoteSearchRepository conforming to SearchRepository.
3. Build its URLRequest with the actual method, URLComponents/query parameters
   or JSON body, authentication headers and timeout.
4. Inject an APIClient and call `execute(request, as: ResponseDTO.self)`.
5. Map DTOs to SearchRecord and APIError to SearchError.
6. Supply the remote repository in AshiatoKaiApp's AppContainer creation.
7. Replace the demo notices and decide whether prefectures and ships use API
   lookups or remain free text. Adjust the provisional year rules as necessary.

The included transport uses URLSession.DataTaskPublisher, validates 2xx HTTP
status and decodes JSON with a fresh decoder for each subscription. Cancellation
propagates to URLSession. A successful empty body requires a dedicated endpoint
adapter rather than JSON decoding. Authentication, pagination, retries, caching
and server-specific error bodies await the endpoint requirements; none is
silently assumed. The app currently makes no network requests.

Apple reference:
https://developer.apple.com/documentation/foundation/processing-url-session-data-task-results-with-combine

## Verification status and local checks

Project file references, shared scheme XML and archive integrity were checked
in the generation environment. Xcode, Swift and the iOS SDK were unavailable,
so the app has NOT been compiled, simulator-tested or device-tested here.
There is no automated test target in this starter.

Recommended Xcode smoke checks:

- Empty form returns three sample records; Year 1920 returns two.
- Tanaka returns one; an unmatched name shows No results.
- A nonnumeric year or 0 disables Search; clearing the year re-enables it.
- Submit rapidly with different criteria; only the final request should win.
- Submit and immediately Cancel or Clear; no delayed results should appear.
- Select a record, switch to Options, then return; detail navigation persists.
- Navigate back with the button and with the interactive swipe gesture.
- Check keyboard dismissal, Dynamic Type, dark mode and an iPad layout.

When adding automated tests, prioritise controllable repository publishers for
request replacement, cancellation and failure-then-success, and URLProtocol
fixtures for HTTP validation, decoding and network cancellation.
