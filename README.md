# TextVars Plugin for Godot

TextVars is a Godot plugin that lets you easily insert variables into your text labels through scripts and in the Inspector. This plugin was created as a submission to the Godot Add-on Jam #1.

[Get the TextVars plugin on itch.io](https://fire-forge.itch.io/textvars)

## How to Use:
* Add the `addons/text_vars/TextVars.gd` script to a Label or RichTextLabel node.
  * **Pro Tip:** add the script to your favorites (using the right-click menu) so you don't have to go to the plugin folder every time.
* Type text into the `Source Text` property, including variables using the `{variable_name}` syntax
* Add variables by expanding the TextVars property
* To add a variable, type a name into the box (or use the <kbd>Auto</kbd> button to select from variables names found in source text to save some extra typing), select a type from the list, enter a value, and press <kbd>Add Variable</kbd>.
  * There are 3 types included in the plugin: String, Color, and int. Colors are converted to HTML format, which is useful for the text color tag in RichTextLabels. I only included these 3 types because they all get converted to strings in the end.
* To change an existing variable's type or remove it, use the menu button to the right of each list item.
* You can also add, change, and remove variables through scripts (see the API section below).

## API:
### Functions:
```gdscript
set_var(variable_name: String, value: any)
```
Set the variable's value and update text. Color is converted to HTML format and all other types are converted to strings. This can not only be used to change existing variables, but to add new ones as well.

```gdscript
remove_var(variable_name: String)
```
Remove the variable and update text.

```gdscript
get_var(variable_name: String) -> any
```
Get the variable's value.

### Properties:
```gdscript
source_text: String
```
The label's text including variable names, which will be replaced with their values by the plugin. Changing this value will update the text.

```gdscript
text_vars: Dictionary
```
The list of variables in dictionary format. This is useful for iterating over all variables, finding how many variables there are, or updating multiple variables at the same time. Setting this property will update the text, but just writing to the dictionary will not.
