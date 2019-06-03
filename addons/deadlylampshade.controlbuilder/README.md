# How to use
In order to use you must first create the object via ControlBuilder.new()

It's ready to go as soon as you do that.

# Noteworthy Functions
*(Note that ALL args in italics are optional)*

## Core
- **finish()** call it when you're finished using it. It returns the control tree you've just created.
- **start_context()** Whenever you specify a container, call this immediately to add the context to the stack.
- **end_context()** This is the reverse to start_context(), this function removes the last context added to the stack.

## Buttons
- **add_button(*title, icon, h_flags, v_flags, stretch_ratio*)** Creates a button and adds it to the context or tree, this Returns the button that was just created.
- **add_checkbutton(*title, icon, h_flags, v_flags, stretch_ratio*)** Creates a Checkbutton. Returns the Checkbutton.
- **add_checkbox(*title, icon, h_flags, v_flags, stretch_ratio*)** Creates a Checkbox. Returns the Checkbox.

## Color
- **add_color_picker_button(*color, h_flags, v_flags, stretch_ratio*)** Adds a color picker button that defaults to the color chosen. Returns the Color Picker Button.
- **add_color_picker(*color, h_flags, v_flags, stretch_ratio*)** Adds a color picker. Returns the color picker created.

## Text Editing
- **add_line_edit(*h_flags, v_flags, stretch_ratio*)** Adds a line edit. Returns the line edit created.
- **add_text_edit(*h_flags, v_flags, stretch_ratio*)** Adds a text edit. Returns the text edit created.

## Range
- **add_spin_box(*min, _max, h_flags, v_flags, stretch_ratio*)**
- **add_hscroll(*min, _max, h_flags, v_flags, stretch_ratio*)**
- **add_vscroll(*min, _max, h_flags, v_flags, stretch_ratio*)**
- **add_hslider(*min, _max, h_flags, v_flags, stretch_ratio*)**
- **add_vslider(*min, _max, h_flags, v_flags, stretch_ratio*)**
- **add_progress_bar(*min, _max, h_flags, v_flags, stretch_ratio*)**

## Generic
- **add_label(*text, h_flags, v_flags, stretch_ratio*)**
- **add_blank_control(*h_flags, v_flags, stretch_ratio*)**
- **add_vseperator(*h_flags, v_flags, stretch_ratio*)**
- **add_hseperator(*h_flags, v_flags, stretch_ratio*)**
- **add_custom_control(control, *h_flags, v_flags, stretch_ratio*)** Adds a specified control object. Returns control.

## Containers
- **add_hbox(*h_flags, v_flags, stretch_ratio*)**
- **add_vbox(*h_flags, v_flags, stretch_ratio*)**
- **add_hsplit(*h_flags, v_flags, stretch_ratio*)**
- **add_vsplit(*h_flags, v_flags, stretch_ratio*)**
- **add_panelbox(*h_flags, v_flags, stretch_ratio*)** Adds a panel container.
- **add_center_container(*h_flags, v_flags, stretch_ratio*)**
- **add_scroll_container(*vertical, horizontal, h_flags, v_flags, stretch_ratio*)**
- **add_grid_container(*columns, h_flags, v_flags, stretch_ratio*)**
- **add_tab_container(*h_flags, v_flags, stretch_ratio*)**
