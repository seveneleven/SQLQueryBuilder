# SQLQueryBuilder

This is a "Framework" to create SQL-Queries by writing (more or less) descriptive code in Delphi. 
It came up when I was playing around with several concepts to improve the readability of source code.

At the moment it provides building very plain INSERT and UPDATE statements. For example:

```delphi
query:= queryBuilder.Update('users').SetValue('age', 20).Where('userID').Equals(15).build();
```

So, there still are some things to improve:
* Implement ALTER and SELECT statements
* Offer more complex WHERE-Clauses
* May change the "Update.SetValue()" to something like "Set('col').To('value')"
* Give some examples


I can imagine to write classes that derive from or use the TSqlQueryBuilder, to not only build statements
but also run them against a database.