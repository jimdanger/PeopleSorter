
There's an API that returns a list of people with the following schema:

{ "id": UUID, "name": STRING, "state": STRING, age: INT(9..103) }

Every request will return a header of X-Total-Count: total_num_records in the response

to paginate: use ?_page=xx&_limit=xx. For example: http://52.14.36.184/people?_page=1&_limit=1000 will return the first 1000 records.

If these options are omitted, the entire list of people is returned.

Write a client that fetches all the records and does the following:

- Count the number of records where the age is not between 18 and 65 (inclusive).
- Count the number of records by state in bucketed age groups of 18-25, 26-41, and 41-65.
- Provide a function that takes in a state and an age and returns all matching records.

Example (in python):

import requests

URL = 'http://52.14.36.184/people'

print(requests.get("http://52.14.36.184/people?_page=1&_limit=3&age=22").json())






