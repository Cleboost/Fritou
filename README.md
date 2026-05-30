<p align="center">
  <img src="assets/images/logo.png" alt="Fritou Logo" width="120" />
</p>

<h1 align="center">Fritou</h1>

<p align="center">
  <strong>L'assistant de friture intelligent, sécurisé et croustillant.</strong>
</p>

<p align="center">
  Fritou est une application mobile moderne conçue sous Flutter (Material 3 Dark Theme) pour suivre l'usure de l'huile de friture, prévenir la toxicité due à un usage excessif, et guider vos cuissons avec des recettes secrètes croustillantes dotées de minuteurs natifs intégrés.
</p>

---

## ✨ Fonctionnalités Clés

* **Suivi de Friteuse Interactif** : Suivez visuellement l'état de votre bain d'huile (`X / Y` bains effectués). La couleur et l'animation des bulles s'adaptent dynamiquement à l'usure réelle de votre huile.
* **Alerte de Toxicité** : Dès que la limite critique de bains est atteinte, l'application bloque l'ajout de friture et vous propose de vidanger l'huile pour protéger votre santé.
* **Minuteurs Android Natifs Intégrés** : Dans chaque fiche recette (Frites belges, Churros, Beignets, Calamars), lancez des chronomètres directement sur l'application Horloge officielle de votre smartphone Android en un clic.
* **Ajustement selon l'Huile** : Configurez votre type d'huile (Blanc de bœuf traditionnel, Huile d'arachide, Huile de tournesol) dans les paramètres. La limite maximale recommandée de bains s'ajuste automatiquement, tout en restant personnalisable de 2 à 10 bains.

---

## 📲 Guide d'Installation

### 1. Pour les Utilisateurs (Installer sur votre smartphone)
Pour profiter de Fritou immédiatement sur votre appareil Android :
1. Accédez à l'onglet **Releases** à droite de ce dépôt GitHub.
2. Téléchargez le dernier fichier **`app-release.apk`**.
3. Transférez-le sur votre téléphone ou ouvrez-le directement, puis lancez l'installation (pensez à autoriser l'installation d'applications provenant de sources inconnues dans vos paramètres Android si nécessaire).

---

### 2. Pour les Développeurs (Mode Développement)
Si vous souhaitez exécuter ou modifier le code source de l'application :

#### Prérequis
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (version stable)
* [Android Studio / Android SDK](https://developer.android.com/studio)
* Java JDK 17+

#### Étapes de démarrage
1. **Clonez le dépôt** :
   ```bash
   git clone https://github.com/Cleboost/Fritou.git
   cd Fritou
   ```

2. **Installez les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Lancez l'application en mode debug** :
   *(Assurez-vous qu'un émulateur est lancé ou qu'un appareil Android est connecté en débogage USB)*
   ```bash
   flutter run
   ```

4. **Lancer les tests de l'application** :
   ```bash
   flutter test
   ```

---

## 🛠️ Stack Technique

* **Framework** : Flutter (Dart) - Design UI Premium Material 3 Dark
* **Stockage Local** : SharedPreferences (Persistance du compteur, des limites et de l'historique)
* **Intégrations Natives** : Platform Channels (Kotlin/Android Intent Service pour les minuteurs système)
* **CI/CD** : GitHub Actions (Compilation automatique de l'APK Release et création de Releases GitHub à chaque Tag `v*`)
