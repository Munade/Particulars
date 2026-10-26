# Particulars

Keep your Nigerian vehicle documents on your phone, see what's expired at a glance, and get reminders before anything runs out.

Built with [Capacitor](https://capacitorjs.com) (the app screen lives in `www/index.html`). The Android app is built automatically on GitHub every time code is pushed to `main`, so you don't need Android Studio or a computer.

## What's in here

| Path | What it is |
|---|---|
| `www/index.html` | The whole app screen (HTML, CSS, JS) |
| `capacitor.config.json` | App name and ID (`com.munade.particulars`) |
| `resources/android/` | App icon and notification icon |
| `.github/workflows/android.yml` | Cloud build: makes the test APK and the Play Store bundle |
| `docs/privacy-policy.md` | Privacy policy (Google Play needs a public link to it) |
| `docs/store-listing.md` | Text and answers for the Play Store listing |
| `store/` | 512px icon and feature graphic for the store |

## Step 1: Install a test version on your phone

1. Open the repo on GitHub → **Actions** tab → latest **Build Android app** run.
2. When it has a green tick, scroll to **Artifacts** and download `particulars-test-apk-…`.
3. Unzip it and open `app-debug.apk`. Android will ask you to allow installs from your browser or file manager. Allow it, then install.

## Step 2: Turn on Play Store builds (signing key)

You were given two files: `particulars-upload.jks` and `particulars-secrets.txt`. Keep both safe (for example in Google Drive). If you lose them you'll have to ask Google to reset your upload key.

1. Repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**.
2. Add the four secrets listed in `particulars-secrets.txt`: `KEY_ALIAS`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEYSTORE_BASE64`.
3. Go to **Actions** → **Build Android app** → **Run workflow**.
4. The run now also produces `particulars-play-bundle-…` containing `app-release.aab`. That's the file Google Play wants.

## Step 3: Publish the privacy policy

Google Play needs a public web link. Easiest options:
- Paste the text of `docs/privacy-policy.md` into a free Google Site or Notion page and publish it, **or**
- Make this repo public and turn on **Settings → Pages** (branch `main`, folder `/docs`). The link becomes `https://munade.github.io/particulars/privacy-policy`.

## Step 4: Google Play Console

1. Sign up at https://play.google.com/console (one-off US$25). Verify your identity.
2. **Create app** → name *Particulars*, Free, App.
3. Fill in **App content** and **Store listing** using `docs/store-listing.md`.
4. **Testing → Closed testing**: upload `app-release.aab`, add at least **12 testers** (their Gmail addresses), and keep the test running for **14 days**. New personal developer accounts must do this before going public.
5. After 14 days, apply for **Production** access and roll out.

## Step 5: Automatic uploads to Google Play (after the first manual upload)

Google only lets the API update an app that already exists, so upload the first `app-release.aab` by hand (Step 4). After that:

1. In **Google Cloud Console** (console.cloud.google.com), create a project, enable the **Google Play Android Developer API**, then go to **IAM → Service accounts → Create**. Open the new account → **Keys → Add key → JSON** and download the file.
2. In **Play Console → Users and permissions → Invite new users**, paste the service account's email, give it access to Particulars with **Release to testing tracks** (and **Release to production** if you want), and send the invite.
3. In GitHub, add a secret named `PLAY_SERVICE_ACCOUNT_JSON` and paste the whole JSON file contents as its value.

Every push to `main` now builds the app and uploads it to the **internal testing** track as a **draft**. To change that, add repository **variables** (Settings → Secrets and variables → Actions → Variables):
- `PLAY_TRACK`: `internal`, `alpha` (closed testing) or `production`
- `PLAY_STATUS`: `draft` while the app has never been published; `completed` once it is live, so releases roll out without you pressing anything

## Making changes

Edit `www/index.html`, push to `main`, and a new build appears in Actions. The version number goes up automatically with each build.
