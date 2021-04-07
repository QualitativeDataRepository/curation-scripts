'Converts a folder with .txt files to .doc files
'From https://social.technet.microsoft.com/Forums/office/en-US/32cb406f-36f7-4570-8a8f-860611e34da0/how-can-i-batch-convert-txt-to-docx-or-doc-files-?forum=word
'Copyright © Paul Edstein; reproduced under fair use
'Run using F5, then select folder. .doc files appear in the same folder

Sub ConvertFiles()
Application.ScreenUpdating = False
Dim strFolder As String, strFile As String, wdDoc As Document
strFolder = GetFolder
If strFolder = "" Then Exit Sub
strFile = Dir(strFolder & "\*.txt", vbNormal)
While strFile <> ""
  Set wdDoc = Documents.Open(FileName:=strFolder & "\" & strFile, _
    Format:=wdOpenFormatEncodedText, Encoding:=msoEncodingUTF8, _
    AddToRecentFiles:=False, Visible:=False)
  wdDoc.SaveAs2 FileName:=strFolder & "\" & Replace(strFile, ".txt", ""), _
    Fileformat:=wdFormatDocument, AddToRecentFiles:=False
  wdDoc.Close SaveChanges:=False
  strFile = Dir()
Wend
Set wdDoc = Nothing
Application.ScreenUpdating = True
End Sub

Function GetFolder() As String
Dim oFolder As Object
GetFolder = ""
Set oFolder = CreateObject("Shell.Application").BrowseForFolder(0, "Choose a folder", 0)
If (Not oFolder Is Nothing) Then GetFolder = oFolder.Items.Item.Path
Set oFolder = Nothing
End Function
