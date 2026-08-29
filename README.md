# Wasserschaden-App – GitHub Pages + Supabase

Diese Version ist für zwei oder mehr Handys vorbereitet. Schäden, Fotos und Arbeitszeiten werden gemeinsam in Supabase gespeichert. Die App läuft als statische Webseite auf GitHub Pages und kann auf dem iPhone zum Home-Bildschirm hinzugefügt werden.

## 1. Supabase-Projekt erstellen

1. In Supabase ein neues Projekt erstellen.
2. Im **SQL Editor** die Datei `supabase_setup.sql` vollständig ausführen.
3. Unter **Authentication > Users** zwei Benutzer anlegen: einen für dich und einen für deine Frau. Am einfachsten verwendet ihr je eine eigene E-Mail-Adresse und ein Passwort.
4. In den Projekteinstellungen die **Project URL** und den öffentlichen **Publishable Key / anon key** kopieren.

Wichtig: Niemals den `service_role` Key in `config.js` eintragen. Der gehört nicht in eine öffentliche Webseite.

## 2. config.js ausfüllen

`config.js` öffnen und diese zwei Werte ersetzen:

```js
window.WS_CONFIG = {
  supabaseUrl: "https://DEIN-PROJEKT.supabase.co",
  supabaseAnonKey: "DEIN_PUBLIC_KEY",
  storageBucket: "damage-photos"
};
```

## 3. GitHub Repository erstellen

1. Auf GitHub ein neues Repository erstellen, z. B. `wasserschaden`.
2. Den **gesamten Inhalt dieses Ordners** ins Repository hochladen. `index.html` muss direkt im Hauptverzeichnis liegen.
3. Repository **Settings > Pages** öffnen.
4. Unter **Build and deployment** `Deploy from a branch` wählen.
5. Branch `main`, Ordner `/ (root)` wählen und speichern.
6. GitHub zeigt danach die Pages-Adresse an, z. B. `https://deinname.github.io/wasserschaden/`.

## 4. Auf beiden Handys verwenden

1. Dieselbe GitHub-Pages-Adresse öffnen.
2. Mit dem jeweiligen Supabase-Benutzer anmelden.
3. Unter **Mehr > Konto / Name** den Namen dieses Geräts eintragen.
4. Auf dem iPhone in Safari: **Teilen > Zum Home-Bildschirm**.

Danach können beide Geräte gleichzeitig Schäden und Arbeitszeiten erfassen. Änderungen werden über Supabase Realtime synchronisiert.

## Was wo gespeichert wird

- Schäden: Tabelle `ws_damages`
- Arbeitszeiten: Tabelle `ws_work`
- Fotos: privater Storage-Bucket `damage-photos`
- Login: Supabase Authentication
- Geräte-Name: nur lokal im Browser des jeweiligen Handys

## Export

In der App unter **Mehr**:

- `PDF / Drucken`: Browser-Druckansicht, auf dem iPhone kann daraus ein PDF erstellt werden.
- `CSV / Excel`: Tabellenexport.
- `Sicherung`: JSON-Sicherung der Datensätze. Die Fotodateien selbst bleiben im Supabase Storage.

## Sicherheit

Die SQL-Datei aktiviert Row Level Security (RLS). Nur angemeldete Supabase-Benutzer können Tabellen und Fotos lesen oder verändern. Diese App hat absichtlich keine öffentliche Registrierung. Lege die benötigten Benutzer direkt in Supabase an.

## Dateien

- `index.html` – komplette App
- `config.js` – Supabase-Verbindung
- `supabase_setup.sql` – Tabellen, RLS, Storage und Realtime
- `manifest.webmanifest` – Installation als Web-App
- `sw.js` – Grundcache für die App-Oberfläche
- `icon.svg` – App-Icon

## Fotos pro Schaden
- Pro Schaden können beliebig mehrere Fotos ausgewählt bzw. mit dem Handy aufgenommen werden.
- In der Schadenliste zeigt ein Foto-Zähler die Anzahl Bilder an.
- Über **Fotos (x)** öffnet sich die Galerie direkt beim Schaden.
- Einzelne Bilder können direkt in der Galerie mit **×** gelöscht werden.
- Beim Bearbeiten können weitere Fotos hinzugefügt oder entfernt werden.
