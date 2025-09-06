--[[
******************* OverlayHandling:



OverlayHandler consolidates UI module handling and handles parameter validation.

NOTE: keys in {options} table must be lowercase

fields per UI module:

	modal = {
		REQUIRED: 
			- title
			- primary_text
			- button_text
			- button_action (link this to a function to be called when the action button is pressed)
		OPTIONAL:
			- icon_id
			- icon_text (e.g. "20% off!""),
			- button_strikethrough_text (to show discounts, i.e. "R$ 3000" will appear with a red line through it above the button's main text),
			- under_icon_text (e.g. "Gain infinite power!") appears under the icon,
		}
	toast = {primarytext}
	notification = {title, primarytext}
	
optional fields per UI module:
	
	modal = {
		
		}



******************* ScreenButtonHandling:




]]