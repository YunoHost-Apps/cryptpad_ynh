Nous avons ajouté un domaine sandbox pour vous, mais vous devez encore configurer votre DNS et générer des certificats Let's Encrypt pour celui-ci !!
Si ce n'est pas déjà fait, vous pouvez ouvrir le domaine CryptPad : https://__DOMAIN__

Créez un compte via le bouton S'inscrire sur la page d'accueil. Pour faire de ce compte un administrateur d'instance :
1. Copiez la clé publique trouvée dans le menu utilisateur (avatar en haut à droite) > Paramètres > Compte > Clé de signature publique
2. Collez cette clé dans __INSTALL_DIR__/config/config.js dans le tableau suivant (décommentez et remplacez l'espace réservé) :
adminKeys : [
"[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
],
Si vous rencontrez un problème ou souhaitez améliorer cette application, veuillez ouvrir un nouveau problème dans ce projet : https://github.com/YunoHost-Apps/cryptpad_ynh"