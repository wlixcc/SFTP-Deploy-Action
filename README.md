# SFTP Deploy action

> Use this action to deploy your files to server using `SSH Private Key`

> 使用此`action`部署你的项目到服务器上,`仅支持密钥对连接`


## Inputs

### `username`

> **Required** sftp username.

### `server`

> **Required** sftp server address.

### `port`

> sftp srever port , default `22`.

### `ssh_private_key`

> **Required** you can copy private_key from your `ssh_private_key.pem file`, keep format, and save at`repo/settings/secrets`

### `local_path`

> **Required** `local_path` of you project, if you want put single file:use path like `./myfile`, if you want put directory: use path like `./static/*`, it will put all files under `static` directory. Default to `./*`(will put all files in your repo).

### `remote_path`
> **Required** remote_path

### `args`
> args of sftp cmd, E.g.`-o ConnectTimeout=5`


## Example usage	


	on: [push]

	jobs:
	  deploy_job:
	    runs-on: ubuntu-latest
	    name: deploy
	    steps:
	      - name: Checkout
	        uses: actions/checkout@v2
	      - name: deploy file
	        uses: ./ # Uses an action in the root directory
	        with:
	          username: 'root'
	          server: 'your server ip'
	          private_key: ${{ secrets.SSH_PRIVATE_KEY }} 
	          local_path: './static/*'
	          remote_path: '/var/www/app' #make sure dir exist
	          args: '-o ConnectTimeout=5'
