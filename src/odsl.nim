import macros
import spreadsheets
import googleapi
import server
import mailFunc
from mailFunc import mailBot
import metaapi
type 
  Name* = object
    name* : string
## macro which reads multiline row statements
## and constructs seq[Row] from them


macro values * (statement : untyped): seq[Row] =
    var start = statement[0]
    for index, row in pairs(statement[0..len(statement)-2]):
        start = newCall("and", start, statement[index+1])
    result = start

# constructs Name type
proc setName * (name : string) : Name =
  result.name = name

proc TO * (s : string) : string =
  result = s

proc ATTACHEMENT * (s : string) : string =
  result = s

proc TEXT * (s : string) : string =
  result = s

proc SUBJECT * (s : string) : string =
  result = s

proc index * (i : int) : int =
  result = i

proc column * (s : string) : string =
  result = s

proc newValue * (s : string) : string =
  result = s

proc newValue * (s : int) : int =
  result = s

proc newValue * (s : float) : float =
  result = s

proc newValue * (s : Nil) : Nil =
  result = s
  
proc source*(s : SpreadSheet)=
  return

proc keep*(s : seq[int]) =
  return 

proc keep*(s : SpreadSheet)=
  return

proc columns*(s : seq[string]) =
  return

proc permits * (s : seq[string]) =
  return

proc USER * (s : string) =
  return

macro ROW * (statement : untyped) =
  return

proc LENGTH * (s : SpreadSheet) : int =
  ## DSL wrapper of len(spreadsheet) function
  result = len(s)

proc SHOW * (s : SpreadSheet) =
  ## DSL wrapper of show(spreadsheet) function
  show(s)

proc SHOW * (s : string) =
  ## DSL wrapper of show(spreadsheet) function
  show(odslServer[s])

proc WHERE * (spreadsheet : SpreadSheet, con1 : string, con2 : string, con3 : string) : seq[int] =
  ## DSL wrapper of where(spreadsheet) function
  result = where(spreadsheet, con1, con2, con3)

macro ADDROW * (spreadsheet : var SpreadSheet, statement : untyped) =
  ## DSL interface for addRow(spreadsheet, row)
  result = newStmtList()
  for s in statement:
    result.add(newCall("addRow", spreadsheet, s))

macro REMOVEROW * (spreadsheet : var SpreadSheet, statement : untyped) =
  ## DSL interface for removeRow(spreadsheet, integer)
  result = newStmtList()
  for s in statement:
    result.add(newCall("removeRow", spreadsheet, s))

macro INSERT * (row : var Row, statement : untyped) =
  ## DSL interface for add(row, value)
  result = newStmtList()
  for s in statement:
    result.add(newCall("add", row, s))

macro REMOVECOLUMN * (sheet : var SpreadSheet, statement : untyped) =
  ## DSL interface for removeColumn(spreadSheet, column)
  result = newStmtList()
  for s in statement:
    result.add(newCall("removeColumn", sheet, s))

macro RENAMECOLUMN * (sheet : var SpreadSheet, statement : untyped) =
  ## DSL interface for renameColumn(spreadsheet, oldName, newName)
  var oldName : NimNode
  var newName : NimNode

  for s in statement:
    case s[0].strVal:
      of "FROM":
        oldName = s[1]
      of "TO":
        newName = s[1]
      else:
        raise newException(KeyError, "Unknown keyword")
  result = newCall("renameColumn", sheet, oldName, newName)

macro ADDCOLUMN * (sheet : var SpreadSheet, statement : untyped) =
  ## DSL interface for addColumn(spreadsheet, name, row)
  result = statement


proc newSpreadsheetGen*(name : Name, rows : seq[Row], header: Row): SpreadSheet = 
  ## Generate new Spreadsheet with given
  ## name
  ## rows
  ## header
  result = newSpreadsheet(name.name, rows, header)

proc newSpreadsheetGen*(rows : seq[Row]): SpreadSheet = 
  ## Generate new Spreadsheet with given
  ## name
  ## rows
  ## header
  result = newSpreadsheet("", rows[1..len(rows)-1], rows[0])

proc newSpreadsheetGen*(rows : Row): SpreadSheet = 
  ## Generate new Spreadsheet with given
  ## name
  ## row
  ## header
  var x : seq[Row]
  result = newSpreadsheet("", x, rows)

macro SENDMAIL * (statement: untyped) =  
  ## Macro for sending Mail
  ## Atomic Action: Send email
  var target : NimNode
  var text : NimNode
  var subject : NimNode
  var attachement : NimNode
  var hasAttach = false
  for s in statement:
    case s[0].strVal:
      of "TO":
        target = s
      of "TEXT":
        text = s
      of "SUBJECT":
        subject = s
      of "ATTACHEMENT":
        hasAttach = true
        attachement = s
  if hasAttach:
    result = newCall("sendNewFile", target, subject, text, attachement)
  else:
    result = newCall("sendNewMail", target, subject, text)


macro CREATE_SPREADSHEET * (statement : untyped) : SpreadSheet =
  ## Macro for returning spreadsheets from logic
  ## Atomic Action: Create Spreadsheet
  result = newCall("newSpreadsheetGen", statement)

macro FROM_PROC * (statement : untyped) : proc() : SpreadSheet =
  ## Macro for returning spreadsheet from logic
  result = newProc(params=[ident("SpreadSheet")], body = statement)


macro setValue * (table : untyped, statement: untyped) =  
  ## Macro for making Sending Mail more accessible
  var target = table
  var index : NimNode
  var column : NimNode
  var newValue : NimNode
  for s in statement:
    case s[0].strVal:
      of "index":
        index = s
      of "column":
        column = s
      of "newValue":
        newValue = s
  result = newCall("setNewValue", target, index, column, newValue)


# Macro for changing permissions
macro setPermissions * (table : untyped, statement: untyped) =  
  var target = table
  var permits : NimNode
  var user : NimNode
  for s in statement:
    case s[0].strVal:
      of "user":
        user = s[1]
      of "permits":
        permits = s[1]
  newCall("setNewPermissions", target, user, permits)


macro view * (statement : untyped) : SpreadSheet =
  ## Defines the Syntax for a call of createView
  var source : NimNode
  var keep : NimNode
  var columns : NimNode
  var gotColumns = false
  for s in statement:
    case $s[0]:
      of "source":
        source = s[1]
      of "keep":
        keep = s[1]
      of "columns":
        columns = s[1]
        gotColumns = true
  if gotColumns:
    result = newCall("createView", source, keep, columns)
  else:
    result = newCall("createView", source, keep)

macro ONACCEPT * (statement : untyped) =
  return

macro ACCEPTIF * (statement : untyped) =
  return

macro ONSEND * (statement : untyped) =
  return

macro ALLOWEDIT * (statement : untyped) =
  return

proc AS * (statement : string) =
  return

proc TO * (statement : string) =
  return

proc UPDATE * (toUpdate : var SpreadSheet, view : SpreadSheet, on = "index") =
  ## DSL Interface for the host-API call update(toUpdate : var SpreadSheet, view : SpreadSheet, on = "index")
  toUpdate.update(view, on)

macro LOAD * (statement : untyped) : SpreadSheet =
  ## Macro Interface for Meta-API loading
  var iden : NimNode
  var creation : NimNode
  for s in statement:
    case s[0].strVal:
      of "AS":
        iden = s[1][0]
      else:
        creation = s
  result = newCall("loadSpreadSheet", creation)


macro SAVE * (statement : untyped) : SpreadSheet =
  ## Macro Interface for Meta-API saving
  var iden : NimNode
  var creation : NimNode
  for s in statement:
    case s[0].strVal:
      of "TO":
        iden = s[1][0]
      else:
        creation = s
  result = newCall("saveSpreadSheet", creation, iden)

  
macro ADDVIEW * (statement : untyped) =
  ## Default Macro for adding views to a server execution
  var name = newStrLitNode("")
  var sheet : NimNode
  for s in statement:
    case s[0].strVal:
      of "AS":
        name = s[1]
      of "LOAD":
        sheet = s
      of "CREATE_SPREADSHEET":
        sheet = s
  result = newCall("addToServer", sheet, name, newStrLitNode("view"))


macro ADDFORM * (statement : untyped) =
  ## Default Macro for adding forms to a server execution
  var name = newStrLitNode("")
  var sheet = newProc(params=[ident("SpreadSheet")]) # Defaul proc which returns just an empty spreadsheet
  var errorMessage = newStrLitNode("An error has occured. Please contact the host for further information") # Default Error Message
  var restricEdits = newEmptyNode()
  var confirmRequirement = newProc(params=[ident("bool"),newIdentDefs(ident("s"), ident("SpreadSheet"))]) # Default proc which triggers, to check valid forms
  var applyChanges = newProc(params=[newEmptyNode(),newIdentDefs(ident("s"), ident("SpreadSheet"))]) # Default proc which triggers, when valid form is submitted
  for s in statement:
    case s[0].strVal:
      of "AS":
        name = s[1]
      of "LOAD":
        sheet = newProc(params=[ident("SpreadSheet")], body=s)
      of "SPREADSHEET":
        sheet = newProc(params=[ident("SpreadSheet")], body=s)
      of "FROM_PROC":
        sheet = s
      of "ALLOWEDIT":
        restricEdits = s
      of "ACCEPTIF":
          confirmRequirement = newProc(params=[ident("bool"), newIdentDefs(ident("COMMIT"), ident("SpreadSheet"))], body=s[1]) 
      of "ONACCEPT":
        applyChanges = newProc(params=[newEmptyNode(),newIdentDefs(ident("COMMIT"), ident("SpreadSheet"))], body=s[1])
  result = newCall("addFormToServer", sheet, name, confirmRequirement, applyChanges, errorMessage) # adds form to server
  if restricEdits.kind() == nnkEmpty: # Restric editing rights
    result.add(newCall("setNewPermissions", sheet, name, restricEdits))
   

macro ONSERVER * (statement : untyped) =
  ## Macro which indicates that all codeblocks inside
  ## should be executed on an online ODSL-server
  result = statement
  result.add(newCall("serveServer"))
  discard statement


export spreadsheets, server, googleapi, metaapi