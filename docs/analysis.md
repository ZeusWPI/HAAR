# Hydra API access use case analysis

An analysis of the external and internal APIs the Hydra applications uses, what the problems in the current approach are, and what the role of HAAR as an intermediary service is.

## Foreword

Some terms used in this analysis gain their real meaning trough the context in which they are used. To assist and avoid possible confusion we provide this context and intended meaning here.

- Dynamically: _Dynamically_ will often refer to the fact that we don't need to push app updates to all end users, since this process takes several days it sometimes creates difficulties in us trying to be quick to act on external changes and problems.
- Intermediary: The main aspect of _the intermediary_ in following analysis is that it a Zeus WPI controlled service, residing on Zeus WPI controlled servers, able to be updated at wish.
- External API: An API from one our partners (UGent, Schamper, Urgent.fm, ...)
- Internal API: An API already passing trough Zeus WPI services (resto)

## Situation overview

As of the start of the academic year 2017-2018, the Hydra apps (both iOS and Android) use hard-coded URLs to directly access some external and internal APIs.
Most notably are the Minerva API provided by UGent and the resto API provided by Zeus WPI itself.
For a (should be) exhaustive list, visit the [Hydra API document](https://github.com/ZeusWPI/hydra/blob/master/api.md).
The APIs listed are a heterogenous collection of various structures, they differ in:

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

Since no traffic passes between us and the end user, there is no way of monitoring requests, rendering us unable to analyse usage statistics or identify potential issues.

### Global state

There is a complete lack of a global saved state, unless all data is saved on the clients themselves. This prevents us from easily providing aggregate information, or serving data no longer available on the external API. Relevant to the caching of the last known state, having saved state copied from external sources would remove the immediate dependency on those partners for the time until the data becomes stale.

### Dynamicity

We can add special events now, because it comes from an internal API. The lack of consistency on this matter does prevent us from having the ability to dynamically add or remove data across all endpoints. These are necessities if we want to provide a tailored experience, handle automation failures, or manually add special kinds of data.
Relevant to the point about dependencies, we are unable to dynamically change endpoints or data transformers.

## Solution proposal

### In general

We can solve many, if not all, problems listed above by adding in an intermediary between the clients and the external APIs.
This intermediary ( = HAAR ) would be a client fetching data from the external partners, it would store that information and act as a server to our clients (Hydra apps), serving possibly transformed data.

### Solving dependencies

We will always be dependant on our partners, but we could reduce this dependency to only providing the data and content. By introducing HAAR, we allow ourselves to transform incoming data in a flexible and dynamic way, resulting in the ability to keep our client facing API stable. With timely communication between all parties we could more easily serve a smooth transition between incompatible API versions. Saving the data locally will also allow us to keep serving a last known state in case external servers go down (see caching later).

### Allowing data transformation

With an intermediary, we can uniformly (and dynamically) transform data in a central place, reducing code duplication and app-disparity. We could also extend the externally provided functionality. As a concrete example, we could make the information queryable, allowing us for instance to let clients fetch only data in a given time-frame.

### Allowing caching & updates

Given the idea that we would save all external data on the intermediary, we would always have a last known state available. We would allow ourselves to provide data-age information, allowing the clients to request only the needed, new data. This manifests for example in a server being to poll a an external API repeatedly in a short time span, while clients are not, since resources are limited. Clients **could** repeatedly poll the intermediary, since resources needed would be significantly lower, on top of that, the server could take control and _push_ notifications to the client.

### Adding monitoring

Since all traffic passes trough a controlled service, we could easily monitor, register, and analyse traffic and requests.

### Adding global state

If we store all data fetched, we create a global overview, allowing us to create and serve aggregate information (ex. article count) or data no longer available externally. Data could be made unavailable when their servers are down, or they no longer want to provide possible aged information.

### Increasing dynamicity

Present in all other issues mentioned above, the lack of control and dynamicity in our ability to serve data was the key point of this whole endeavour.
By consistently being in control of all client facing endpoints, we act as if all data is ours, and gain the ability to modify data and extend features as if this was the case.
On top of that, we could do this all at wish, (in general) without the need to communicate with and rely on external partners.