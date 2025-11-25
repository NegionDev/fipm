#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <constants>
#Include <gui>
#Include <utils>
#Include <visual>

; Script State
Toggle := false
Step := "Idle" ; Idle ➟ Charging ➟ Waiting ➟ Reeling ↺
ChargeHoldTime := 0
HotkeyConfig := GetConfig().Get("HOTKEYS")

; Waiting for the player to equip their rod to start fishing...
Idle() {
    try {
        detected := IndicatorSearch(GetRodIndicator())
        DebugToolTip(
            detected ? "The Rod Indicator has been founded." : "Looking for a rod indicator...",
            3
        )

        if (detected) {
            global ChargeHoldTime := A_TickCount
            global Step := "Charging"
        }
    } catch as err {
        ShowToolTip("We encountered an error when attempting to detect the rod indicator.")
        throw err
    }
}

; Cast the fishing rod until it is perfect...
Charging() {
    try {
        minimumChargeHold := GetConfig().Get("GENERAL").Get("MINIMUM_CHARGE_HOLD")
        detected := IndicatorSearch(GetLuckIndicator())
        DebugToolTip(
            detected ? "The Luck Indicator has been founded." : "Looking for a luck indicator...",
            3
        )

        if (detected && (A_TickCount - ChargeHoldTime) >= minimumChargeHold) {
            RandomClick("Up Left")
            global Step := "Waiting"
        } else {
            RandomClick("Down Left")
        }
    } catch as err {
        ShowToolTip("We encountered an error when attempting to detect the luck indicator.")
        throw err
    }
}

; Waiting for the fish to take the bait...
Waiting() {
    try {
        detected := IndicatorSearch(GetReelIndicator())
        DebugToolTip(
            detected ? "The Reel Indicator has been founded." : "Looking for a reel indicator...",
            3
        )

        if (detected) {
            Sleep(GetConfig().Get("GENERAL").Get("PRE_REEL_DELAY"))
            global Step := "Reeling"
        }
    } catch as err {
        ShowToolTip("We encountered an error when attempting to detect the reel indicator.")
        throw err
    }
}

; Spam clicking until the fish is caught...
Reeling() {
    try {
        config := GetConfig().Get("GENERAL")
        detected := IndicatorSearch(GetReelIndicator())
        DebugToolTip(
            detected ? "Waiting for the reel indicator to disappear..." : "Attempting to repeat the step...",
            3
        )

        if (detected) {
            reelTapInterval := config.Get("REEL_TAP_INTERVAL") + Random(0, config.Get("RANDOMIZE_TAP_INTERVAL"))

            RandomClick("Down Left")
            Sleep(reelTapInterval)
            RandomClick("Up Left")
        } else {
            Sleep(config.Get("PRE_IDLE_DELAY"))
            global Step := "Idle"
        }
    } catch as err {
        ShowToolTip("We encountered an error when attempting to detect the reel indicator.")
        throw err
    }
}

; Reload the script
Hotkey(HotkeyConfig.Get("RELOAD_MACRO"), (*) => Reload())

; Exit the script
Hotkey(HotkeyConfig.Get("EXIT_MACRO"), (*) => ExitApp())

; Toggle fishing macro
Hotkey(HotkeyConfig.Get("TOGGLE_FISHING"), (*) => ToggleFishing(), "T2")

; Toggle fishing macro function
ToggleFishing() {
    processTitle := GetProcessName()

    if (!WinExist(processTitle)) {
        MsgBox("The macro cannot run if the Roblox process is not found.", APP_TITLE)
        return
    }

    if (!WinActive(processTitle)) {
        WinActivate(processTitle)
    }

    if (Toggle) {
        return CleanUp()
    }

    global Toggle := true

    if (GetConfig().Get("GENERAL").Get("HIDE_GUI_WHEN_ENABLED")) {
        WV.Hide()
    }

    UpdateUIStatus(true)
    RunFishingStep()
}

; Run the fishing loop step
RunFishingStep() {
    config := GetConfig().Get("GENERAL")
    startTime := A_TickCount
    previousStep := Step

    while (Toggle) {
        try {
            if (!WinActive(GetProcessName())) {
                CleanUp()
                break
            }

            if ((A_TickCount - startTime) >= config.Get("STEP_TIMEOUT")) {
                CleanUp()
                Sleep(config.Get("PRE_IDLE_DELAY"))
                ToggleFishing()
                break
            }

            DebugToolTip("Current Step: " . Step, 1)
            DebugToolTip("Step Timeout: " . ParseMilliseconds(A_TickCount - startTime), 2)
            UpdateUIStep(Step)

            %Step%()

            if (previousStep != Step) {
                startTime := A_TickCount
                previousStep := Step
            }

            Sleep(config.Get("LOOP_INTERVAL"))
        } catch {
            break
        }
    }
}

CleanUp() {
    global Toggle := false
    global Step := "Idle" ; Idle ➟ Charging ➟ Waiting ➟ Reeling ↺
    global ChargeHoldTime := 0

    RandomClick("Up Left")
    UpdateUIStatus(false)
    UpdateUIStep("Disabled")

    if (GetConfig().Get("GENERAL").Get("HIDE_GUI_WHEN_ENABLED")) {
        WV.Show("w800 h600")
    }

    Loop (20) {
        ToolTip(, , , A_Index)
    }
}