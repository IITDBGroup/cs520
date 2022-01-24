# DES (Datalog eduction system)

DES is an open source system for running datalog, relational algebra, and SQL against a database or against a file with datalog rules.

## Installation

You can download the system from this webpage: [http://des.sourceforge.net/html/download.html](http://des.sourceforge.net/html/download.html). For basic usage see below. You can find the full manual here: http://des.sourceforge.net/html/manuals.html

## Basic usage

When running the CLI, you can define Datalog rules and facts using `/assert`, e.g.,

~~~prolog
/assert isbird(penguin).
/assert isbird(sparrow).
/assert isbird(eagle).
/assert canfly(X) :- isbird(X).
~~~

Rules and atoms without `/assert` are treated as queries, to check whether the constant `eagle` is in the `canfly` relation write:

~~~prolog
canfly(eagle).
~~~

Or to check whether both `penguin` and `eagle` are birds:

~~~prolog
bothbirds :- isbird(penguin), isbird(eagle).
~~~

Note that a difference between queries and asserted rules and facts is that asserted rules can be referenced in queries, but rules and predicates defined in queries can be accessed from asserted rules.

## Loading Datalog programs from files

You can load a set of datalog rules from a file using `/consult file.dl`. Note that this deletes all previously loaded rules and facts and all facts and rules defined with `/assert`. If you just want to update your current program then use `/reconsult file.dl` instead.
