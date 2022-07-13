# SFTP Deploy action

> Use this action to deploy your files to server using `SSH Private Key`

> 使用此`action`部署你的项目到服务器上,`仅支持密钥对连接`
中文介绍链接：[使用Github Action 部署项目到云服务器](https://zhuanlan.zhihu.com/p/107545396)

## 1. Inputs 

| Name                   | Required             | Default | Description                                   |
|------------------------|----------------------|---------|-----------------------------------------------|
`username` | yes| | SSH username
`server` | yes| | Remote host
`port`| yes | 22 | Remote host port
`ssh_private_key`| yes| | You can copy private key from your `ssh_private_key.pem` file, and save to`repo/settings/secrets`![](./resource/secret.jpg)
`local_path`| yes| ./* | `local_path` of you project, if you want put single file:use path like `./myfile`, if you want put directory: use path like `./static/*`, it will put all files under `static` directory. Default to `./*`(will put all files in your repo).
`remote_path`|yes|| Remote path
`sftp_only`| no| | If your port only accepts the sftp protocol, set this option to `true`. However, please note that when this option is set to `true`, the remote folder will not be created automatically.
<strike>args</strike> `sftpArgs` | no| | other args yor want to use of sftp, E.g.`-o ConnectTimeout=5`
`delete_remote_files` | no | false | Set `true` will delete all files in the remote path before upload. 
`password`| no| | SSH passsword，If a password is set, `ssh_private_key` is ignored `on @v1.2.4`

> **Warning**

> Be careful when use `delete_remote_files`, This will remove all files in your remote path before uploading

## Action Example

```yaml
on: [push]

jobs:
	deploy_job:
	runs-on: ubuntu-latest
	name: deploy
	steps:
		- name: Checkout
		uses: actions/checkout@v2
		- name: deploy file
		uses: wlixcc/SFTP-Deploy-Action@v1.2.4
		with:
			username: 'root'
			server: 'your server ip'
			ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }} 
			local_path: './static/*'
			remote_path: '/var/www/app'
			sftpArgs: '-o ConnectTimeout=5'
```

```yaml
on: [push]

jobs:
	deploy_job:
	runs-on: ubuntu-latest
	name: deploy
	steps:
		- name: Checkout
		uses: actions/checkout@v2
      	- name: Deploy file
        uses: wlixcc/SFTP-Deploy-Action@v1.2.4
        with:
          username: ${{ secrets.FTP_USERNAME }}
          server: ${{ secrets.FTP_SERVER }}
          port: ${{ secrets.FTP_PORT }}
          local_path: './static/*'
          remote_path: '/var/www/app'
          sftp_only: true
          password: ${{ secrets.FTP_PASSWORD }}
```

## 1. [Deploy React App Example](https://github.com/wlixcc/React-Deploy)

> If you use nginx, all you need to do is upload the static files to the server after the project is built

```yaml
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
		uses: wlixcc/SFTP-Deploy-Action@v1.2.4
		with:
			username: 'root'
			server: '${{ secrets.SERVER_IP }}'
			ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
			local_path: './build/*'
			remote_path: '/var/www/react-app'
			sftpArgs: '-o ConnectTimeout=5'
```

 ![](./resource/reactExample.jpg)
 
## 2.Deploy Umi App Example (Ant Design Pro)

```yaml
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
		uses: wlixcc/SFTP-Deploy-Action@v1.2.4
		with:
			username: 'root'
			server: '${{ secrets.SERVER_IP }}'
			ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
			local_path: './dist/*'
			remote_path: '/var/www/umiapp'
			sftpArgs: '-o ConnectTimeout=5'
```
 ![](./resource/umiExample.jpg)
	          

 
 
 	          
