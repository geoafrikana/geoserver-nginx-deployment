echo 'reloading nginx'
docker exec nginx_container nginx -s reload
echo 'reloaded nginx'