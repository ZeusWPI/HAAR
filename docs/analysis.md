# Hydra API access use case analysis

An analysis of the external and internal API's the Hydra applications uses, what the problems in the current approach are, and what the role of HAAR as an intermediary service is.

## Situation overview

As of the start of the academic year 2017-2018, the Hydra apps (both iOS and Android) use hard-coded url's to directly access some external and internal API's.
Most notably are the Minerva API provided by UGent and the resto API provided by Zeus WPI itself.
For a (should be) exhaustive list, visit the [Hydra API document](https://github.com/ZeusWPI/hydra/blob/master/api.md).
The API's listed are a heterogenous collection of various structures, they differ in:

- Temporality: Some are continuously running, being available all around the clock. Some are only needed for special events. There even is some (mostly) static data.
- Access pattern: Some are polled every time the app loads, some very statically, some at fixed intervals.
- Structure: The data is either purely textual, HTML that needs to be rendered, or binary (Urgent.fm music stream).
- Control: Some are controlled by Zeus or close partners, some of them are external and lack any control.
- Security: Most of the data is completely public, but the Minerva API contains some sensitive data.
