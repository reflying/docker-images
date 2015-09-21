#!/bin/bash

# 运行容器初始化程序

# 判断run_bashrc.sh文件是否存在
docker_bashrc_file="run-bashrc.sh"
if [ ! -f $docker_bashrc_file ]
then
    echo "ERROR: $docker_bashrc_file is not existed!"
    echo "You can copy $docker_bashrc_file from $docker_bashrc_file"".example"
    exit 1
fi

# 判断run_bashrc.sh的路径是否正确
s="ibbd_docker_run_root="
s_len=${#s}
current_pwd=$(grep -Ei '^\s*'$s ./$docker_bashrc_file)
current_pwd=$(echo $current_pwd|sed 's/^\s*//')
current_pwd=${current_pwd:$s_len}
echo $current_pwd

if [ ! -f $current_pwd"/"$docker_bashrc_file ]
then
    echo "ERROR: $current_pwd is error."
    exit 1
fi

# 判断是否已经加入了~/.bashrc
if 
    grep $current_pwd/$docker_bashrc_file ~/.bashrc > /tmp/null
then
    echo "$current_pwd/$docker_bashrc_file is in .bashrc"
else 
    echo '# ibbd docker command'  >> ~/.bashrc
    echo '. '$current_pwd'/'$docker_bashrc_file >> ~/.bashrc
    echo "$current_pwd/$docker_bashrc_file had added to .bashrc"

    if [ -f ~/.zshrc ]
    then
        # 使用zsh
        echo '# ibbd docker command'  >> ~/.zshrc
        echo '. '$current_pwd'/'$docker_bashrc_file >> ~/.zshrc
        echo "$current_pwd/$docker_bashrc_file had added to .zshrc"
    fi
fi

########################################
### 初始化相关目录 #####################
########################################

[ ! -d /etc/nginx ] && sudo mkdir /etc/nginx
[ ! -d /var/www ] && sudo mkdir /var/www
[ ! -d /data ] && sudo mkdir /data

#user=$(whoami)
#sudo -R $user:$user /var/www

########################################
### 初始化PHP环境的相关配置 ############
########################################

cd ./php-dev/config/
if [ ! -f php-fpm.conf ]
then 
    # 将example文件复制成正式配置文件
    # 如果本地有特殊的配置，可以自己修改
    file_list=$(ls *.example)
    for from_file in $file_list 
    do 
        to_file=${from_file%.*}
        [ ! -f $to_file ] && cp $from_file $to_file
    done
    echo "Finish: copy php-dev config files"
else
    echo "The php-dev config files is existed!"
fi

# 执行成功
echo 'SUCCESS!'
