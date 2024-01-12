## Configuration

Nous avons ajouté le domaine obligatoire sandbox pour vous mais vous devez encore configurer votre DNS et générer les certificats pour celui-ci.

Une fois CryptPad installé, créez un compte via le bouton S'inscrire sur la page d'accueil. Pour faire de ce compte un administrateur d'instance :

1. Copiez la clé publique trouvée dans le menu utilisateur (avatar en haut à droite) > Paramètres > Compte > Clé de signature publique
2. Collez cette clé dans `__INSTALL_DIR__/config/config.js` dans le tableau suivant (décommentez et remplacez l'espace réservé) :
``` 
adminKeys: [
        "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
],
```

3. Redémarrer le service CryptPad (Dans webadmin YunoHost -> Services -> cryptpad -> Redémarrer)
