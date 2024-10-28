# Documentation des Fonctionnalités de Sécurité

## 1. Protection contre les Attaques Web Courantes

### Cross-Site Scripting (XSS)

- Tests de sécurité effectués pour détecter les vulnérabilités XSS.
- Mise en place de protections contre l'injection de scripts malveillants.
- Validation et assainissement des entrées utilisateur.

### Injection SQL et Bruteforce

- Tests de protection contre les injections SQL réalisés avec [SQLMAP](https://github.com/sqlmapproject/sqlmap). Pourquoi [SQLMAP](https://github.com/sqlmapproject/sqlmap) ? [SQLMAP](https://github.com/sqlmapproject/sqlmap) permet de tester automatiquement si les entrées sont vulnérables aux injections SQL. Nous ne sommes donc pas vulnérables.
- Implémentation de mécanismes anti-bruteforce.
- Utilisation de requêtes préparées et d'ORM pour prévenir les injections SQL.

## 2. Gestion des Mots de Passe

### Politique de Sécurité

Exigences minimales pour les mots de passe :

- Longueur minimale de 8 caractères.
- Au moins 1 lettre majuscule et minuscule.
- Au moins 1 chiffre.
- Au moins 1 caractère spécial.

### Stockage Sécurisé

- Hachage systématique des mots de passe avant stockage.
- Utilisation d'algorithmes de hachage sécurisés.

## 3. Sécurité de l'Infrastructure

### Certificats SSL/TLS

- Mise en place du protocole HTTPS.
- Utilisation de Traefik avec Let's Encrypt.
- Renouvellement automatique des certificats SSL.

### Sécurité du Serveur (EC2)

- Déploiement sur une instance EC2 sécurisée.
- Fermeture de tous les ports non essentiels.
- Accès SSH uniquement par clé SSH. Une amélioration possible serait de limiter l'accès au port SSH à certaines IP, mais l'utilisation de GitHub Actions sur des serveurs publics ne permet pas de connaître leurs IP fixes.

## 4. Authentification et Autorisation

### JSON Web Tokens (JWT)

- Implémentation de l'authentification par JWT.
- Gestion sécurisée des sessions utilisateur.
- Validation des tokens côté serveur.
- Aucune information sur l'utilisateur n'est contenue dans le token ; celles-ci ne sont récupérables que grâce au token.

### CORS (Cross-Origin Resource Sharing)

- Configuration stricte des politiques CORS ; seules les URL de développement et de production sont autorisées.

## Bonnes Pratiques Générales

1. Principe du moindre privilège

   - Attribution des droits minimums nécessaires.
   - Séparation des rôles et responsabilités.

2. Mises à jour régulières

   - Maintenance continue des composants de sécurité.
   - Application rapide des correctifs de sécurité.

## Conclusion

Cette architecture de sécurité multiniveau assure une protection robuste de l'application contre les menaces courantes. Les mesures mises en place couvrent aussi bien la sécurité applicative que l'infrastructure, offrant une défense en profondeur conforme aux bonnes pratiques actuelles.
