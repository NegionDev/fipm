#Requires AutoHotkey v2.0
#Include WebViewToo\WebViewToo.ahk

; main resources
;@Ahk2Exe-AddResource ..\shared\schema\config.json, schema\config.json

; gui resources
;@Ahk2Exe-AddResource lib\WebViewToo\32bit\WebView2Loader.dll, 32bit\WebView2Loader.dll
;@Ahk2Exe-AddResource lib\WebViewToo\64bit\WebView2Loader.dll, 64bit\WebView2Loader.dll
;@Ahk2Exe-AddResource view\index.html, view\index.html
;@Ahk2Exe-AddResource view\js\script.js, view\js\script.js
;@Ahk2Exe-AddResource view\css\style.css, view\css\style.css

if (A_IsCompiled) {
    resources := [
        (A_PtrSize * 8) . "bit\WebView2Loader.dll",
        "schema\config.json",
        "view\index.html",
        "view\js\script.js",
        "view\css\style.css"
    ]

    For resource in resources {
        WebViewCtrl.CreateFileFromResource(resource, WebViewCtrl.TempDir)
    }

    OnExit(OnScriptExit)
}

OnScriptExit(reason, *) {
    if (reason ~= "Reload|Single") {
        return
    }

    if (DirExist(WebViewCtrl.TempDir)) {
        try {
            Sleep(500)
            DirDelete(WebViewCtrl.TempDir, true)
        }
    }
}