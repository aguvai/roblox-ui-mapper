--[[
==================================================
# Roblox UI Handling Framework
==================================================

This framework provides a structured way to **map buttons to GUIs** and apply consistent **animations, preferences, and special actions**.  
It is modular, so you can easily extend or swap out parts as needed.  

==================================================
******************* OverlayHandling:
==================================================

OverlayHandler consolidates UI module handling and parameter validation for **modals**, **toasts**, and **notifications**.  

NOTE: Keys in the `{options}` table must be lowercase.  

--------------------------------------------------
Modal
--------------------------------------------------
A **modal** is a popup that blocks interaction until dismissed.  

Required fields:
- title
- primary_text
- button_text
- button_action (function called when button is clicked)

Optional fields:
- icon_id
- icon_text (e.g. "20% off!")
- button_strikethrough_text (e.g. "R$ 3000" will appear crossed-out above button)
- under_icon_text (e.g. "Gain infinite power!")

--------------------------------------------------
Toast
--------------------------------------------------
A **toast** is a lightweight, temporary message.  

Required fields:
- primary_text

Optional fields:
- type ("success", "error", "info", "warning") DEFAULT: "info"

--------------------------------------------------
Notification
--------------------------------------------------
A **notification** is a persistent popup with an action.  

Required fields:
- title
- primary_text
- button_text
- button_action

Optional fields:
- icon_id
- icon_text

--------------------------------------------------
Overlay Utils
--------------------------------------------------
- RotationHandler: caches/restores rotation of UI objects for smoother tweening in clipping frames.  

- Validate:
    * validatePlayer(player) → checks if input is a Player  
    * validateOptions(options, requiredFields) → ensures options table has required fields  
    * fetchOverlayScreenGUI(player) → gets Overlay ScreenGUI from PlayerGui (uses Preferences.OverlayUIName)  

==================================================
******************* ScreenButtonHandling:
==================================================

Links **UI buttons** to their **GUIs or special functions**.  
Enforces naming conventions, applies tween animations, and provides a clean structure for handling open/close logic.  

--------------------------------------------------
File Breakdown
--------------------------------------------------

preferences.lua
- Stores tween styles and positions.
- Example:
    openTween = {time = 0.3, easingStyle = Enum.EasingStyle.Quart, easingDirection = Enum.EasingDirection.Out}
    UI_closedPosition = UDim2.new(0.5, 0, -1.5, 0)
    UI_openedPosition = UDim2.new(0.5, 0, 0.5, 0)

- Defines naming rules:
    - GUICloseButton
    - MainFrame
    - ProximityPrompts

--------------------------------------------------
guimapper.lua
--------------------------------------------------
- Maps a GUI to its required elements:
    - openButton (button that opens it)
    - closeButton (must be "GUICloseButton")
    - mainFrame (must be "MainFrame")
    - proximityPrompts (optional folder of ObjectValues referencing ProximityPrompts)

- Validates buttons (ImageButton/TextButton).
- Validates ProximityPrompt references.

--------------------------------------------------
animationfunctions.lua
--------------------------------------------------
- Handles all UI animations:
    - Open button hover: expands/shrinks InnerCircle
    - Close button hover: adjusts transparency
    - openGUI / closeGUI tweens frames in/out
    - clearGUIs() hides all GUIs

--------------------------------------------------
specialbuttonfunctions.lua
--------------------------------------------------
- Handles buttons mapped to **special actions** instead of GUIs.

Built-in:
    - GamepassPrompt → MarketplaceService:PromptGamePassPurchase
    - InviteFriends → SocialService:PromptGameInvite

Extendable:
    - Add more entries to SpecialButtonFunctions.actions

--------------------------------------------------
uiopenclosehandler.lua
--------------------------------------------------
Main entry point for ScreenButtonHandling.

Steps:
1. Scans all buttons in ButtonHolder.
   - If GUI with same name exists → map with GUIMapper.
   - If no GUI → check if SpecialButtonFunctions handles it.
   - Otherwise → warn.

2. Normalizes GUIs on startup (hidden + placed at closed position).

3. Wires up events for each GUI:
   - Open button click → opens GUI
   - Open button hover → plays hover animation
   - ProximityPrompt trigger → opens GUI
   - Close button click → closes GUI
   - Close button hover → plays hover animation

==================================================
Naming Conventions (REQUIRED)
==================================================

1. Each ScreenGUI must have:
   - A child named "MainFrame"
   - A "GUICloseButton"

2. Open button must be named:
   GUIName_OpenButton
   Example:
   - GUI: StoreGUI
   - Open button: StoreGUI_OpenButton

3. Optional ProximityPrompts:
   - Folder named "ProximityPrompts" inside the GUI
   - Contains ObjectValues referencing actual ProximityPrompt instances

==================================================
Usage Example
==================================================

Suppose you have a Store GUI:

PlayerGui
  └─ ButtonHolder
      └─ StoreGUI_OpenButton
  └─ StoreGUI
      ├─ MainFrame
      ├─ GUICloseButton
      └─ ProximityPrompts
           └─ ObjectValue → (ProximityPrompt in workspace)

Result:
- Clicking StoreGUI_OpenButton opens StoreGUI
- Other GUIs close automatically
- Hover animations play
- StoreGUI can be closed with GUICloseButton or ProximityPrompt

==================================================
Extending the System
==================================================

- To add a new GUI:
  - Follow naming conventions
  - Place open button in ButtonHolder
  - Add MainFrame + GUICloseButton
  - (Optional) Add ProximityPrompts

- To add a special button:
  - Place button in ButtonHolder
  - Register it in SpecialButtonFunctions.actions