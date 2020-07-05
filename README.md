# SFTP Deploy action

> Use this action to deploy your files to server using `SSH Private Key`

> 使用此`action`部署你的项目到服务器上,`仅支持密钥对连接`

> [使用Github Action 部署项目到云服务器](https://zhuanlan.zhihu.com/p/107545396)


## Inputs

### `username`

**Required** sftp username.

### `server`

**Required** sftp server address.

### `port`

sftp srever port , default `22`

### `ssh_private_key`

 **Required** you can copy private_key from your `ssh_private_key.pem file`, keep format, and save at`repo/settings/secrets`


![](./resource/secret.jpg)

### `local_path`

 **Required** `local_path` of you project, if you want put single file:use path like `./myfile`, if you want put directory: use path like `./static/*`, it will put all files under `static` directory. Default to `./*`(will put all files in your repo).

### `remote_path`
 **Required** remote_path

### `args`
args of sftp cmd, E.g.`-o ConnectTimeout=5`


## Action Example	


	on: [push]

	jobs:
	  deploy_job:
	    runs-on: ubuntu-latest
	    name: deploy
	    steps:
	      - name: Checkout
	        uses: actions/checkout@v2
	      - name: deploy file
	        uses: wlixcc/SFTP-Deploy-Action@v1.0
	        with:
	          username: 'root'
	          server: 'your server ip'
	          ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }} 
	          local_path: './static/*'
	          remote_path: '/var/www/app'
	          args: '-o ConnectTimeout=5'

## 1. [Deploy React App Example](https://github.com/wlixcc/React-Deploy)

> If you use nginx, all you need to do is upload the static files to the server after the project is built

	on: [push]
	
	jobs:
	  deploy_job:
	    runs-on: ubuntu-latest
	    name: build&deploy
	    steps:
	      # To use this repository's private action, you must check out the repository
	      - name: Checkout
	        uses: actions/checkout@v2
	
	      - name: Install Dependencies
	        run: yarn
	      - name: Build
	        run: yarn build
	
	      - name: deploy file to server
	        uses: wlixcc/SFTP-Deploy-Action@v1.0
	        with:
	          username: 'root'
	          server: '${{ secrets.SERVER_IP }}'
	          ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
	          local_path: './build/*'
	          remote_path: '/var/www/react-app'
	          args: '-o ConnectTimeout=5'
	          
 ![](./resource/reactExample.jpg)
 
## 2.Deploy Umi App Example (Ant Design Pro)

	name: continuous deployment
	on: [push]
	
	jobs:
	  deploy_job:
	    runs-on: ubuntu-latest
	    name: build&deploy
	    steps:
	      # To use this repository's private action, you must check out the repository
	      - name: Checkout
	        uses: actions/checkout@v2
	     
	      - name: Install umi
	        run: yarn global add umi  
	
	      - name: Install Dependencies
	        run: yarn
	      - name: Build
	        run: yarn build
	
	      - name: deploy file to server
	        uses: wlixcc/SFTP-Deploy-Action@v1.0
	        with:
	          username: 'root'
	          server: '${{ secrets.SERVER_IP }}'
	          ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
	          local_path: './dist/*'
	          remote_path: '/var/www/umiapp'
	          args: '-o ConnectTimeout=5'
 ![](./resource/umiExample.jpg)
	          

 
 
 	          
