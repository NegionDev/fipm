#Requires AutoHotkey v2.0
#Include ShinsClass\ShinsOverlayClass.ahk
#Include constants.ahk
#Include utils.ahk

; Return the value of indicator
IndicatorValue(indicator_rect, indicator_config := Map()) {
    return {
        rect: {
            x: indicator_rect.x + indicator_config.Get("X", 0),
            y: indicator_rect.y + indicator_config.Get("Y", 0),
            w: indicator_rect.w + indicator_config.Get("W", 0),
            h: indicator_rect.h + indicator_config.Get("H", 0),
        },
        colorId: Number(StrReplace(indicator_config.Get("COLOR_ID", "#000"), "#", "0x")),
        tolerance: indicator_config.Get("TOLERANCE", 5),
    }
}

; Get the rod indicator rect offset
GetRodRect() {
    ; get the client width and height for calculation purpose
    WinGetClientPos(, , &clientWidth, &clientHeight, GetProcessName())

    ; get the scaling point for the related element size
    scaleFactorX := Clamp(GetResponsiveScale(clientWidth, REFERENCE_WIDTH, { sensitivity: 1.49 }), 0.1, 1.0)
    scaleFactorY := Clamp(GetResponsiveScale(clientHeight, REFERENCE_HEIGHT), 0.1, 1.0)

    ; define the size of the "AUTO" button (cuz it's important)
    autoButtonWidth := Round(128 * scaleFactorX)
    autoButtonHeight := Round(54 * scaleFactorX)

    ; define the vertical space between the button and the indicator (it's important too)
    spaceBetweenY := 10

    ; define the height of the target indicator
    targetHeight := Round(17 * scaleFactorY)

    ; get the calculated position of the target indicator
    targetPosition := GetElementPosition(clientWidth, clientHeight, {
        anchor_x: 0.5, ; center ofc
        anchor_y: 0.867, ; the bottom of the "AUTO" button
        scale_y: GetPositionCompensation(clientHeight, REFERENCE_HEIGHT, { sensitivity: 0.17 }),
        offset_x: -Round(autoButtonWidth / 2),
        offset_y: -(autoButtonHeight + spaceBetweenY + targetHeight)
    })

    return {
        x: targetPosition.x,
        y: targetPosition.y,
        w: autoButtonWidth,
        h: targetHeight,
    }
}

; Get the rod indicator object
GetRodIndicator() {
    return IndicatorValue(GetRodRect(), GetConfig().Get("ROD_INDICATOR"))
}

; Get the luck indicator rect offset
GetLuckRect() {
    ; get the client width and height for calculation purpose
    WinGetClientPos(, , &clientWidth, &clientHeight, GetProcessName())

    ; get the scaling point for the related element size
    scaleFactorY := Clamp(GetResponsiveScale(clientHeight, REFERENCE_HEIGHT, { sensitivity: 1.158 }), 0.1, 1.0)

    ; get the size of the charge meter
    chargeMeterWidth := clientHeight >= 625 ? 20 : 17
    chargeMeterHeight := Round(182 * scaleFactorY)

    ; define the size of the target indicator
    targetWidth := 98
    targetHeight := 18

    ; get the calculated position of the target indicator
    targetPosition := GetElementPosition(clientWidth, clientHeight, {
        anchor_x: 0.5,
        anchor_y: 0.5,
        scale_x: 0.068 + GetPositionCompensation(clientWidth, REFERENCE_WIDTH, { sensitivity: 0.0036 }),
        scale_y: 0.013 + GetPositionCompensation(clientHeight, REFERENCE_HEIGHT, { sensitivity: -0.048 }),
        offset_x: chargeMeterWidth + 36,
        offset_y: -(Round(chargeMeterHeight / 2) + 4),
    })

    return {
        x: targetPosition.x,
        y: targetPosition.y,
        w: targetWidth,
        h: targetHeight,
    }
}

; Get the luck indicator object
GetLuckIndicator() {
    return IndicatorValue(GetLuckRect(), GetConfig().Get("LUCK_INDICATOR"))
}

; Get the reel indicator rect offset
GetReelRect() {
    ; get the client width and height for calculation purpose
    WinGetClientPos(, , &clientWidth, &clientHeight, GetProcessName())

    ; get the scaling point for the related element size
    scaleFactorXW := GetResponsiveScale(clientWidth, REFERENCE_WIDTH, { sensitivity: 1.02 })
    scaleFactorXH := GetResponsiveScale(clientWidth, REFERENCE_WIDTH, { sensitivity: 1.06 })

    ; define the size of the target indicator
    targetWidth := Round(115 * scaleFactorXW)
    targetHeight := Round(38 * scaleFactorXH)

    ; get the calculated position of the target indicator
    targetPosition := GetElementPosition(clientWidth, clientHeight, {
        anchor_x: 0.5,
        anchor_y: 0.944,
        scale_y: GetPositionCompensation(clientWidth, REFERENCE_WIDTH, { sensitivity: -0.008 }),
        offset_x: -Round(targetWidth / 2),
        offset_y: -targetHeight
    })

    return {
        x: targetPosition.x,
        y: targetPosition.y,
        w: targetWidth,
        h: targetHeight,
    }
}

; Get the reel indicator object
GetReelIndicator() {
    return IndicatorValue(GetReelRect(), GetConfig().Get("REEL_INDICATOR"))
}

; Get the horizontal and vertical position of the visual element
GetElementPosition(client_width, client_height, options := {}) {
    ; the anchor point of the element (default to top-left)
    anchorX := options.HasOwnProp("anchor_x") ? options.anchor_x : 0.0
    anchorY := options.HasOwnProp("anchor_y") ? options.anchor_y : 0.0

    ; the scaling point from the anchor point for the element
    scaleX := options.HasOwnProp("scale_x") ? options.scale_x : 0.0
    scaleY := options.HasOwnProp("scale_y") ? options.scale_y : 0.0

    ; the fixed point / pixel of the element based on anchor+scaling point
    offsetX := options.HasOwnProp("offset_x") ? options.offset_x : 0
    offsetY := options.HasOwnProp("offset_y") ? options.offset_y : 0

    ; the horizontal and vertical position of the visual element
    x := (anchorX * client_width) + (scaleX * client_width) + offsetX
    y := (anchorY * client_height) + (scaleY * client_height) + offsetY

    return { x: Round(x), y: Round(y) }
}

; Get the responsive measurement's coordinates based on reference coordinates
GetPositionCompensation(client_size, base_size, options := {}) {
    ; how sensitive the coordinate measurement values ​​are
    sensitivity := options.HasOwnProp("sensitivity") ? options.sensitivity : 0.01

    ; the responsive measurement's coordinates
    diff := ((client_size - base_size) * sensitivity) / base_size

    return diff
}

; Get the responsive scaling point for the size of the element
GetResponsiveScale(client_size, base_size, options := {}) {
    ; how sensitive the scaling point ​​are
    sensitivity := options.HasOwnProp("sensitivity") ? options.sensitivity : 1.0

    ; the scaling point
    scale := (client_size / base_size) * sensitivity

    return scale
}

; Search the indicator visual
IndicatorSearch(indicator) {
    try {
        ; skip if the target process window is not active
        if (!WinActive(GetProcessName())) {
            return 0
        }

        ; get the indicator rect
        rect := indicator.rect

        ; get the indicator coordinates
        startX := rect.x
        startY := rect.y
        endX := rect.x + rect.w
        endY := rect.y + rect.h

        ; search the visual
        return PixelSearch(&fx, &fy, startX, startY, endX, endY, indicator.colorId, indicator.tolerance)
    } catch as err {
        throw err
    }
}

; Create calibration rectangle with ShinsOverlay
CaptureRegion(anchor_rect, full_rect) {
    if (!WinActive(GetProcessName())) {
        return 0
    }

    overlay := ShinsOverlayClass(GetProcessName())

    if (overlay.BeginDraw()) {
        overlay.DrawRectangle(full_rect.x, full_rect.y, full_rect.w, full_rect.h, 0x0000FF, 3)
        overlay.EndDraw()
    }

    ToolTip("To specify the coordinates, hold and drag the left mouse button, then release.", 0, 0)
    KeyWait("LButton", "D")
    MouseGetPos(&sx, &sy)

    while (GetKeyState("LButton", "P")) {
        MouseGetPos(&cx, &cy)

        ox := Min(sx, cx)
        oy := Min(sy, cy)
        ow := Abs(sx - cx)
        oh := Abs(sy - cy)

        if (overlay.BeginDraw()) {
            ToolTip("x" . ox . " y" . oy . " w" . ow . " h" . oh)
            overlay.DrawRectangle(ox, oy, ow, oh, 0x0000FF, 3)
            overlay.EndDraw()
        }

        Sleep(50)
    }

    MouseGetPos(&ex, &ey)
    ToolTip()

    fx := Min(sx, ex)
    fy := Min(sy, ey)
    fw := Abs(sx - ex)
    fh := Abs(sy - ey)

    return {
        x: fx - anchor_rect.x,
        y: fy - anchor_rect.y,
        w: fw - anchor_rect.w,
        h: fh - anchor_rect.h
    }
}