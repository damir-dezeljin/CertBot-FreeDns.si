# General

This repo contains a Let's Encrypt CertBot hook scripts allowing using `freedns.si` DNS provider.

## Usage Instructions

```bash
certbot certonly                                              \
    --dry-run                                                 \
    --agree-tos                                               \
    --manual-public-ip-logging-ok                             \
    --renew-by-default                                        \
    --manual                                                  \
    --preferred-challenges=dns                                \
    --manual-auth-hook "./certbot-freedns_si.sh --auth"       \
    --manual-cleanup-hook "./certbot-freedns_si.sh --cleanup" \
    -d "dezo.si"                                              \
    -d "*.dezo.si"                                            \
    --server https://acme-v02.api.letsencrypt.org/directory
```

## References

- Anthony Wharton's original integration for `freedns.afraid.org` - [link](https://gist.github.com/AnthonyWharton/a0e8faae7195a5c1dea210466eda1c92).
