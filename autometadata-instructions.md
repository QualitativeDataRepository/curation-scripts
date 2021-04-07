## AutoMetadata download instructions 


1. Go to https://www.evermap.com/download/AutoMetadata/publish.htm
2. Install prerequisites if needed
3. Launch application


## Instructions for large applications

For a basic functionality overview, click here. Most operations can be done via the GUI interface. However, this becomes tedious for large amounts of files (>50). In those cases, follow the instructions below:

1. Click File>Export Metada Records To Text File…
2. Save the file as a tab-delimited text file in .txt
3. Open Excel and open the file from there
4. Edit the file in Excel
    1. Note that there are five columns. The second column, for the “Title” field, is the one you want to edit (technically you can edit the other ones in Excel as well, but it’s redundant since those fields are identical across files and can be bulk edited in AutoMetadata).
    2. The easiest way to do this is to get a list of all filenames from the folder in which the files are stored. To do this: 
        1. Shift+RightClick on an empty space below or to the right of the file list
        2.  Click “Open PowerShell window here”
        3. Copy/Paste: Get-ChildItem -Name
        4. Copy the list of filenames
    3.  Paste the filenames into the second column and make sure they correspond to the right file paths (listed in the first column). They should, but good to double-check.
    4. Next, you will have to add quotation marks around all values in each cell (this is so the imported .txt file matches the exported .txt file for AutoMetadata)
        1. In the sixth column, copy/paste: =CHAR(34) & A1 & CHAR(34)
        2. Drag the cell across the entire value area (i.e. covering five columns to the right and however many rows down as there are files)
    5. Copy the cells with quotation marks into a new Excel file and save as a tab-delimited text file
6. Open the edited file in either Notepad++ or Notepad
7. You will notice that the fields will have three quotation marks around them. There should only be one, e.g. “QDR Data Project” instead of “““QDR Data Project”””. Type Ctrl+H, find all “““ and replace all with “. Save the text file.
8. Re-Open AutoMetadata, click “Clear File List” if the file list is still there (it won’t work otherwise), click File>Import Metada Records from Text File… You should now see all metadata records edited as desired. 
9. Click “Save Changes” and double-check a file in acrobat (File>Properties) to verify.
