#!/bin/bash
# 导出镜像到/var/www/docker-images
# 方便使用 docker load -i /path/to/filename.tar
# 
# 使用：
# ./docker-save.sh node-dev
#

if [ 1 -ne $# ]
then 
    echo 'ERROR: the name of image is empty!'
    echo 'Usage: ./docker-save.sh {docker image name}'
    echo 'Usage: ./docker-save.sh php-fpm'
    exit 1
fi

# 存储目录
save_path=/var/www/docker-images/$1
if [ ! -d $save_path ]
then
    mkdir -p $save_path 
fi

save_file=$save_path/$1-$(date +%Y%m%d%H%M)".tar"
echo $save_file

image_name=$1
[ ! 'busybox' = $image_name ] && image_name="ibbd/$image_name"
sudo docker save -o $save_file $image_name

username=$(whoami)
sudo chown $username:$username $save_file

echo "===>Finish!"

