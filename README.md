# City Park Liquors Website

Use: Download the repository with git.

Use `docker compose up -d --build` to build a local image and launch the web server. Use [http://localhost:8080](http://localhost:8080/) to view the website locally.

After making any changes simply refresh the page to view the changes in real time. Any saved files will automatically sync with the local docker image.

After verifying all the changes are correct and working, use git to send your changes to the server.
example:

* `git add public/changed_file.html` # Run this for every modified file
* `git commit -m "Fix price list or somesuch"`
* `git push`


You will need to login to the git server with git to push the changes.


## Deployment Details

When you submit your code .github/workflows/oci-image-build.yml is run by the github servers, which will build a new nginx image with your content inside it. It will then update the argocd branch of this project, changing the image tag so the argocd deployment file points to the latest updated file. 

ArgoCD runs inside the kubernetes, and will monitor the argocd branch. Every 3 minutes it will check for changes, if any are found it will apply those changes, causing the website to be automatically updated with the new content in production.

## Connecting to the domain

To connect to the domain [cloudflare-tunnel-ingress-controller](https://github.com/STRRL/cloudflare-tunnel-ingress-controller) will be used inside the kubernetes cluster. It will require 3 pieces of critical information that should be shared over secure channels:

* The domain name
* Your cloudflare accountId 
* A cloudflare API token with specific permissions (see the cloudflare-tunnel-ingress-controller preqrequisites section for details on this token)

Once these three pieces of information are communicated I can go ahead and launch your website to the domain on the ingress detailed on the argocd branch ingress file.

### Critical Point to avoid pain

in the DNS section for the domain there should not be an A or AAAA or CNAME record for the domain. They will be created automatically by the tunnel-ingress-controller. If they already exist the tunnel-ingress-controller will fail until they're erased it seems.

## Testing Forks

### Without docker-compose

The github actions will build an OCI image and store it in ghcr.io. If you fork the project and submit a change an image will be automatically built by the github actions script. For this repository the image can be launched with:
`docker run --name cityparkliquors-dev -d -p 8080:80 ghcr.io/centerionware/cityparkliquors/website:latest` . If you fork to your own repository you can simply switch `centerionware/cityparkliquors` to the name of the fork, eg: `pyrofoxxx/cityparkliquors`

To download the latest image after you've already run the above command in the past you will want to run `docker pull ghcr.io/centerionware/cityparkliquors/website:latest` (again, changing the repository location from `centerionware/cityparkliquors` to the new target). You will need to stop and restart the image if you've previously run the above `docker run` command.

To stop and remove the old running image use: 
`docker stop cityparkliquors-dev && docker rm cityparkliquors-dev` which will stop then remove the container. You can then re-run the above `docker run ...` to re-launch it with the latest version.

These commands will allow you to view a forks changes before approving a pull request by navigating to [http://localhost:8080](http://localhost:8080)

### Docker Compose example

```yml
version: '3'
services:
  nginx-site-1:
    image: ghcr.io/centerionware/cityparkliquors/website:latest
    ports:
      - 8080:80
```

Change the image tag from `centerionware/cityparkliquors` to the forks location (eg: `pyrofoxxx/cityparkliquors`) and save to a file named `compose.yml` anywhere on your disk. Open a terminal and cd to the directory. From the directory containing the `compose.yml` run the following commands (the down will fail if it's not already running, it's safe to ignore the error):

```
docker compose pull
docker compose down
docker compose up -d
```
then navigate to [http://localhost:8080](http://localhost:8080) to view the changes.


### Cleanup

The images will stay on your system even after running `docker compose down` or `docker stop ... && docker rm ...`
to clean them off your system to recover the used disk space run:

`docker image prune -a`
 