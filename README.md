# Payback coding challenge
Assumptions and remarks:
- I've added motion manager in order to make the transaction details screen less boring, in order to play with it you'll need to use a physical device
- The transction list can be refreshed by both the refresh button as well as the common pull to refresh gesture
- I've made the assumption that the API will always return correct set of values, thus most of the response values are not optional. If we cannot count on the reliability of the API, then I'd suggest making all the response parameters optional.
- I decided against creating a typography style viewModifier for styling Text, as that would be a bit of an overkill for an app this small
- I've created a NetworkManager but decided not to implement actual endpoints or prod/dev environemnts as they are not even testable in the current state. Instead, the networking layer relies on the reading the JSON file provided in the challenge.
