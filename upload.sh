#!/bin/bash

version=$(curl -s "https://api.github.com/repos/tickstep/aliyunpan/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
file_save_path_file="file_save_path.txt"
data_file="data_file_path.txt"

install_tools_and_login() {
    # 安装工具
    sudo apt install unzip -y
    wget https://github.com/tickstep/aliyunpan/releases/download/$version/aliyunpan-$version-linux-amd64.zip
    unzip aliyunpan-$version-linux-amd64.zip
    rm -r aliyunpan-$version-linux-amd64.zip

    # 登陆
    ./aliyunpan-$version-linux-amd64/aliyunpan login
}

backup_and_upload() {
    # echo "请输入你要压缩文件的绝对路径："
    # read data_file_path
    # echo "$data_file_path" > "$data_file"

    # 压缩数据
    if [ -f "$data_file" ]; then
        data_file_path=$(cat "$data_file")
        tar -czvpf data.tar.gz $data_file_path
    else
        echo "请输入你需要压缩目标文件的绝对路径："
        read data_file_path
        echo "$data_file_path" > "$data_file"
        tar -czvpf data.tar.gz $data_file_path
    fi
    # 备份数据
    ./aliyunpan-$version-linux-amd64/aliyunpan upload data.tar.gz $file_save_path
    # 删除服务器数据备份压缩包
    rm -r data.tar.gz
}

judgment_and_execution() {
    if [ -f "$file_save_path_file" ]; then

        file_save_path=$(cat "$file_save_path_file")
        echo "当前保存路径为：$file_save_path"
        echo "是否重置路径？输入y或n (10s内不输入默认不重置)："
        read -t 10 end_choice

        if [ "$end_choice" == "y" ]; then
            echo "请输入新的保存路径，例：/服务器数据备份/京东云"
            read file_save_path
            echo "$file_save_path" > "file_save_path_file"
        elif [ -z "$end_choice" ]; then
            echo "10秒内未输入，使用现有路径: $file_save_path"
        else
            echo "使用现有路径: $file_save_path"
        fi

    else
        echo "请输入将要保存的文件路径，例：/服务器数据备份/京东云"
        read file_save_path
        echo "$file_save_path" > "$file_save_path_file"
    fi

    # 判断是否存在阿里工具
    if ls -d aliyunpan-*-linux-amd64 1> /dev/null 2>&1; then
        backup_and_upload
    else
        install_tools_and_login
        backup_and_upload
    fi
}

deploy_command() {
    #赋予权限
    chmod +x ./upload.sh
}

main() {
    deploy_command
    judgment_and_execution
}

# 执行
main
