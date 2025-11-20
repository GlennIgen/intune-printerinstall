# Install printers from a print server (useful in hybrid solutions)
$printers = @(
    "\\server.domain.local\Printer 1",
    "\\server.domain.local\Printer 2"
)
$printersOK = $true
foreach ($printer in $printers) {
    if (-not (Get-Printer -Name $printer -ErrorAction SilentlyContinue)) {
        try {
            Add-Printer -ConnectionName $printer -ErrorAction SilentlyContinue
        } catch {
            Write-Host "Error installing printer: $printer"
            $printersOK = $false
        }
    } else {
        #Write-Host "Printer already installed: $printer"
    }
}

# Completion status
if ($printersOK) {
    exit 0
} else {
    exit 1
}
