# Rails questions answers project

A Question can have one or more answers, and can be private. Every Answer belongs to one question. Each Question has an asker (User), and each Answer has a provider (User).

A Tenant is a consumer of the API you are going to write. A db/seeds.rb file is included to preload the database with test data when you setup the DB.

## Current features:

*   RESTful, read-only API to allow consumers to retrieve Questions with Answers as JSON. The response includes Answers inside their Question as well as include the id and name of the Question and Answer users.
*   Requires every API request to include a valid Tenant API key, and return an HTTP code if the request does not include a valid key.
*   Tracks API request counts per Tenant.
*   HTML dashboard page as the root URL that shows the total number of Users, Questions, and Answers in the system, as well as Tenant API request counts for all Tenants.
* Query parameter to the API request to select only Questions that contain the query term(s)
*   Piece of middleware to throttle API requests on a per-Tenant basis. After the first 100 requests per day, throttle to 1 request per 10 seconds.

## Sample request

`curl --request GET 'http://localhost:3000/api/v1/questions?token=10ded59ed67c46e8a7fba92f4734b79f'`
