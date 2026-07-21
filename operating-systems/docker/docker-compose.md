# Notes
- `docker-compose.yaml` / `compose.yaml` are the default filenames
    - change with `-f <filename>` after EVERY compose command
    - `docker compose -f <filename> logs -f`
    - `docker compose -f <filename> up -d`, etc.


**compose.yaml**
```yaml
services:
  ubuntu:
    image: ubuntu:latest
    command: ["bash", "-c", "echo 'Ubuntu ready' && sleep infinity"]
    stdin_open: true
    tty: true
```

**CLI Commands**
```bash
docker compose logs -f # Follow logs (in a separate terminal probably)
docker compose up -d  # start detached
docker compose exec ubuntu bash  # Open interactive shell
    # yes | unminimize  # (to install a bunch of stuff)
docker compose down  # Stop & remove containers/networks
```
