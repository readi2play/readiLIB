local _, readi = ...

READI.Localization = READI.Localization or {}
RD.L10N = READI.Localization

READI.Localization.enUS = {
  ["errors"] = {
    ["general"] = {
      ["data_is_nil"] = [=[
        "Invalid required argument 'data'. Please provide a valid table with the following attributes in it:
        ["addon"] which is a string representing the addon that uses this library function, could be the name or an abbreviation
        ["keyword"] which is a keyword within the "db" table
      ]=],
      ["invalid_addonname_or_abbreviation"] = "Invalid addon name or abbreviation. Please provide a valid addon name or abbreviation (e.g. 'MFA' for 'My Fancy Addon*')",
      ["no_data_storage"] = "No data storage keyword given. Please provide a data storage keyword to look at.",
    },
    ["button"] = {
      ["opts_is_nil"] = [=[
        Invalid required argument "opts". Please provide a valid table with at least the following attributes in it:
        ["onClick"] which is a function (not a function's result)
      ]=],
    }
  }
}