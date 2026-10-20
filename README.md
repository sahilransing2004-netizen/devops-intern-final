# DevOps Intern Final Assessment

[![CI](https://github.com/sahilransing2004-netizen/devops-intern-final/actions/workflows/ci.yml/badge.svg)](https://github.com/sahilransing2004-netizen/devops-intern-final/actions/workflows/ci.yml)

**Name:** Sahil Ransing  
**Submission date:** 2026-10-20  
**Assigned by:** Friendy

## Architecture

```
 Developer ──push/PR──▶ GitHub ──▶ GitHub Actions CI ──▶ GHCR (ghcr.io)
                                   lint → build → test → publish      │
                                                                      ▼
                          Loki ◀── Promtail ◀── container logs ◀── Nomad (+Consul)
                            │                                    pulls image by SHA tag
                            ▼
                         Grafana (LogQL)
```

## Prerequisites (pinned versions)
| Tool | Version |
|---|---|
| Docker | 27.x |
| Nomad | 1.8.x |
| Consul | 1.19.x |
| ShellCheck | 0.10.0 |
| curl, git | any recent |

> Update this table with the versions you actually ran (`docker --version`, `nomad version`, ...).

## Quick Start
```bash
git clone https://github.com/sahilransing2004-netizen/devops-intern-final.git && cd devops-intern-final
docker build --build-arg BUILD_SHA=$(git rev-parse --short HEAD) -t nginx-app:local app/
docker run -d --name app -p 8080:8080 nginx-app:local
./scripts/healthcheck.sh http://localhost:8080/healthz
consul agent -dev &                      # terminal 2
nomad agent -dev &                       # terminal 3
nomad job run -var="image_tag=<sha>" -var="image_repo=ghcr.io/<user>/devops-intern-final" nomad/nginx-app.nomad.hcl
cd monitoring && docker compose up -d    # then open http://localhost:3000
```

## Task 1 - Source Control
Branch `feature/pipeline` merged via PR #1, tagged `v1.0.0`.
- PR link: _add_
- `git log --oneline` output: _paste_

## Task 2 - Linux Scripting
```bash
./scripts/sysinfo.sh
./scripts/healthcheck.sh http://localhost:8080/healthz; echo "exit=$?"
```
Output: _paste_

## Task 3 - Containerisation
```bash
docker build --build-arg BUILD_SHA=$(git rev-parse --short HEAD) -t nginx-app:local app/
docker run -d --name app -p 8080:8080 nginx-app:local
docker images nginx-app
curl -i localhost:8080/
curl -i localhost:8080/healthz
```
Image size: _paste (must be < 60 MB)_  
Output: _paste_

## Task 4 - Continuous Integration
Jobs: `lint` → `build` → `test` → `publish` (publish only on push to `main`).  
Image: `ghcr.io/<user>/devops-intern-final:<sha>` and `:latest`.  
Screenshot: `![CI green](docs/screenshots/ci-green.png)`

## Task 5 - Nomad Orchestration
Resources: 100 MHz CPU / 64 MB memory (no deviation, or justify here).
```bash
nomad job validate nomad/nginx-app.nomad.hcl
nomad job plan -var="image_tag=<sha>" nomad/nginx-app.nomad.hcl
nomad job run  -var="image_tag=<sha>" nomad/nginx-app.nomad.hcl
nomad job status nginx-app
```
Output: _paste_

## Task 6 - Log Aggregation (Loki)
See [monitoring/loki_setup.md](monitoring/loki_setup.md).  
Screenshot: `![Grafana Explore](docs/screenshots/grafana-explore.png)`

## Troubleshooting
_Document at least 3 failures you actually hit (symptom → cause → fix)._
1. 
2. 
3. 

## Known Limitations
_Be honest. Examples: Nomad/Consul run in dev mode, Grafana has anonymous admin access, no TLS, single instance, logs retained 7 days, image tag passed manually._
