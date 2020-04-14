# cron-example

## Requirements

Docker
Docker Compose (optional)

## Usage

With Docker:

```
# Build container image
docker image build -t cron-example .

# Run container
docker container run -d cron-example
```

With Docker Compose:

```
# Build container image
docker-compose build

# Run container
docker-compose up -d
```