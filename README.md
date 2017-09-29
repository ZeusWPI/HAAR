# HAAR
Hydra API Aggregation &amp; Repacking (name up for [discussion](https://github.com/ZeusWPI/HAAR/issues/1)).

## Purpose
HAAR is an API aggregation server. It bundles data from the endpoints currently (directly) in use by the Hydra apps.
Examples can be found [here](https://github.com/ZeusWPI/hydra-shared/blob/master/README.md).
It serves this data itself, from one server, controlled by us.
This has many advantage. We can:
 - Dynamically change the external API links without rebuilding apps
 - Moderate, control and transform data uniformily in a central program, instead of in each app seperately.
 - Handle external API failure
 - Extend external API data and control
 - Handle new and/or updated data better
 - Monitor traffic and usage
 - Easily add new API endpoints
 - Add test/development data
 - Introduce versioning

We can all do this flexibly and centralized without the need for new builds.

## Technology
Up for [discussion](https://github.com/ZeusWPI/HAAR/issues/2).

## Usefull links
 - [Hydra webpage](https://hydra.ugent.be/)
 - [Hydra iOS repo](https://github.com/ZeusWPI/hydra-iOS)
 - [Hydra Android repo](https://github.com/ZeusWPI/hydra-android)
 - [Hydra repo](https://github.com/ZeusWPI/hydra)
