# Vertex

A server for storing multi-tenant metrics in [ClickHouse](https://clickhouse.com/).

## Motivation

Unlike StatsD, events are scoped by tenant. That makes it possible to have alerts and reporting based on tenants.

For example, I'd like to know if an account hasn't logged in over the past 2 weeks. The SaaS app would publish an event `login.success` and attach the `account_id`. Then automation could be built around that event being missing.

It is also more economical than DataDog or similar metric logging systems. It can run on inexpensive hosting while supporting many projects for no additional cost.

## Usage

### Send a single metric

```bash
curl http://localhost:4000/event \
  --header "authorization: Bearer <access-token>" \
  --header "content-type: application/json" \
  --data '{ "account_id": "1234", "event": "order.success", "tags": ["enterprise-plan", "sandbox"] }'
```

## Send a batch of metrics

```bash
curl http://localhost:4000/events \
  --header "authorization: Bearer <access-token>" \
  --header "content-type: application/json" \
  --data '[{"account_id": "1234", "event": "account.login"}, {"account_id": "1234", "event": "order.success"}]'
```

## Deployment

Set environement vars:

- `CLICKHOUSE_DATABASE`: Name of the ClickHouse database.
- `CLICKHOUSE_URL`: URL of the ClickHouse cluster. Including the port (usually `:8123`).
- `CLICKHOUSE_USER`: Name of ClickHouse user.
- `CLICKHOUSE_PASSWORD`: Password for ClickHouse user.

Create a list of project names and access keys in `projects.json`:

```json
{
  "my-project": "my-access-token",
  "my-other-project": "my-other-access-token"
}
```

## Future ideas

- Support triggers: send an email when something happens
- Support expectations: send an email when something doesn't happen

## License

MIT
