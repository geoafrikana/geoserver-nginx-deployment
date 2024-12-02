echo 'reloading nginx'
docker exec $nginx_name nginx -s reload
echo 'reloaded nginx'