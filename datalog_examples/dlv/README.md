# DLV

This is a short tutorial for DLV. Additional information can be found in the user manual: [http://www.dlvsystem.com/html/DLV_User_Manual.html](http://www.dlvsystem.com/html/DLV_User_Manual.html)

## Usage

You provide both the data and the datalog rules in a `.dlv` file. Per default `dlv` will output all derived facts. For instance, use the `train.dlv`  from this folder. This file contains train connection data and a query `twohop` that returns train connections with one intermediate stop. 

~~~shell
$dlv train.dlv 
DLV [build BEN/Dec 17 2012   gcc 4.2.1 (Apple Inc. build 5666) (dot 3)]

{train(chicago,schaumburg), train(chicago,indianapolis), train(schaumburg,ohare), train(indianapolis,buffalo), twohop(chicago,ohare), twohop(chicago,buffalo),
...
~~~

If you only want to see the content of one predicate (e.g., the `twohop` query result), then you can use dlv's `-filter=X` option to achieve this:

~~~shell
$dlv -filter=twohop train.dlv 
DLV [build BEN/Dec 17 2012   gcc 4.2.1 (Apple Inc. build 5666) (dot 3)]

{twohop(chicago,ohare), twohop(chicago,buffalo)}
~~~

That is in this example database there are two connections with one intermediate stop.


## Specifying Facts (Data) 

Like in logic programming languages, data is specified as atoms. For example, to specify that the relation `train` contains a tuple `(chicago,buffalo)` you would write:

~~~prolog
train(chicago,buffalo).
~~~

Note that in dlv identifiers starting with a lowercase character are constants while identifiers starting with an uppercase character are variables. For example, in the query shown below `X` is constant while `chicago` is a variable. That is, this query returns the destinations of train connections that start in Chicago.

~~~prolog
Q(X) :- train(chicago, X).
~~~

## Queries

Queries are written as Datalog rules. DLV supports negation and recursion. For instance, consider the rules for `connected` from the `train.dlv` file:

~~~prolog
connected(X,Y) :- connected(X,Z), train(Z,Y).
connected(X,Y) :- connected(Y,X).
connected(X,Y) :- train(X,Y).
~~~

Evaluating this query we get all cities that are directly or indirectly connected to each other via train connections. 

~~~shell
dlv -filter=connected train.dlv 
DLV [build BEN/Dec 17 2012   gcc 4.2.1 (Apple Inc. build 5666) (dot 3)]

{connected(chicago,schaumburg), connected(chicago,ohare), connected(chicago,indianapolis), connected(chicago,buffalo), connected(schaumburg,chicago), connected(schaumburg,schaumburg), connected(schaumburg,ohare), connected(schaumburg,indianapolis), connected(schaumburg,buffalo), connected(ohare,chicago), connected(ohare,schaumburg), connected(ohare,ohare), connected(ohare,indianapolis), connected(ohare,buffalo), connected(indianapolis,chicago), connected(indianapolis,schaumburg), connected(indianapolis,ohare), connected(indianapolis,indianapolis), connected(indianapolis,buffalo), connected(buffalo,chicago), connected(buffalo,schaumburg), connected(buffalo,ohare), connected(buffalo,indianapolis), connected(buffalo,buffalo)}
~~~

As an example for negation consider this query which returns cities with no outgoing train connections.

~~~prolog
city(X) :- train(X,Y).
city(Y) :- train(X,Y).
outbound(X) :- train(X,Y).
noOutbound(X) :- city(X), not outbound(X).
~~~

This query returns:

~~~shell
$dlv -filter=noOutbound train.dlv 
DLV [build BEN/Dec 17 2012   gcc 4.2.1 (Apple Inc. build 5666) (dot 3)]

{noOutbound(ohare), noOutbound(buffalo)}
~~~
