## Sandbox domain

The application has created the `__SANDBOXDOMAIN__` domain in the server's NGINX configuration.
It is normal not to see it listed among the domains.
Its certificate management is linked to the main domain `__DOMAIN__`.

1. After installing the application, you need to configure your DNS records so that `__SANDBOXDOMAIN__` points to your server. A CNAME record would be enough, pointing to `__DOMAIN__`.
2. You need to force the regeneration of the certificates for `__DOMAIN__`. This will then be automatically done upon the certificate's end date.

## Administration

Once CryptPad is installed, create an account via the Register button on the home page. To grant this account administration rights:

1. Copy the public key found in User Menu (avatar at the top right) > Settings > Account > Public Signing Key
2. Paste this key in `__INSTALL_DIR__/config/config.js` in the following array (uncomment and replace the placeholder):
```
adminKeys: [
    "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
],
```

3. Restart CryptPad service (In YunoHost webadmin -> Services -> __APP__ -> Restart)
