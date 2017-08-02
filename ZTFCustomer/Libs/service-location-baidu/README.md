##service-location-baidu

App启动时 需指定 AppKey 和 locationMode
AppDelegate:
[[BaiduLocation sharedLocation] setupWithKey:@"TvzWKDkkX5GhxpMsbMYxZw5V"];
[BaiduLocation sharedLocation].locationMode = ServiceLocationSystemModeBD09LL;
