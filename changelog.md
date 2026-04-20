# Changelog

## 5.1.1
- Fixed
  - Media tracker throttling now applies per media name and action to avoid dropping init events for different episodes in rapid succession.
- Added
  - Media tracker unit tests covering same-action, different-media scenarios.

## 5.1.0
- Added
  - XCFramework generation script and build output support.
  - MappIntelligenceLogger.h for React Native plugin integration.
- Fixed
  - NSNull handling in properties and added new unit tests around it.
- Removed
  - requestsPerQueue property (SDK-1703).
