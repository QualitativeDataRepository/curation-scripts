'Converts XLS files to XLSX
'From http://codebyjoshua.blogspot.com/2013/03/convert-excel-xls-to-xlsx-and-xlsm.html
'Copyright 2013 Joshua the Lionhearted, reproduced under fair use 

Sub Copy_XLS_as_XLSX()

    Convert_XLS_to_XLSX False
  
End Sub

Sub Delete_XLS_after_Copy_XLS_as_XLSX()

    Convert_XLS_to_XLSX True
  
End Sub

Sub Convert_XLS_to_XLSX(ByVal deleteXLS As Boolean)
  
    ' Allow user to choose a folder,  where all .xls files in that folder will be converted to
    ' .xlsx or .xlsm format, depending on whether they have macros or not...
  
      
  
    Dim xDirect$, xFname$, InitialFoldr$
    Dim wbk As New Workbook
    Dim msg As Integer
  
  
  
    InitialFoldr$ = "c:\temp\"    'Startup folder to begin searching from
  
    If deleteXLS = True Then  'as user if they really want to delete .xls files
                  
        msg = MsgBox("Do you want to delete all .xls files after you have created a copy in .xlsx format? If you are not sure, click NO!", vbYesNo, "Ready to delete .xls files?")
  
    End If
  
    If msg = vbNo Then  'user doesn't want to delete files...
  
        deleteXLS = False
      
    End If
  
    With Application.FileDialog(msoFileDialogFolderPicker)
        .InitialFileName = Application.DefaultFilePath & "\"
        .Title = "Please select a folder containing the .xls files you want to convert..."
        .InitialFileName = InitialFoldr$
        .Show
        If .SelectedItems.Count <> 0 Then
            xDirect$ = .SelectedItems(1) & "\"
            xFname$ = Dir(xDirect$, 7)
          
            Do While xFname$ <> ""  'loop through all filenames in folder
          
                If Right(xFname$, 4) = ".xls" Then  'only convert .xls files
              
                    Application.DisplayAlerts = False  'turn off any unwanted messages
                  
                    Set wbk = Workbooks.Open(Filename:=xDirect$ & xFname$)
          
                    If wbk.HasVBProject Then  ' convert Excel files containing Macros
                      wbk.SaveAs Filename:=xDirect$ & xFname$ & "m", _
                        FileFormat:=xlOpenXMLWorkbookMacroEnabled
                      
                    Else  ' convert standard Excel files
                       wbk.SaveAs Filename:=xDirect$ & xFname$ & "x", _
                        FileFormat:=xlOpenXMLWorkbook
                    End If
                  
                    wbk.Close SaveChanges:=False
                  
                    If deleteXLS = True Then  'delete existing xls files if desired
                  
                        With New FileSystemObject 'include Excel reference to Microsoft Scripting.Runtime library... or this won't work...  Go to Tools>References in the VBA editing window
                      
                            If .FileExists(xDirect$ & xFname$) Then
                                .DeleteFile xDirect$ & xFname$
                            End If
                          
                        End With
                      
                    End If
                  
                    Application.DisplayAlerts = True  'turn messages back on
                  
                End If
              
                xFname$ = Dir  ' get next filename in folder
              
            Loop
          
        End If
      
    End With
  
    xRow = MsgBox("All .xls files have now been converted.", , "Finished!")
  
  
  
End Sub
