We have added the mandatory sandbox domain for you but you still need to configure your DNS and generate Let's Encrypt Certificates for it!

Once CryptPad is installed, create an account via the Register button on the home page. To make this account an instance administrator:

1. Copy the public key found in User Menu (avatar at the top right) > Settings > Account > Public Signing Key
2. Paste this key in `__INSTALL_DIR__/config/config.js` in the following array (uncomment and replace the placeholder):
``` 
adminKeys: [
        "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
],
```

3. Restart CryptPad service (In YunoHost webadmin -> Services -> cryptpad -> Restart)
