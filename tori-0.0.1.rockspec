package = "Tori"
version = "0.0.1"
source = {
   url = "https://github.com/yeo/tori"
}
description = {
   summary = "Simple Clone of Bitly Oauth2 proxy",
   detailed = [[
	 Similar to bitly oauth2 proxy but for kong
   ]],
   homepage = "http://yeo.space",
   license = "MIT/X11" -- or whatever you like
}
dependencies = {
   "lua >= 5.1, < 5.4"
   -- If you depend on other rocks, add them here
}
build = {
   -- We'll start here.
}
