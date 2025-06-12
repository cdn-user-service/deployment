# 备份线上包
# zip -r cdn-admin.zip /www/wwwroot/web/admin/*

# 打包本地后端：project/CDN_management/backend，运行`mvn package`
# scp ./target/antsCdn.jar root@154.23.219.18:~/deploy/

# 打包本地前端：project/CDN_management/frontend，运行
# npm i 

# npm run build:cdn_admin
# (cd dist/cdn_admin_v2 && zip -r ../admin.zip ./)  #-r 递归
# scp ./dist/admin.zip root@154.23.219.18:~/deploy/

# npm run build:cdn_users
# (cd dist/cdn_users_v2 && zip -r ../users.zip ./)
# scp ./dist/users.zip root@154.23.219.18:~/deploy/


frontend_path='/www/wwwroot/web'
backend_path='/usr/ants/cdn-api'
deploy_path='/root/deploy'

echo "Please enter the action (1: update or 2: rollback):"
read action

file=""
new_file=""
echo "choose file from 'admin', 'users' and 'java' "
read target
case "$target" in
    "admin")
        file="$frontend_path/admin"
        new_file="$deploy_path/cdn_admin.zip"
        ;;
    "users")
        file="$frontend_path/users"
        new_file="$deploy_path/cdn_users.zip"
        ;;
    "antsCdn")
        file="$backend_path/antsCdn.jar"
        new_file="$deploy_path/antsCdn.jar"
        ;;
    *)
        return 1
        ;;
esac
# backup_file="${file%.*}-old${file##*.}"
backup_file="${file}.old"


update() {
    mv -- "$file" "$backup_file"
    if [ ! -e "$file" ]; then
        echo "bakcup $backup_file successful"
    else
        echo "bakcup $backup_file failed"
    fi
    if [ -e "$new_file" ]; then
        unzip -q $new_file -d $file
        echo "update $file successful"
    else    
        echo "$new_file not update yet"
        return
    fi 
}

rollback() {
    rm -rf $file
    mv -- "$backup_file" "$file"
    if [ ! -e "$backup_file" ]; then
        echo "rollback $backup_file successful"
    else
        echo "rollback $backup_file failed"
    fi
}

if [ "$action" == "1" ] || [ "$action" == "update" ]; then
    update
elif [ "$action" == "2" ] || [ "$action" == "rollback" ]; then
    rollback
fi