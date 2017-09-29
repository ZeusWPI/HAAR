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

## Problems

The current approach acquaints us with some problems, most of which have to do with a lack of flexibility and control.

### Dependencies

We are actively dependant on external services, if their servers go down, the Hydra app goes along with it (also see caching later).
Most of all, we have no control over the data structure and format, resulting in the need for immediate updates to the relevant code when an external API changes formats.
The biggest aspect of this problem is that new app-versions are needed immediately, which require an approval process in the app stores as well as app updates by users.
Both combined will easily result in a resolve-time of a couple of days, even given an immediate reaction on our side. These problems also occur when the API-url is changed.

### Data transformation

Given the data is accessed immediately from some external partners, we are unable to transform any incoming data in a uniform way.
Both implementations (iOS, Android) would need to manipulate the information to the fitting model themselves, which might result in inconsistencies and duplicate work.
Concrete examples might include the lack of ability to query the data, if the API does not provide this functionality. This is very relevant in the handling of old and unwanted data. Currently we need to fetch all information in the client, cache locally, and do local querying. Control over the amount of flowing data would allow is to cut in download sizes where wanted.

### Caching & updates

Given the lack of controllable intermediary, all caching has to happen locally, or not at all. This expresses itself mostly in our inability to detect changes without pulling the entire data set. Given the heavy load of such operations, polling intervals need to be longer to reduce stress and download sizes on the clients, this prevents us from providing rapid updates and maximizing the use of push notifications. Additionally, if no data is cached locally yet (new download, data cleaned), we are unable to retrieve the last known state of a failing endpoint, which might be information relevant still.

### Monitoring

### Global state