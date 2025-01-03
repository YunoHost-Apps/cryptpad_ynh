We have added a sandbox domain: __SANDBOXDOMAIN__ for you but you still need to configure your DNS and regenerate the Let's Encrypt Certificates for the main domain.
You will need also to restart CryptPad service after this is done.

Then you can please open CryptPad domain: https://__DOMAIN__

Once CryptPad is installed, create an account via the Sign Up button on the home page which will take you to the Register page.
To make this account an instance administrator:

1. Copy the public key found in User Menu (avatar at the top right) > Settings > Account > Public Signing Key
2. Paste this key in `__INSTALL_DIR__/config/config.js` in the following array (uncomment and replace the placeholder):

```
adminKeys: [
        "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
],
```
