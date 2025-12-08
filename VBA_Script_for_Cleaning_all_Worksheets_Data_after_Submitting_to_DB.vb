Sub ClearSheetsData()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim sheetName As Variant 
    Dim headerRow As Long
    Dim firstDataColumn As Long
    Dim lastDataColumn As Long

    
    Dim sheetsToProcess As Variant
    sheetsToProcess = Array("Arrets_Non_Planifier", "Arrets_Planifier", "Sacs_produit")

    If MsgBox("Do you want to clear data from all sheets?", vbYesNo + vbQuestion, "Confirm Clear") = vbNo Then Exit Sub

    On Error GoTo ClearErrorHandler

    For Each sheetName In sheetsToProcess
        Set ws = ThisWorkbook.Sheets(sheetName)

        ' --- Sheet-Specific Configuration for Clearing ---
        Select Case sheetName
            Case "Arrets_Non_Planifier"
                headerRow = 7
                firstDataColumn = 2  ' Column B
                lastDataColumn = 14  ' Column N

            Case "Arrets_Planifier"
                headerRow = 8
                firstDataColumn = 3  ' Column C
                lastDataColumn = 10  ' Column J

            Case "Sacs_produit"
                headerRow = 8
                firstDataColumn = 3  ' Column C
                lastDataColumn = 7   ' Column G

            
            Case "Donnees"
                headerRow = 1        
                firstDataColumn = 1  
                lastDataColumn = 10  

            Case Else
            
                MsgBox "Warning: Clear configuration missing for sheet '" & sheetName & "'. Skipping.", vbExclamation
                GoTo NextSheet ' Skip to the next iteration of the loop
        End Select
        ' --- End Sheet-Specific Configuration ---

        ' Find the last row with data dynamically based on the first data column
        lastRow = ws.Cells(ws.Rows.Count, firstDataColumn).End(xlUp).Row

        ' Clear contents from the row *after* the headers to the last row
        If lastRow > headerRow Then ' Only clear if there's data below the headers
            ws.Range(ws.Cells(headerRow + 1, firstDataColumn), ws.Cells(lastRow, lastDataColumn)).ClearContents
        End If

NextSheet:
    Next sheetName

    MsgBox "All specified sheets have been cleared successfully.", vbInformation
    Exit Sub

ClearErrorHandler:
    MsgBox "An error occurred while clearing sheets." & vbCrLf & vbCrLf & _
           "Error " & Err.Number & ": " & Err.Description, vbCritical
End Sub

