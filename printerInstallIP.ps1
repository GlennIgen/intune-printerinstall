param(
    [Parameter(Mandatory = $true)]
    [string]$CsvPath
)
# Import CSV
if (-not (Test-Path -Path $CsvPath)) {
    Write-Error "CSV file not found: $($CsvPath)"
    exit 1
}

$printers = Import-Csv -Path $CsvPath -Delimiter ","
$requiredColumns = 'PrinterIP', 'PrinterName', 'PrinterPort', 'Color', 'PrinterDriverName'
foreach ($col in $requiredColumns) {
    if (-not ($printers | Get-Member -Name $col -MemberType NoteProperty)) {
        Write-Error "CSV is missing required column: $($col)"
        exit 1
    }
}
$totalPrinters = $printers.count
$InstalledPrinters = 0

foreach ($printer in $printers) {
    $PrinterInstalled = $null
    $PrinterPortInstalled = $null

    $PrinterIP = $printer.PrinterIP
    $PrinterName = $printer.PrinterName
    $PrinterPort = $printer.PrinterPort
    $Color = [bool]$printer.Color
    $PrinterDriver = $printer.PrinterDriverName

    # Install Printer port
    if (-not (Get-PrinterPort -Name $PrinterPort -ErrorAction SilentlyContinue)) {
        try {
            Add-PrinterPort -Name $PrinterPort -PrinterHostAddress $PrinterIP -ErrorAction Stop
            $PrinterPortInstalled = $true
        }
        catch {
            Write-Error "Error installing printer port: $($PrinterPort)"
            $PrinterPortInstalled = $false
        }
    }
    else {
        Write-Output "Printer port already exists: $($PrinterPort)"
        $PrinterPortInstalled = $true
    }

    if (-not $PrinterPortInstalled) {
        Write-Error "Skipping printer '$PrinterName' because printer port '$PrinterPort' failed to install."
        continue
    }

    # Add printe with; name, driver and port name
    $CheckForExistingPrinter = Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue
    if (-not $CheckForExistingPrinter -or $CheckForExistingPrinter.PortName -ne $PrinterPort) {
        try {
            if ($CheckForExistingPrinter) {
                Remove-Printer -Name $PrinterName -ErrorAction Stop
            }
            Add-Printer -Name $PrinterName -DriverName $PrinterDriver -PortName $PrinterPort
            #Set Color true or false for printer
            Set-PrintConfiguration -PrinterName $PrinterName -Color $Color -ErrorAction SilentlyContinue
            $PrinterInstalled = $true
        }
        catch {
            Write-Error "Error adding printer: $($PrinterName)"
            $PrinterInstalled = $false
        }
    }
    else {
        Write-Output "Printer, and printer port already installed."
        $PrinterInstalled = $true
    }

    if ($PrinterPortInstalled -and $PrinterInstalled) {
        $InstalledPrinters++
    }
}
# Completion status
if ($InstalledPrinters -eq $totalPrinters) {
    exit 0
}
else {
    exit 1
}