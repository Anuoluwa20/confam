# Confam website (demo)

Check before you send money. A demo site with sample data only.

## Run it
1. Open this folder in VS Code (File → Open Folder → confam-website).
2. Install the **Live Server** extension when VS Code suggests it.
3. Right-click `index.html` → **Open with Live Server**.

You can also double-click `index.html` to open it in a browser.

## What's inside
- `index.html` – the whole site (HTML, CSS and JavaScript in one file)
- `img/` – the photos. Keep this folder next to `index.html`.

## Pages (hash routes)
`#home`, `#check`, `#result`, `#how`, `#report`, `#vendors`, `#maths`

## Needs internet for
- Fonts (Google Fonts)
- The 3D lens (three.js from cdnjs)

Everything else works offline.

## Put it live on GitHub Pages
1. Create a new **public** repository on GitHub, for example `confam-website`.
2. Upload everything in this folder (keep `index.html` at the top level, next to `img/`).
3. In the repo go to **Settings → Pages**.
4. Under **Build and deployment**, set Source to **Deploy from a branch**, Branch to **main**, folder **/ (root)**, then **Save**.
5. After a minute your site is live at `https://YOUR-USERNAME.github.io/confam-website/`.
