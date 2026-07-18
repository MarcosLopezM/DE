#import "@preview/typsidian:0.0.3": *
#show: typsidian.with(
  theme: "light",
  title: "Learning SQL",
  author: "Marcos",
)

#make-title()

= Introduction to SQL

#term("Relational databases")[

  A relational database represents a collection of related (two-dimensional) tables.
]

== SELECT queries

To retrieve data from a SQL database, we need to write *SELECT* statements, which are
often referred to as _queries_. A query is just a statement which declares what data we
are looking for, where to find it in the database, and optionally, how to transform it
before it is returned.

Given a table of data, the most basic query we could write would be one that selects for
a couple of columns of the table with all the rows.


```sql
  SELECT column, another_column, ...
  FROM mytable;
```

The result of this query will be a two-dimensional set of rows and columns, but only
with the columns that we requested.

If we want to retrieve absolutely all the columns of ata from a table, we can then use
the asterisk (#c("*")) shorthand in place of listing all the column name individually.

```sql
SELECT *
FROM mytable;
```

== Queries with constraints

In order to filter certain results from being returned, we nee to use a #c("WHERE")
clause in the query. The clause is applied to each row of data by checking specific
column values to determine whether it should be included in the results or not.

```sql
SELECT colum, another_column, ...
FROM mytable
WHERE condition
    AND/OR another_condition
    AND/OR ...;
```

More complex clauses can be constructed by joining numerous #c("AND") or #c("OR")
logical keywords. Below are some useful operator that you can use for numerical data:


#table(
  columns: (auto, auto, auto),
  align: horizon,
  table.header([*Operator*], [*Condtion*], [*SQL Example*]),
  [#c("=, !=, <, <=, >, >=")], [Standard numerical operators], [#c("col_name != 4")],
  [#c("BETWEEN ...") \ #c("AND ...")],
  [Number is within a range of two values
    (inclusive)],
  [#c("col_name BETWEEN 1.5 AND 10.5")],

  [#c("NOT BETWEEN ...") \ #c("... AND ...")],
  [Number is not withing range of two
    values],
  [#c("col_name NOT BETWEEN 1 AND 10")],

  [#c("IN (...)")], [Number exists in a list], [#c("col_name IN (2, 4, 6)")],
  [#c("NOT IN (...)")], [Number does not exist in a list], [#c("col_name NOT IN (1, 3, 5)")],
)

When writing #c("WHERE") clauses with columns containing text data, SQL supports a
number of useful operators to do thing like case-insensitive string comparison and
wildcard pattern matching.


#table(
  columns: (auto, auto, auto),
  align: horizon,
  table.header([*Operator*], [*Condtion*], [*SQL Example*]),
  [#c("=")], [Case sensitive exact string comparison], [#c("col_name = 'abc'")],
  [#c("!= or <>")], [Case sensitive exact string inequality comparison], [#c("col_name != 'abcd'")],

  [#c("LIKE")], [Case insensitive exact string comparison], [#c("col_name LIKE 'ABC'")],
  [#c("NOT LIKE")], [Case insensitive exact string inequality comparison], [#c("col_name
    NOT LIKE 'ABCD'")],
  [#c("%")], [Used anywhere in a string to match a sequence of zero or more characters], [#c("col_name LIKE '%AT%'")],
  [#c("_")], [Used anywhere in a string to match a single character], [#c("col_name LIKE
    'AN_'")],
  [#c("IN (...)")], [String exists in a list], [#c("col_name IN ('A', 'B', 'C')")],
  [#c("NOT IN (...)")], [String does not exist in a list], [#c("col_name NOT IN ('D', 'E', 'F')")],
)

== Filtering and sorting query results

Even though the data in a database may be unique, the results of any particular query
may not be. In such cases, SQL provides a convenient way to discard rows that have a
duplicate column value by using the ``DISTINCT`` keyword.

```sql
SELECT DISTINCT column, another_column, ...
FROM mytable
WHERE condition(s);
```

#box(
  "
  Since the ``DISTINCT`` keyword will blindly remove duplicate rows, we will learn in a
  future lesson how to discard duplicates based on specific columns using grouping and
  the ``GROUP BY`` clause.
  ",
  theme: "info",
)

=== Ordering results

SQL provides a way to sort your results by a given column in ascending or descending
order using the ``ORDER BY`` clause.

```sql
SELECT column, another_column, ...
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC;
```

=== Limiting results to a subset

Another clause which is commonly used with the ``ORDER BY`` clause are the ``LIMIT`` and
``OFFSET`` clauses, which are a useful optimization to indicate to the database the
subset of the results you care about.
The ``LIMIT`` will reduce the number of rows to return, and the optional ``OFFSET`` will
specify where to begin counting the number rows from.

```sql
SELECT column, another_column, ...
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

== Multi-table queries with JOINs

We've been working with a single table, but entity data in the real world is often
broken down into pieces and stored across multiple orthogonal tables using a process
known as _normalization_.

=== Database normalization

Database normalization is useful because it minimizes duplicate data in any single
table, and allows for data in the database to grow independently of each other. As a
trade-off, queries get slightly more complex since they have to be able to find data
from different parts of the database, and performance issues can arise when working with
many large tables.

=== Multi-table queries with JOINs

Tables that share information about a single entity need to have a _primary key_ that
identifies that entity _uniquely_ across the database. One common primary key type is an
auto-incrementing integer, but it can also be a string, hashed value, so long as it is unique.

Using the ``JOIN`` clause in a query, we can combine row data across two separate table
using this unique key. The first of the joins is the *INNER JOIN*:

```sql
SELECT column, another_table_column, ...
FROM mytable
INNER JOIN another_table
  ON mytable.id = another_table.id
WHERE condition(s)
ORDER BY column, ... ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

The *INNER JOIN* is a process that matches rows from the first table and the second
table which have the same key (as defined by the ``ON`` constraint) to create a result
row with the combined columns from both tables. After the tables are joined, the other
clauses we learned previously are then applied.
