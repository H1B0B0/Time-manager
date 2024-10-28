# Documentation des Fonctionnalités de Sécurité

## 1. Protection contre les Attaques Web Courantes

### Cross-Site Scripting (XSS)

- Tests de sécurité effectués pour détecter les vulnérabilités XSS
- Mise en place de protections contre l'injection de scripts malveillants
- Validation et assainissement des entrées utilisateur

### Injection SQL et Bruteforce

- Tests de protection contre les injections SQL réalisés
- Implémentation de mécanismes anti-bruteforce
- Utilisation de requêtes préparées et d'ORM pour prévenir les injections SQL

## 2. Gestion des Mots de Passe

### Politique de Sécurité

Exigences minimales pour les mots de passe :

- Longueur minimale de 8 caractères
- Au moins 1 lettre
- Au moins 1 chiffre
- Au moins 1 caractère spécial

### Stockage Sécurisé

- Hachage systématique des mots de passe avant stockage
- Utilisation d'algorithmes de hachage sécurisés

## 3. Sécurité de l'Infrastructure

### Certificats SSL/TLS

- Mise en place du protocole HTTPS
- Utilisation de Traefik avec Let's Encrypt
- Renouvellement automatique des certificats SSL

### Sécurité du Serveur (EC2)

- Déploiement sur une instance EC2 sécurisée
- Fermeture de tous les ports non essentiels
- Accès SSH uniquement par clé (suppression de l'authentification par mot de passe)

## 4. Authentification et Autorisation

### JSON Web Tokens (JWT)

- Implémentation de l'authentification par JWT
- Gestion sécurisée des sessions utilisateur
- Validation des tokens côté serveur

### CORS (Cross-Origin Resource Sharing)

- Configuration stricte des politiques CORS
- Restriction des domaines autorisés à accéder aux ressources
- Protection contre les requêtes cross-origin non autorisées

## 5. Protection contre les Attaques par Déni de Service

### Rate Limiting

- Implémentation d'un système de "clock tin"
- Protection contre le spam des boutons et actions
- Limitation du nombre de requêtes par utilisateur

## Bonnes Pratiques Générales

1. Principe du moindre privilège

   - Attribution des droits minimums nécessaires
   - Séparation des rôles et responsabilités

2. Logging et Monitoring

   - Journalisation des événements de sécurité
   - Surveillance des tentatives d'accès suspectes

3. Mises à jour régulières
   - Maintenance continue des composants de sécurité
   - Application rapide des correctifs de sécurité

## Conclusion

Cette architecture de sécurité multiniveau assure une protection robuste de l'application contre les menaces courantes. Les mesures mises en place couvrent aussi bien la sécurité applicative que l'infrastructure, offrant une défense en profondeur conforme aux bonnes pratiques actuelles.
