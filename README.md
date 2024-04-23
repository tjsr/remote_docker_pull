# remote_docker_pull
Github action to pull an image on a remote docker host

## Usage

In this example, `DB_IMAGE_NAME` is an alias you want to assign to the image on the target system, for instances when you might want to ensure that a subsequent `docker pull` of the repository image name doesn't overwrite the current version of that image. `DEPLOYMENT_HOST` is an accessable hostname or IP, `DEPLOYMENT_SSH_KEY` is an SSH private key PEM, and `DEPLOYMENT_USER` is the remote host ssh user to log in as.

```yaml
    env:
      IMAGE_NAME: imagename:${{ github.sha }}
    steps:
    - name: Pull DB migration deploy image on remote.
      uses: tjsr/remote_docker_pull@main
      with:
        remote_docker_host: ${{ secrets.DEPLOYMENT_HOST }}
        ssh_private_key: ${{ secrets.DEPLOYMENT_SSH_KEY }}
        remote_docker_user: ${{ secrets.DEPLOYMENT_USER }}
        docker_image: public.ecr.aws/myregistry/${{ env.IMAGE_NAME }}
        ssh_port: 22
        local_tag: ${{ env.IMAGE_NAME }}
```