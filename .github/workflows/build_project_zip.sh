#!/usr/bin/env bash
set -e

OUT="/tmp/DrEman_Pharmacy_Package"
ZIPOUT="$HOME/DrEman_Pharmacy_Package.zip"

# نظف
rm -rf "$OUT"
mkdir -p "$OUT"

# 1) flutter_skeleton
FS="$OUT/flutter_skeleton"
mkdir -p "$FS/lib/screens"
mkdir -p "$FS/assets"
mkdir -p "$FS/android/app"

# pubspec.yaml
cat > "$FS/pubspec.yaml" <<'YAML'
name: dr_eman_pharmacy
description: Official app for Dr. Eman Gamal Pharmacy
publish_to: "none"
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  url_launcher: ^6.1.7
flutter:
  uses-material-design: true
  assets:
    - assets/p1.jpg
    - assets/p2.jpg
    - assets/p3.jpg
YAML

# lib/main.dart
cat > "$FS/lib/main.dart" <<'DART'
import 'package:flutter/material.dart';
import 'screens/home.dart';
void main() => runApp(const DrEmanApp());
class DrEmanApp extends StatelessWidget {
  const DrEmanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صيدلية دكتورة/ إيمان جمال',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8ED3A1)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
DART

# lib/screens/home.dart
cat > "$FS/lib/screens/home.dart" <<'DART'
import 'package:flutter/material.dart';
import 'offers_page.dart';
import 'products_page.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFE8FDF3), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(width: 140, height: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Center(child: Text('LOGO', style: TextStyle(fontWeight: FontWeight.bold)))),
              const SizedBox(height: 12),
              const Text('صيدلية دكتورة/ إيمان جمال', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Welcome to Dr. Eman Gamal Pharmacy', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              Padding(padding: const EdgeInsets.symmetric(horizontal:24.0), child: Column(children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: const StadiumBorder()),
                  onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductsPage())); },
                  icon: const Icon(Icons.shopping_cart), label: const Text('ابدأ التسوق / Start Shopping')),
                const SizedBox(height:12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: const StadiumBorder()),
                  onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OffersPage())); },
                  icon: const Icon(Icons.local_offer), label: const Text('العروض الأسبوعية / Weekly Offers')),
                const SizedBox(height:12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: const StadiumBorder()),
                  onPressed: () { /* WhatsApp/Call logic placeholder */ },
                  icon: const Icon(Icons.whatsapp), label: const Text('تواصل عبر واتساب / Contact')),
              ])),
              const Spacer(),
              Padding(padding: const EdgeInsets.only(bottom:12.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(onPressed: (){}, icon: const Icon(Icons.facebook)), IconButton(onPressed: (){}, icon: const Icon(Icons.video_library))])),
            ],
          ),
        ),
      ),
    );
  }
}
DART

# offers_page.dart
cat > "$FS/lib/screens/offers_page.dart" <<'DART'
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class OffersPage extends StatelessWidget {
  const OffersPage({super.key});
  final List<Map<String,String>> offers = const [
    {'title':'عرض خاص - فيتامينات','desc':'خصم على الفيتامينات حتى نهاية الأسبوع','image':'assets/p1.jpg','fb':'https://www.facebook.com/share/g/jYZnV9bTc3ZBHFWV/?mibextid=K35XfP'},
    {'title':'عرض بشرة','desc':'خصومات على كريمات العناية','image':'assets/p2.jpg','fb':'https://www.facebook.com/share/8xx3aA1XAv4caUXG/?mibextid=LQQJ4d'},
  ];
  Future<void> _openWhatsApp(String phone, String text) async {
    final uri = Uri.parse("https://api.whatsapp.com/send?phone=$phone&text=${Uri.encodeComponent(text)}");
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العروض الأسبوعية / Weekly Offers')),
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (ctx,i){
          final o = offers[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical:8, horizontal:12),
            child: Column(children:[
              Image.asset(o['image']!, fit: BoxFit.cover, width: double.infinity, height: 160),
              Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
                Text(o['title']!, style: const TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
                const SizedBox(height:6),
                Text(o['desc']!),
                const SizedBox(height:8),
                Row(children:[
                  ElevatedButton.icon(icon: const Icon(Icons.whatsapp), label: const Text('تواصل واتساب'), onPressed: () { _openWhatsApp('201144448487','أريد معرفة سعر العرض ${o['title']}'); }),
                  const SizedBox(width:8),
                  OutlinedButton.icon(icon: const Icon(Icons.share), label: const Text('شارك'), onPressed: () { _openUrl(o['fb']!); }),
                ])
              ]))
            ])
          );
        },
      ),
    );
  }
}
DART

# products_page.dart
cat > "$FS/lib/screens/products_page.dart" <<'DART'
import 'package:flutter/material.dart';
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final products = [
      {'name':'بانادول 500mg','image':'assets/p1.jpg','desc':'مسكن وخافض حرارة'},
      {'name':'كريم مرطب','image':'assets/p2.jpg','desc':'مرطب للبشرة'},
      {'name':'فيتامينات','image':'assets/p3.jpg','desc':'مكملات غذائية'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('المنتجات / Products')),
      body: ListView(padding: const EdgeInsets.all(12), children: products.map((p){
        return Card(child: ListTile(
          leading: Image.asset(p['image']!, width:56,height:56,fit:BoxFit.cover),
          title: Text(p['name']!), subtitle: Text(p['desc']!),
          trailing: ElevatedButton(onPressed: (){}, child: const Text('تواصل لمعرفة السعر'))));
      }).toList()),
    );
  }
}
DART

# assets - add placeholders
echo "Place your product images as p1.jpg p2.jpg p3.jpg in $FS/assets (script leaves placeholder)"

# android key.properties
cat > "$FS/android/key.properties" <<'PROPS'
storePassword=seman2012
keyPassword=seman2012
keyAlias=DrEmanGamalKey
storeFile=app/DrEmanGamalKey.jks
PROPS

# copy example keystore if exists in current dir
if [ -f "./Dr Eman Gamal key89.jks" ]; then
  cp "./Dr Eman Gamal key89.jks" "$FS/android/app/DrEmanGamalKey.jks"
fi

# 2) android-studio-simple (placeholder project)
AS="$OUT/android_studio_simple"
mkdir -p "$AS"
cat > "$AS/README.txt" <<'TXT'
Simple Android Studio placeholder project included. Open with Android Studio and replace package name to com.dr.eman.gamal.pharmacy
TXT

# 3) workflows
mkdir -p "$OUT/.github/workflows"

cat > "$OUT/.github/workflows/build-aab.yml" <<'YAML'
name: Build AAB - Dr Eman Gamal Pharmacy

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup JDK 17
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Setup Gradle
        uses: gradle/gradle-build-action@v3

      - name: Decode Keystore
        run: echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > app/DrEmanGamalKey.jks

      - name: Build AAB
        run: ./gradlew clean bundleRelease

      - name: Sign AAB
        run: |
          jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
            -keystore app/DrEmanGamalKey.jks \
            -storepass ${{ secrets.KEYSTORE_PASSWORD }} \
            -keypass ${{ secrets.KEY_PASSWORD }} \
            app/build/outputs/bundle/release/app-release.aab \
            ${{ secrets.KEY_ALIAS }}

      - name: Verify Signed AAB
        run: jarsigner -verify -verbose -certs app/build/outputs/bundle/release/app-release.aab

      - name: Upload Signed AAB
        uses: actions/upload-artifact@v4
        with:
          name: DrEmanGamalPharmacy-AAB
          path: app/build/outputs/bundle/release/app-release.aab
YAML

cat > "$OUT/.github/workflows/build-apk.yml" <<'YAML'
name: Build APK - Dr Eman Gamal Pharmacy

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up JDK
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Install Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'

      - name: Decode Keystore
        run: echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/DrEmanGamalKey.jks

      - name: Create key.properties
        run: |
          cat > android/key.properties <<EOF
          storePassword=${{ secrets.KEYSTORE_PASSWORD }}
          keyPassword=${{ secrets.KEY_PASSWORD }}
          keyAlias=${{ secrets.KEY_ALIAS }}
          storeFile=app/DrEmanGamalKey.jks
          EOF

      - name: Flutter pub get
        working-directory: ./flutter_skeleton
        run: flutter pub get

      - name: Build APK
        working-directory: ./flutter_skeleton
        run: flutter build apk --release

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: DrEmanGamal-app-release
          path: flutter_skeleton/build/app/outputs/flutter-apk/app-release.apk
YAML

# 4) README
cat > "$OUT/README_FINAL.txt" <<'TXT'
Dr Eman Gamal Pharmacy - Complete Package
-----------------------------------------
Contents:
- flutter_skeleton/    -> Flutter app (lib, pubspec, assets)
- android_studio_simple/ -> Placeholder Android Studio project
- .github/workflows/   -> GitHub Actions to build APK and AAB
- README_FINAL.txt     -> this file

How to use:
1) Replace placeholder images in flutter_skeleton/assets (p1.jpg p2.jpg p3.jpg).
2) If you have a keystore file, place it at flutter_skeleton/android/app/DrEmanGamalKey.jks
   OR add its base64 to GitHub secret ANDROID_KEYSTORE_BASE64.
3) Add secrets in GitHub:
   - ANDROID_KEYSTORE_BASE64
   - KEYSTORE_PASSWORD
   - KEY_ALIAS
   - KEY_PASSWORD
4) Push repo to GitHub (private) and run Actions -> Build AAB or Build APK.
TXT

# zip everything
rm -f "$ZIPOUT"
cd "$OUT/.." && zip -r "$ZIPOUT" "$(basename "$OUT")" >/dev/null

echo "Created ZIP: $ZIPOUT"
echo "Copy the ZIP to your PC and upload to GitHub or unzip and inspect."
