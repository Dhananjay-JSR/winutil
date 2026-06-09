function Set-WinUtilSliderFromTouch {
    <#

    .SYNOPSIS
        Sets a WPF Slider's value from a horizontal touch position.

    .DESCRIPTION
        WPF Sliders do not respond to touch dragging on touchscreen-only
        devices because touch is not promoted to the mouse input the Slider
        thumb relies on. This maps a touch X position onto the slider's range
        so the thumb follows the finger, snapping to the nearest tick to keep
        behavior consistent with mouse and keyboard interaction.

    .PARAMETER Slider
        The Slider control to update.

    .PARAMETER PositionX
        The horizontal touch position relative to the slider.

    .EXAMPLE
        Set-WinUtilSliderFromTouch -Slider $sync.FontScalingSlider -PositionX 60
    #>

    param (
        [Parameter(Mandatory)] $Slider,
        [Parameter(Mandatory)] [double]$PositionX
    )

    if ($Slider.ActualWidth -le 0) { return }

    # Map the touch position onto the slider's value range (clamped to [0, 1])
    $ratio = $PositionX / $Slider.ActualWidth
    if ($ratio -lt 0) { $ratio = 0 }
    elseif ($ratio -gt 1) { $ratio = 1 }

    $range = $Slider.Maximum - $Slider.Minimum
    $value = $Slider.Minimum + ($ratio * $range)

    # Snap to the nearest tick so touch matches mouse/keyboard behavior
    if ($Slider.TickFrequency -gt 0) {
        $steps = [math]::Round(($value - $Slider.Minimum) / $Slider.TickFrequency)
        $value = $Slider.Minimum + ($steps * $Slider.TickFrequency)
    }

    $Slider.Value = $value
}
