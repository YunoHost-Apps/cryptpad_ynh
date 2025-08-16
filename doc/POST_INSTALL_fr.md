Nous avons ajouté un domaine sandbox : __DOMAIN_SANDBOX__ pour vous, mais vous devez encore configurer votre DNS et régénérer les certificats Let's Encrypt pour le domaine principal.
Vous devrez également redémarrer le service CryptPad une fois cette opération terminée.

Vous pouvez ensuite ouvrir le domaine CryptPad : https://__DOMAIN__

Une fois CryptPad installé, créez un compte via le bouton Inscription sur la page d'accueil qui vous mènera à la page d'inscription.
Pour faire de ce compte un administrateur d'instance :

1. Copiez la clé publique trouvée dans le menu utilisateur (avatar en haut à droite) > Paramètres > Compte > Clé de signature publique
2. Collez cette clé dans `__INSTALL_DIR__/config/config.js` dans le tableau suivant (décommentez et remplacez l'espace réservé) :

```
adminKeys : [
"[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
],
```
