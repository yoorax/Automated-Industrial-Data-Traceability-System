' --- Configuration ---
Const SQL_SERVER_NAME As String = "DESKTOP-48KG94C\TEW_SQLEXPRESS"
Const DATABASE_NAME As String = "LigneEnsacheuse"

' --- Function to get a database connection ---
Function GetDbConnection() As ADODB.Connection
    Dim conn As New ADODB.Connection
    Dim connectionString As String

    ' Using Integrated Security (Windows Authentication)
    connectionString = "Provider=SQLOLEDB;" & _
                       "Server=" & SQL_SERVER_NAME & ";" & _
                       "Database=" & DATABASE_NAME & ";" & _
                       "Integrated Security=SSPI;"

    On Error GoTo ErrorHandler
    conn.Open connectionString
    Set GetDbConnection = conn
    Exit Function

ErrorHandler:
    MsgBox "Failed to connect to the database." & vbCrLf & _
           "Error " & Err.Number & ": " & Err.Description, vbCritical
    Set GetDbConnection = Nothing
End Function
Sub Data_Transfer_to_SQL_ANP()
    Dim ws As Worksheet
    Dim conn As ADODB.Connection
    Dim r As Long, lastRow As Long
    Dim headerRow As Long: headerRow = 7
    Dim firstDataColumn As Long: firstDataColumn = 2  ' Column B
    Dim lastDataColumn As Long: lastDataColumn = 14   ' Column N
    Dim sheetName As String
    Dim tableName As String
    Dim sSQL As String
    Dim cellValue As Variant
    Dim formattedVal(1 To 13) As String
    Dim i As Integer
    ' Set current worksheet
    Set ws = ActiveSheet
    sheetName = ws.Name
    
    ' Determine table based on sheet name
    Select Case sheetName
        Case "Arrets_Non_Planifier"
            tableName = sheetName
        Case Else
            MsgBox "Sheet not configured for data transfer."
            Exit Sub
    End Select
    
    ' Determine the last row by checking the first data column (B)
    lastRow = ws.Cells(ws.Rows.Count, firstDataColumn).End(xlUp).Row
    
    ' Open database connection using your provided GetDbConnection function
    Set conn = GetDbConnection()
    If conn Is Nothing Then Exit Sub
    
    Application.ScreenUpdating = False
    
    ' Loop through each data row (row 8 to lastRow)
    For r = headerRow + 1 To lastRow
        ' Begin constructing the SQL INSERT statement.
        sSQL = "INSERT INTO [" & tableName & "] " & _
               "([Cycle], [N_Arret], [Temps_Arret], [Ensemble_Defaillance], " & _
               "[Sous_Ensemble_Defaillance], [Composant_Defaillance], [Defaillence], " & _
               "[Commentaire], [Debut_Intervention], [Fin_Intervention], " & _
               "[Temps_Mise_en_Marche], [Duree_Intervention], [Duree_Arret]) VALUES ("
               
        ' --- Column Mapping and conversion ---
        ' Note: Excel stores dates/times as numeric values (fractions of a day).
        ' Use Format() to convert to a string format recognized by SQL Server.
        ' Mapping:
        ' Column B (2) -> Cycle (date)
        cellValue = ws.Cells(r, 2).Value
        If IsDate(cellValue) Then
            formattedVal(1) = "'" & Format(cellValue, "yyyy-mm-dd") & "'"
        ElseIf IsNumeric(cellValue) And cellValue <> "" Then
            formattedVal(1) = "'" & Format(cellValue, "yyyy-mm-dd") & "'"
        Else
            formattedVal(1) = "NULL"
        End If
        
        ' Column C (3) -> N_Arret (tinyint)
        cellValue = ws.Cells(r, 3).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(2) = "NULL"
        Else
            formattedVal(2) = cellValue
        End If
        
        ' Column D (4) -> Temps_Arret (time)
        cellValue = ws.Cells(r, 4).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(3) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(3) = "NULL"
        End If
        
        ' Column E (5) -> Ensemble_Defaillance (nvarchar(50))
        cellValue = ws.Cells(r, 5).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(4) = "NULL"
        Else
            formattedVal(4) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column F (6) -> Sous_Ensemble_Defaillance (nvarchar(50))
        cellValue = ws.Cells(r, 6).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(5) = "NULL"
        Else
            formattedVal(5) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column G (7) -> Composant_Defaillance (nvarchar(100))
        cellValue = ws.Cells(r, 7).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(6) = "NULL"
        Else
            formattedVal(6) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column H (8) -> Defaillance (nvarchar(50))
        cellValue = ws.Cells(r, 8).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(7) = "NULL"
        Else
            formattedVal(7) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column I (9) -> Commentaire (nvarchar(200))
        cellValue = ws.Cells(r, 9).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(8) = "NULL"
        Else
            formattedVal(8) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column J (10) -> Debut_Intervention (time)
        cellValue = ws.Cells(r, 10).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(9) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(9) = "NULL"
        End If
        
        ' Column K (11) -> Fin_Intervention (time)
        cellValue = ws.Cells(r, 11).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(10) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(10) = "NULL"
        End If
        
        ' Column L (12) -> Temps_Mise_en_Marche (time)
        cellValue = ws.Cells(r, 12).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(11) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(11) = "NULL"
        End If
        
        ' Column M (13) -> Duree_Intervention (time)
        cellValue = ws.Cells(r, 13).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(12) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(12) = "NULL"
        End If
        
        ' Column N (14) -> Duree_Arret (time)
        cellValue = ws.Cells(r, 14).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(13) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(13) = "NULL"
        End If
        
        ' Append all formatted values to the SQL statement
        For i = 1 To 13
            sSQL = sSQL & formattedVal(i)
            If i < 13 Then sSQL = sSQL & ", "
        Next i
        sSQL = sSQL & ")"
        
        ' Execute the SQL statement; if an error occurs, it will report the row number.
        On Error Resume Next
        conn.Execute sSQL
        If Err.Number <> 0 Then
            MsgBox "Error transferring row " & r & ":" & vbCrLf & Err.Description, vbExclamation
            Err.Clear
        End If
        On Error GoTo 0
    Next r
    
    conn.Close
    Set conn = Nothing
    Application.ScreenUpdating = True
    MsgBox "Data transfer complete."
End Sub

Sub Data_Transfer_to_SQL_AP()
    Dim ws As Worksheet
    Dim conn As ADODB.Connection
    Dim r As Long, lastRow As Long
    Dim headerRow As Long: headerRow = 8
    Dim firstDataColumn As Long: firstDataColumn = 3  ' Column C
    Dim lastDataColumn As Long: lastDataColumn = 10     ' Column J
    Dim sheetName As String
    Dim tableName As String
    Dim sSQL As String
    Dim cellValue As Variant
    Dim formattedVal(1 To 8) As String
    Dim i As Integer
    
    ' Set current worksheet
    Set ws = ActiveSheet
    sheetName = ws.Name
    
    ' Validate that we're on the correct sheet
    If sheetName <> "Arrets_Planifier" Then
        MsgBox "This macro is configured for the Arrets_Planifier sheet only."
        Exit Sub
    Else
        tableName = sheetName
    End If
    
    ' Determine the last row using the first data column
    lastRow = ws.Cells(ws.Rows.Count, firstDataColumn).End(xlUp).Row
    
    ' Open a database connection using your existing GetDbConnection function
    Set conn = GetDbConnection()
    If conn Is Nothing Then Exit Sub
    
    Application.ScreenUpdating = False
    
    ' Loop through each data row (starting right after the header row)
    For r = headerRow + 1 To lastRow
        sSQL = "INSERT INTO [" & tableName & "] " & _
               "([N_Arret_Planifier], [Cycle], [Debut_Arret_Planifier], [Fin_Arret_Planifier], " & _
               "[Categorie_Arret_Planifier], [Type_Arret_Planifier], [Commentaire], [Duree_Arret_Planifier]) VALUES ("
        
        ' --- Column Mapping and Conversion ---
        ' Column C (3): N_Arret_Planifier (tinyint)
        cellValue = ws.Cells(r, 3).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(1) = "NULL"
        Else
            formattedVal(1) = cellValue    ' Numeric values need no quotes
        End If
        
        ' Column D (4): Cycle (date)
        cellValue = ws.Cells(r, 4).Value
        If IsDate(cellValue) Then
            formattedVal(2) = "'" & Format(cellValue, "yyyy-mm-dd") & "'"
        ElseIf IsNumeric(cellValue) And cellValue <> "" Then
            formattedVal(2) = "'" & Format(cellValue, "yyyy-mm-dd") & "'"
        Else
            formattedVal(2) = "NULL"
        End If
        
        ' Column E (5): Debut_Arret_Planifier (time)
        cellValue = ws.Cells(r, 5).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(3) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(3) = "NULL"
        End If
        
        ' Column F (6): Fin_Arret_Planifier (time)
        cellValue = ws.Cells(r, 6).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(4) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(4) = "NULL"
        End If
        
        ' Column G (7): Categorie_Arret_Planifier (nvarchar(30))
        cellValue = ws.Cells(r, 7).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(5) = "NULL"
        Else
            formattedVal(5) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column H (8): Type_Arret_Planifier (nvarchar(50))
        cellValue = ws.Cells(r, 8).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(6) = "NULL"
        Else
            formattedVal(6) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column I (9): Commentaire (nvarchar(200))
        cellValue = ws.Cells(r, 9).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(7) = "NULL"
        Else
            formattedVal(7) = "'" & Replace(cellValue, "'", "''") & "'"
        End If
        
        ' Column J (10): Duree_Arret_Planifier (time)
        cellValue = ws.Cells(r, 10).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(8) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(8) = "NULL"
        End If
        
        ' Append all formatted values
        For i = 1 To 8
            sSQL = sSQL & formattedVal(i)
            If i < 8 Then
                sSQL = sSQL & ", "
            End If
        Next i
        
        sSQL = sSQL & ")"
        
        ' Execute SQL command and handle any errors per row.
        On Error Resume Next
        conn.Execute sSQL
        If Err.Number <> 0 Then
            MsgBox "Error transferring row " & r & ":" & vbCrLf & Err.Description, vbExclamation
            Err.Clear
        End If
        On Error GoTo 0
        
    Next r
    
    ' Clean up resources.
    conn.Close
    Set conn = Nothing
    Application.ScreenUpdating = True
    MsgBox "Data transfer complete."
End Sub
Sub Data_Transfer_to_SQL_SP()
    Dim ws As Worksheet
    Dim conn As ADODB.Connection
    Dim r As Long, lastRow As Long
    Dim headerRow As Long: headerRow = 8
    Dim firstDataColumn As Long: firstDataColumn = 3  ' Column C
    Dim lastDataColumn As Long: lastDataColumn = 7     ' Column G
    Dim sheetName As String
    Dim tableName As String
    Dim sSQL As String
    Dim cellValue As Variant
    Dim formattedVal(1 To 5) As String
    Dim i As Integer
    
    ' Set current worksheet
    Set ws = ActiveSheet
    sheetName = ws.Name
    
    ' Validate active sheet name
    If sheetName <> "Sacs_Produit" Then
        MsgBox "This macro is configured for the Sacs_produit sheet only."
        Exit Sub
    Else
        tableName = sheetName
    End If
    
    ' Determine the last row using the first data column (Column C)
    lastRow = ws.Cells(ws.Rows.Count, firstDataColumn).End(xlUp).Row
    
    ' Open a database connection using your existing GetDbConnection function
    Set conn = GetDbConnection()
    If conn Is Nothing Then Exit Sub
    
    Application.ScreenUpdating = False
    
    ' Loop through each data row (starting immediately after header row)
    For r = headerRow + 1 To lastRow
        sSQL = "INSERT INTO [" & tableName & "] " & _
               "([cycle], [N_Sacs_Total_Produit], [N_Sacs_Non_Conforme], [N_Palettes_Total_Produit], [N_Palettes_Non_Conforme]) VALUES ("
        
        ' --- Column C: cycle (date) ---
        cellValue = ws.Cells(r, 3).Value
        If IsDate(cellValue) Then
            formattedVal(1) = "'" & Format(cellValue, "yyyy-mm-dd") & "'"
        ElseIf IsNumeric(cellValue) And cellValue <> "" Then
            formattedVal(1) = "'" & Format(cellValue, "yyyy-mm-dd") & "'"
        Else
            formattedVal(1) = "NULL"
        End If
        
        ' --- Column D: N_Sacs_Total_Produit (smallint) ---
        cellValue = ws.Cells(r, 4).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(2) = "NULL"
        Else
            formattedVal(2) = cellValue
        End If
        
        ' --- Column E: N_Sacs_Non_Conforme (smallint) ---
        cellValue = ws.Cells(r, 5).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(3) = "NULL"
        Else
            formattedVal(3) = cellValue
        End If
        
        ' --- Column F: N_Palettes_Total_Produit (smallint) ---
        cellValue = ws.Cells(r, 6).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(4) = "NULL"
        Else
            formattedVal(4) = cellValue
        End If
        
        ' --- Column G: N_Palettes_Non_Conforme (smallint) ---
        cellValue = ws.Cells(r, 7).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(5) = "NULL"
        Else
            formattedVal(5) = cellValue
        End If
        
        ' Construct the full SQL INSERT statement by appending field values
        For i = 1 To 5
            sSQL = sSQL & formattedVal(i)
            If i < 5 Then
                sSQL = sSQL & ", "
            End If
        Next i
        sSQL = sSQL & ")"
        
        ' Execute the SQL statement with error handling per row
        On Error Resume Next
        conn.Execute sSQL
        If Err.Number <> 0 Then
            MsgBox "Error transferring row " & r & ":" & vbCrLf & Err.Description, vbExclamation
            Err.Clear
        End If
        On Error GoTo 0
    Next r
    
    ' Clean up resources.
    conn.Close
    Set conn = Nothing
    Application.ScreenUpdating = True
    MsgBox "Data transfer complete for Sacs_produit."
End Sub
Sub Data_Transfer_to_SQL_Arrets_Machine()
    Dim ws As Worksheet
    Dim conn As ADODB.Connection
    Dim r As Long, lastRow As Long
    Dim headerRow As Long: headerRow = 1
    Dim tableName As String, sSQL As String
    Dim cellValue As Variant
    Dim formattedVal(1 To 5) As String
    Dim i As Integer

    ' Set current worksheet
    Set ws = ActiveSheet
    ' Validate that the sheet name matches exactly as "Arrets_Machine"
    If ws.Name <> "Arrets_Machine" Then
        MsgBox "This macro is configured for the Arrets_Machine sheet only."
        Exit Sub
    Else
        tableName = ws.Name
    End If

    ' Determine the last row based on the first column (A)
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row

    ' Open database connection using your GetDbConnection function
    Set conn = GetDbConnection()
    If conn Is Nothing Then Exit Sub

    Application.ScreenUpdating = False

    ' Loop through each data row (starts at row 2)
    For r = headerRow + 1 To lastRow
        ' Start constructing the SQL INSERT statement
        sSQL = "INSERT INTO [" & tableName & "] " & _
               "([Cycle], [N_Arret], [Debut_Arret], [Fin_Arret], [Duree_Arret]) VALUES ("

        ' --- Column A: Cycle (date) ---
        cellValue = ws.Cells(r, 1).Value
        If IsDate(cellValue) Then
            formattedVal(1) = "'" & Format(cellValue, "yyyy-mm-dd") & "'"
        Else
            formattedVal(1) = "NULL"
        End If

        ' --- Column B: N_Arret (tinyint) ---
        cellValue = ws.Cells(r, 2).Value
        If Trim(cellValue & "") = "" Then
            formattedVal(2) = "NULL"
        Else
            formattedVal(2) = cellValue
        End If

        ' --- Column C: Debut_Arret (time(7)) ---
        cellValue = ws.Cells(r, 3).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(3) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(3) = "NULL"
        End If

        ' --- Column D: Fin_Arret (time(7)) ---
        cellValue = ws.Cells(r, 4).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(4) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(4) = "NULL"
        End If

        ' --- Column E: Duree_Arret (time(7)) ---
        cellValue = ws.Cells(r, 5).Value
        If IsDate(cellValue) Or (IsNumeric(cellValue) And cellValue <> "") Then
            formattedVal(5) = "'" & Format(cellValue, "HH:mm:ss") & "'"
        Else
            formattedVal(5) = "NULL"
        End If

        ' Append all formatted field values to the SQL string
        For i = 1 To 5
            sSQL = sSQL & formattedVal(i)
            If i < 5 Then sSQL = sSQL & ", "
        Next i
        sSQL = sSQL & ")"

        ' Execute the SQL statement; show an error message if needed.
        On Error Resume Next
        conn.Execute sSQL
        If Err.Number <> 0 Then
            MsgBox "Error transferring row " & r & ":" & vbCrLf & Err.Description, vbExclamation
            Err.Clear
        End If
        On Error GoTo 0
    Next r

    ' Clean up resources.
    conn.Close
    Set conn = Nothing
    Application.ScreenUpdating = True

    MsgBox "Data transfer complete for Arrets_Machine."
End Sub

