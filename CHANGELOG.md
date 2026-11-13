## [Unreleased]

## [0.1.7] - 2026-11-13

- `OmniReturnsClient` sends production requests to `https://www.omniparcelreturns.com/api/`. Since 12 Nov 2026 Seko redirects the old `/index.php/api/` address with a 307.
- A 3xx response raises `SekoEcomAPI::RedirectError`, a `ParseError` subclass whose message names the new address.

## [0.1.0] - 2023-05-23

- Initial release
