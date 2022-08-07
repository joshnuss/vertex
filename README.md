# Analytics

A small server for storing multi-tenant metrics in [ClickHouse](https://clickhouse.com/).

## Motivation

Unlike StatsD, events are scoped by tenant. That makes it possible to have alerts and reporting based on tenants.

For example, I'd like to know if an account hasn't logged in over the past 2 weeks. The SaaS app would publish an event `login.success` and attach the `account_id`. Then automation could be built around that event being missing.

It is also more economical than DataDog or similar metric logging systems. It can run on inexpensive hosting while supporting many projects for no additional cost.

## Usage

To send a metric over HTTP:

```bash
curl http://localhost:4000/event \
  --header "authorization: Bearer <access-token>" \
  --header "content-type: application/json" \
  --data '{ "project": "dashboard", "account_id": "1234", "event": "order.success", "tags": ["enterprise-plan", "sandbox"] }'
```

## Deployment

Set environement vars:

- `CLICKHOUSE_DATABASE`: Name of the ClickHouse database.
- `CLICKHOUSE_URL`: URL of the ClickHouse cluster. Including the port (usually `:8123`).
- `CLICKHOUSE_USER`: Name of ClickHouse user.
- `CLICKHOUSE_PASSWORD`: Password for ClickHouse user.
- `ANALYTICS_ACCESS_TOKEN`: Secret access token that will be verified on each request.

## Future ideas

- Support batch inserting metrics
- Support multiple access keys (one per-project)
- Support triggers: send an email when something happens
- Support expectations: send an email when something doesn't happen

## License

MIT
