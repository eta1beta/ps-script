# PowerShell script to list the DLL files under the system32 folder
$Dir = get-childitem P:\anno -recurse

# $Dir |get-member
$List = $Dir | where {$_.extension -eq ".MOV"}

$List | format-table name