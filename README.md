Getting started
===============
Setup Rclone run `docker exec -ti <DOCKER_CONTAINER> bash -c rclone_setup`

Setup Plexdrive run `docker exec -ti <DOCKER_CONTAINER> bash -c plexdrive_setup`

## Commands
Upload run `docker exec <DOCKER_CONTAINER> bash -c cloudupload`

Remove local files run `docker exec <DOCKER_CONTAINER> bash -c rmlocal`

Umount local files run `docker exec <DOCKER_CONTAINER> bash -c umount`

Mount local files run `docker exec <DOCKER_CONTAINER> bash -c mount`

## Cron jobs
Setup cron jobs to upload and remove locales:
 - `@daily docker exec <DOCKER_CONTAINER> bash -c cloudupload`
 - `@weekly docker exec <DOCKER_CONTAINER> bash -c rmlocal`


# Build your own
## Build
`docker build -t cloud-media-scripts .`

## Test run
`docker run --name cloud-media-scripts -d cloud-media-scripts`