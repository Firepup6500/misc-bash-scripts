echo -en "Enter the site name (no trailing slash, but include the leading https:// or http://):\n> "
read sitename
git config --global credential.$sitename.oauthClientId a4792ccc-144e-407e-86c9-5e7d8d9c3269
git config --global credential.$sitename.oauthScopes "read_repository write_repository"
git config --global credential.$sitename.oauthAuthURL /login/oauth/authorize
git config --global credential.$sitename.oauthTokenURL /login/oauth/access_token
git config --global credential.$sitename.oauthDeviceAuthURL /login/oauth/authorize
