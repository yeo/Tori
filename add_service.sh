echo -e "\n\n"
curl -s -X DELETE \
  http://127.0.0.1:8101/apis/axcoto

echo -e "\n\n"
curl -s -X POST \
  -d 'name=axcoto&upstream_url=https://httpbin.org&uris=/bin' \
  http://127.0.0.1:8101/apis

echo -e "\n\n"
curl -s -X PUT \
  -d 'name=tori' \
  -d 'config.provider=google' \
  -d 'config.client_id=1' \
  -d 'config.client_secret=1' \
  -d 'config.token=foo' \
  -d 'config.redirect_uri=127.0.0.1/bin/_oauth' \
  http://127.0.0.1:8101/apis/axcoto/plugins

echo -e "\n\n"
curl -s http://localhost:8101/apis/axcoto/plugins
