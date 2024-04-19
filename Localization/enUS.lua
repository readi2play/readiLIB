local _, rdl = ...

READI.Localization = READI.Localization or {}
RD.L10N = READI.Localization

READI.Localization.enUS = {
  general = {
    labels = {
      buttons = {
        reset = "Reset",
        clear = "Clear all",
        unselectAll = "Unselect all",
        selectAll = "Select all",
        cancel = "Cancel",
        okay = "OK",
        submit = "Submit",
        yes = "Yes",
        no = "No",
      }
    },
    commons = {
      default = "Default",
      button = {
        none = "Buttons",
        one = "Button",
        some = "Buttons"
      },
      debugging = "Debugging",
      notification = {
        none = "Notifications",
        one = "Notification",
        some = "Notifications"
      }
    },
    tooltips = {
      buttons = {
        frameSelector = "Select frame",
      },
    },
  },
  errors = {
    general = {
      data_is_nil = [=[
        Invalid required argument `data`. Please provide a valid table with the following attributes in it:
        - addon which is a string representing the addon that uses this library function, could be the name or an abbreviation
        - keyword which is a keyword within the "db" table
      ]=],
      invalid_addonname_or_abbreviation = "Invalid addon name or abbreviation. Please provide a valid addon name or abbreviation (e.g. 'MFA' for 'My Fancy Addon*')",
      no_data_storage = "No data storage keyword given. Please provide a data storage keyword to look at.",
    },
    icon = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onClick [function]
      ]=],
      no_texture = [=[
        No texture given. Please provide a texture otherwise the Icon ain't be visible.
      ]=],
    },
    button = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onClick [function]
      ]=],
      no_onClick = [=[
        No click handler has been given. Please provide a function handling the click events on the button.
      ]=]
    },
    checkbox = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onClick [function]\n\t
      ]=],
      no_label = [=[
        "No label given. Please provide a label for the checkbox for a neat user experience."
      ]=]
    },
    radiobutton = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onClick [function]\n\t
      ]=],
      no_option = [=[
        "No option given. Please provide an option for the radiobutton to represent."
      ]=],
      no_value = [=[
        "No value given. Please provide an value for the radiobutton."
      ]=],
      no_onClick = [=[
        "No handler for OnClick event given. Please provide a function to handle what's to happen when clicking the RadioButton"
      ]=]
    },
    slider = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onChange [function]\n\t
      ]=],
    },
    editbox = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onChange [function]\n\t
      ]=],
    },
    dropdown = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onChange [function] :\n\t
        - values [table] : the index based list of options within the dropdown\n\t
        - selected [string] : the initially selected value
      ]=],
      values = [=[
        "No values given. Please provide a list of values so select from with the dropdown"
      ]=],
      no_onChange = [=[
        "No handler for the OnChange event has been given. Please provide a function to be called when the value of the dropdown changes."
      ]=]
    },
    panel = {
      opts_is_nil = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:\n\t
        - onChange [function] :\n\t
        - values [table] : the index based list of options within the dropdown\n\t
        - selected [string] : the initially selected value
      ]=],
      no_name = "No name has been given. Please provide a name for the panel to create."
    }
  }
}