# Tori
Identity Proxy for Kong

Google has a cool thing call Google Identity Aware proxy which many use to put private service behind a proxy instead of a VPN. Bitly has a similar thing call Oauth Proxy.

However, when using Kong, all service now run behind same load balancer, if we add proxy they will be applied for all of service. This is a plugin so we can enable this proxy per service.

