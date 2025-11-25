#Requires AutoHotkey v2.0
#Include WebViewToo\WebViewToo.ahk
#Include constants.ahk

WebViewSettings := {}
if (A_IsCompiled) {
    WebViewCtrl.CreateFileFromResource((A_PtrSize * 8) . "bit\WebView2Loader.dll", WebViewCtrl.TempDir)
    WebViewSettings := { DllPath: WebViewCtrl.TempDir . "\" . (A_PtrSize * 8) . "bit\WebView2Loader.dll" }
}

WV := WebViewGui("+Resize -Caption", , , WebViewSettings)
if (!A_IsCompiled) {
    WV.AllowGlobalAccessFor("localhost")
}

WV.OnEvent("Close", (*) => ExitApp())
WV.Navigate(A_IsCompiled ? "view/index.html" : "http://localhost:5173/")
WV.Show("w800 h600")

UpdateUIStatus(status) {
    return WV.ExecuteScriptAsync(
        "document.querySelector('input#toggle-macro').checked = " . (status ? "true" : "false") . ";" .
        "document.querySelector('div#circle-icon-status').innerText = '" . (status ? "🟢" : "🔴") . "';" .
        "document.querySelector('h2#toggle-status').innerText = '" . (status ? "Enabled" : "Disabled") . "';"
    )
}

UpdateUIStep(step_text) {
    return WV.ExecuteScriptAsync("document.querySelector('p#step-status').innerText = '" . step_text . "';")
}