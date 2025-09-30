# services
Repo for some services in my server

```bash
cp .env.example .env
docker compose up -d nginx
make cert
docker compose up -d --build
```