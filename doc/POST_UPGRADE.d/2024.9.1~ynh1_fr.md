## Domaine "bac à sable"

L'application a créé le domaine `__SANDBOXDOMAIN__` dans la configuration NGINX du serveur.
Il est normal de ne pas le voir dans la liste des domaines.
La gestion des certificats de ce domaine est adossée au domaine principal `__DOMAIN__`.

1. Après l'installation de l'application, vous devez configurer vos enregistrements DNS pour que `__SANDBOXDOMAIN__` pointe vers votre serveur. Un enregistrement CNAME pointant vers `__DOMAIN__` suffirait.
2. Vous devez forcer la regénération des certificats pour `__DOMAIN__`. Cela sera ensuite fait automatiquement à échéance des certificats.

## Administration

Une fois CryptPad installé, créez un compte via le bouton S'inscrire sur la page d'accueil. Pour donner à ce compte les droits d'administration :

1. Copiez la clé publique trouvée dans le menu utilisateur (avatar en haut à droite) > Paramètres > Compte > Clé de signature publique
2. Collez cette clé dans `__INSTALL_DIR__/config/config.js` dans le tableau suivant (décommentez et remplacez l'espace réservé) :
```
adminKeys: [
    "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
],
```

3. Redémarrer le service CryptPad (Dans la webadmin de YunoHost -> Services -> __APP__ -> Redémarrer)
