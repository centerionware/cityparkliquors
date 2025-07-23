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

When you submit your code .github/workflows/docker-image-build.yml is run by the github servers, which will build a new nginx image with your content inside it. It will then update the argocd branch of this project, changing the image tag so the argocd deployment file points to the latest updated file. 

ArgoCD runs inside the kubernetes, and will monitor the argocd branch. Every 3 minutes it will check for changes, if any are found it will apply those changes, causing the website to be automatically updated with the new content in production.

## Connecting to the domain

To connect to the domain [cloudflare-tunnel-ingress-controller](https://github.com/STRRL/cloudflare-tunnel-ingress-controller) will be used inside the kubernetes cluster. It will require 3 pieces of critical information that should be shared over secure channels:

* The domain name
* Your cloudflare accountId 
* A cloudflare API token with specific permissions (see the cloudflare-tunnel-ingress-controller preqrequisites section for details on this token)

Once these three pieces of information are communicated I can go ahead and launch your website to the domain on the ingress detailed on the argocd branch ingress file.

### Critical Point to avoid pain

in the DNS section for the domain there should not be an A or AAAA or CNAME record for the domain. They will be created automatically by the tunnel-ingress-controller. If they already exist the tunnel-ingress-controller will fail until they're erased it seems.
