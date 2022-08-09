# Vertex

A server for storing multi-tenant metrics in [ClickHouse](https://clickhouse.com/).

## Motivation

Unlike StatsD, events are scoped by tenant. That makes it possible to have alerts and reporting on the tenant level.

For example, if you'd like to when accounts haven't logged in over for 2 weeks. The app could publish an event `login.success` and attach their `account_id` as the `tenant`. Then reporting and alerts could be triggered when `login.success` event is missing over a window of 2 weeks.

This approach is also more economical than DataDog or similar logging systems. It doesn't require expensive hosting, and the same infrastructure can support multiple projects for no additional cost.

## Usage

### Sending a single metric

```bash
curl http://localhost:4000/event \
  --header "authorization: Bearer <access-token>" \
  --header "content-type: application/json" \
  --data '{ "tenant": "1234", "event": "order.success", "tags": ["enterprise-plan", "sandbox"] }'
```

### Sending a batch of metrics

```bash
curl http://localhost:4000/events \
  --header "authorization: Bearer <access-token>" \
  --header "content-type: application/json" \
  --data '[{"tenant": "1234", "event": "account.login"}, {"tenant": "1234", "event": "order.success"}]'
```

## Deployment

Create the database using [`setup.sql`](/priv/setup.sql):

```bash
cat priv/setup.sql | clickhouse-client --host <ip> --database=<db-name> --user=default --password=<password>
```

Set up the environment variables:

- `CLICKHOUSE_URL`: URL of the ClickHouse cluster. Including the port (usually `:8123`).
- `CLICKHOUSE_DATABASE`: Name of the ClickHouse database.
- `CLICKHOUSE_USER`: Name of ClickHouse user.
- `CLICKHOUSE_PASSWORD`: Password for ClickHouse user.

For each project that can access the server, create a record in `projects.json`.

```json
{
  "my-project": "my-access-token",
  "my-other-project": "my-other-access-token"
}
```

The key is the name of the project, and the value is the access token.

## Future ideas

- Support triggers: send an email when something happens
- Support expectations: send an email when something doesn't happen

## License

MIT
