#Requires AutoHotkey v2.0
#Include WebViewToo\WebViewToo.ahk
#Include constants.ahk

WebViewSettings := {}
if (A_IsCompiled) {
    WebViewSettings := { DllPath: WebViewCtrl.TempDir . "\" . (A_PtrSize * 8) . "bit\WebView2Loader.dll" }
}

WV := WebViewGui("+Resize -Caption", , , WebViewSettings)
if (A_IsCompiled) {
    host := "fipm.localhost"

    WV.SetVirtualHostNameToFolderMapping(host, WebViewCtrl.TempDir . "\view", WebView2.HOST_RESOURCE_ACCESS_KIND.ALLOW)
    WV.Navigate("http://" . host . "/index.html")
} else {
    WV.AllowGlobalAccessFor("localhost")
    WV.Navigate("http://localhost:5173/")
}

WV.OnEvent("Close", (*) => (
    WV.Hide()
    ExitApp()
))

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