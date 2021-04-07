'Converts a folder with .txt files to .doc files
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
