# SFTP Deploy action

> Use this action to deploy your files to server using `SSH Private Key`

> 使用此`action`部署你的项目到服务器上，中文介绍链接：[使用Github Action 部署项目到云服务器](https://zhuanlan.zhihu.com/p/107545396)

## 1. Inputs 

| Name                   | Required             | Default | Description                                   |
|------------------------|----------------------|---------|-----------------------------------------------|
`username` | yes| | SSH username
`server` | yes| | Remote host
`port`| yes | 22 | Remote host port
`ssh_private_key`| no| | You can copy private key from your `ssh_private_key` file, and save to`repo/settings/secrets`![](./resource/secret.jpg)
`local_path`| yes| ./* | `local_path` of you project, if you want put single file:use path like `./myfile`, if you want put directory: use path like `./static/*`, it will put all files under `static` directory. Default to `./*`(will put all files in your repo).
`remote_path`|yes|| Remote path
`sftp_only`| no| | If your port only accepts the sftp protocol, set this option to `true`. However, please note that when this option is set to `true`, the remote folder will not be created automatically.
<strike>args</strike> `sftpArgs` | no| | other args yor want to use of sftp, E.g.`-o ConnectTimeout=5`
`delete_remote_files` | no | false | Set to `true` will delete remote path  folder and all files in it. 
`password`| no| | SSH passsword，If a password is set, `ssh_private_key` is ignored. `for @v1.2.4 and greater`

> **Warning**

> Be careful when use `delete_remote_files`, This will delete remote path  folder and all files in it

-----

## 2.Action Examples

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

## 3. [Deploy React App Example](https://github.com/wlixcc/React-Deploy)


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
 
 --------

## 4.Invalid format? You need keep format

If you use the Ed25519 algorithm to generate an SSH key pair `ssh-keygen -t ed25519 -C "your_email@example.com"`,
you need to note that the last line of the private key is a blank line. You need to keep this line when adding Repository secrets, otherwise it may lead to an `invalid format` error.
 ![](./resource/keepformat.jpg)

 