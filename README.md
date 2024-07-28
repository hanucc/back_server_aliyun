# back_server_aliyun
备份服务器数据到阿里云盘

## 基本介绍
新手写的脚本，bug有点多

下载好脚本文件，最好单独放到一个空文件下，在此目录下运行：

`bash upload.sh`

之后会提示输入存放的阿里云盘路径，以及备份文件的绝对路径


在第一次成功运行后，后面在运行会自动保存在上次存放的路径

接下来再设置一个定时任务，比如，每周一凌晨三点运行脚本备份一次

`crontab -e`

将任务放进去

`0 3 * * 1 /root/sh/backsh/upload.sh`

之后就不用麻烦地再手动去备份了，也不怕那天忘了机器过期没存数据

# 引用
主要用了这个项目[tickstep/aliyunpan](https://github.com/tickstep/aliyunpan)，可以去看看官方项目
