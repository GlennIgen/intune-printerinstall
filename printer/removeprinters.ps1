$Success = $null
$oldPrinters = @(
    @{Name = "Printer 1" },
    @{Name = "Printer 2" },
    @{Name = "Printer 3" },
    @{Name = "Printer 4" }
)
$totalOldPrinters = $oldPrinters.Count
$removedPrintersCount = 0
foreach ($printer in $oldPrinters) {
    Write-Host $printer.Name
    if (Get-Printer -Name $printer.Name -ErrorAction SilentlyContinue) {
        try {
            Remove-Printer -Name $printer.Name -ErrorAction SilentlyContinue
            $Success = $true
            $removedPrintersCount++
        }
        catch {
            $Success = $false
        }
    }else {
        $Success = $false
    }
}

if ($Success -or ($removedPrintersCount -gt 0 -or $removedPrintersCount -eq $totalOldPrinters)) {
    exit 0
}
else {
    exit 1
}