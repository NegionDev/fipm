# Fish It! 🐟 Perfect Macro

Increase your in-game fishing luck with this lightweight, open-source macro.

## DIY

> Prerequisites: TypeScript, Node.js, and AutoHotkey v2 scripting knowledge.

1. Install the frontend dependencies:

```bash
npm install
```

2. Build the frontend assets (HTML, CSS, JS):

```bash
npm run build
```

3. The generated assets will appear inside `source` directory as a new folder named `view`.

4. Compile `main.ahk` file to `.exe` with [Ahk2Exe](https://github.com/AutoHotkey/Ahk2Exe)

## Credits

FIPM built with these awesome AutoHotkey libraries:

- [cJson.ahk](https://github.com/G33kDude/cJson.ahk) – lightning-fast JSON parsing & stringifying
- [WebViewToo](https://github.com/The-CoDingman/WebViewToo) – modern embedded browser for AHK v2
- [ShinsOverlayClass](https://github.com/Spawnova/ShinsOverlayClass) - Create Direct2D overlays for in-game heads up information
