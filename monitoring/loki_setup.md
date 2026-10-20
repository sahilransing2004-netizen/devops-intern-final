# Loki Setup Notes

> Fill in every section below with what you actually did and saw.

## 1. How I started the stack
```bash
cd monitoring
docker compose up -d
docker compose ps
```
Output: _paste here_

Grafana: http://localhost:3000 (Loki datasource is provisioned from `grafana-datasource.yaml`).

## 2. Label set applied (promtail-config.yaml)
| Label | Source | Purpose |
|---|---|---|
| `job` | static `nginx-app` | groups all app logs |
| `container` | Docker container name | identifies the container |
| `nomad_alloc_id` | parsed from Nomad container name | links logs to a Nomad allocation |
| `service` | static `nginx-app` | matches Consul service name |
| `status`, `method` | parsed from the access log line | quick filtering |

## 3. Generating traffic
```bash
curl localhost:<port>/            # 200
curl localhost:<port>/nothere     # 404
```

## 4. LogQL queries and results
```logql
{job="nginx-app"}
{job="nginx-app", status="404"}
{job="nginx-app"} != " 200 "
sum by (status) (count_over_time({job="nginx-app"}[5m]))
```
Results / screenshot: ![Grafana Explore](../docs/screenshots/grafana-explore.png)

## 5. Problems hit and how I fixed them
1. _problem -> cause -> fix_
2. _problem -> cause -> fix_
