title: RabbitMQ
author:
  name: "Addison"
  twitter: "@addisonj"
output: rabbit.html
controls: false

--

# RabbitMQ
## (How to make messages, win friends, and influence services)

--
### What you should take away
1. RabbitMQ is a pretty awesome
2. How it works
3. How to think in terms of messaging topologies to solve problems

--

### Rabbit, What?

> RabbitMQ is open source message broker software (i.e., message-oriented middleware) that implements the Advanced Message Queuing Protocol (AMQP) standard.
> The RabbitMQ server is written in Erlang and is built on the Open Telecom Platform framework for clustering and failover.
> <cite> --wikipedia </cite>

--

<img src="./images/words.jpg" style="margin-left: auto; margin-right: auto; display: block"/>

--
### Not that difficult

* Messages - you know, messages!
* Broker - Takes care of things on your behalf
* AMQP - a spec which RabbitMQ happens to implement (kinda)
* Erlang - fancy!
* Open Telecom Platform - read as "fault tolerant and scalable"
* clustering and failover - read as "fault tolerant and scalable"

--
### In other words

Rabbit is really good at dealing with messages and messaging
patterns that allow you to do cool things.

It also happens to be able to do these things in a really
fast, scalable, and fault tolerant way

--
### Why can't I use HTTP?

* HTTP is awesome!
* _(in a request response cycle)_
* However, it lacks __flow control__
  * Back pressure, retries, acknowledgements
  * RabbitMQ, however, has these things

--
### Demo Time
Say that I generate resources based upon a third-pary stream of data.

Two Approaches:

1. POST it over HTTP
2. Work Queue

--
###  Vocab
In order to understand rabbit, you need some vocab:

* Publishers - clients who connect to rabbit and write messages
* Consumers - clients who connect to rabbit and get messages from it
* Brokers - the broker take messages from **publishers** and route them to **consumers**

<p style="font-size:16px"> NOTE: a single client can be both a consumer and a publisher </p>

--
###  Parts
The routing of messages is the core thing rabbit does for you. It uses some key parts to make that happen:

* Queues - a container for messages, **consumers** connect to queues to read messages
* Exchanges - **publishers** write messages to exchanges, exchanges write messages to **queues** based upon **bindings**
* Bindings - a binding connects a queue to an exchange

--
###  Topics and Bindings
The flexibility and power of RabbitMQ comes from **bindings**

* Every message in RabbitMQ is given a **topic**
* This topic defines what the message pertains to and is namespaced via periods
* EX:myservice.v1.myresource.update
* Totally arbitrary

<span style="font-size:14px"> NOTE: The bindings you can use depends on the type of <strong>exchange</strong> you are using. The most flexible is a topic exchange and is what we are covering here </span>

--
###  Topics and Bindings

When a **queue** wants messages routed to it, it defines a **binding** with a **key** that defines a pattern for messages
to be routed to it.

* EX: myservice.v1.myresource.update is ALSO a key, that exactly matches the topic
* There are two special pattern matching helpers
  * \*
  * \#

--
### \*
The \* masks out a single namespace

* EX: myservice.v1.\*.update
  * myservice.v1.foo.update, myservice.v1.bar.update both match
  * myserivce.v1.foo.bar.update would NOT match
--
### #
The # masks out all namespaces that follow

* EX: myservice.v1.#
 * myservice.v1.foo.bar.baz, myservice.v1.so.long.ah would both match
 * myservice.v1 would NOT match
--
### Messaging Topologies
With this simple pattern matching, we can model lots of different topologies

* Work Queues (obviously)
* Fanout (broadcast)
* PubSub
* Message Routing
* RPC

--
### Work Queues
Attach multiple consumers to a single queue in order to do work
![Work Queue](./images/work-queue.png)

(You saw this demo already)

--
### Fanout/PubSub
![Fanout](./images/fanout.png)

(they are almost the same thing...)

--
### Message Routing

(insert image here)

--
### Knobs
RabbitMQ has TONS of knobs.

That is where distributor comes in. It is opinionated and sets tons of options for you with a much nicer API than raw node-amqp.

They should be good 80% of the time, but when not, here is a quick walthrough

--
### Fin

One thing that I have started doing when solving a problem is ask myself this question:
> Does this need to be inside a request-response cycle?
If not, perhaps a messaging model with rabbit is the right fit

Go forth, use rabbit.




