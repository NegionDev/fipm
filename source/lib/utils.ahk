#Requires AutoHotkey v2.0
#Include cJson\JSON.ahk
#Include constants.ahk

; Limiting a value to a range between a minimum and a maximum value
Clamp(value, minimum, maximum) {
    return Max(minimum, Min(value, maximum))
}

; Create a new file if it's doesn't exist, and overwrite the content if it's exist
FileWrite(filename, text := "") {
    return FileOpen(filename, "w").Write(text)
}

; Get configuration settings from json file
GetConfig() {
    static config := unset
    static lastModifiedTime := 0
    DefaultConfigFilePath := A_IsCompiled ? WebViewCtrl.TempDir . "\schema\config.json" : A_ScriptDir . "\..\shared\schema\config.json"

    try {
        if (!FileExist(CONFIG_FILE_PATH)) {
            FileWrite(CONFIG_FILE_PATH, FileRead(DefaultConfigFilePath))
        }

        currentModifiedTime := FileGetTime(CONFIG_FILE_PATH, "M")

        if (!IsSet(config) || currentModifiedTime != lastModifiedTime) {
            config := JSON.LoadFile(CONFIG_FILE_PATH)
            lastModifiedTime := currentModifiedTime
        }

        return config
    } catch {
        return JSON.LoadFile(DefaultConfigFilePath)
    }
}

; Get the valid process name
GetProcessName() {
    return "ahk_exe " . GetConfig().Get("GENERAL").Get("PROCESS_NAME")
}

; Shows a message via ToolTip
ShowToolTip(message, x := 0, y := 0, which_tool_tip := 20, timeout := 1000) {
    ToolTip(, , , which_tool_tip)
    ToolTip(message, x, y, which_tool_tip)
    SetTimer(() => ToolTip(, , , which_tool_tip), timeout)
}

; Shows a debug via ToolTip
DebugToolTip(message, which_tool_tip := 1) {
    if (!GetConfig().Get("GENERAL").Get("DEBUG_MODE")) {
        return
    }

    y := 100 + ((which_tool_tip - 1) * 25)

    ToolTip(message, 50, y, which_tool_tip)
}

; Control over mouse click with random position
RandomClick(options*) {
    WinGetClientPos(, , &clientWidth, &clientHeight, GetProcessName())

    x := Round(clientWidth / 2) + Random(10, 50)
    y := Round(clientHeight / 2) + Random(10, 50)

    return Click(x, y, options*)
}

; Parse milliseconds into a readable time
ParseMilliseconds(ms := 0) {
    milliseconds := Max(0, ms)
    seconds := milliseconds // 1000
    minutes := seconds // 60
    hours := minutes // 60

    return Format("{:02}:{:02}:{:02}.{:03}", hours, minutes, seconds, milliseconds)
}