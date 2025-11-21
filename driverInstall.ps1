param(
    [Parameter(Mandatory = $true)]
    [string]$CsvPath
)

# Import CSV
if (-not (Test-Path -Path $CsvPath)) {
    Write-Error "CSV file not found: $($CsvPath)"
    exit 1
}

$drivers = Import-Csv -Path $CsvPath -Delimiter ","
$requiredColumns = 'DriverName', 'InfFileDOTinf'
foreach ($col in $requiredColumns) {
    if (-not ($printers | Get-Member -Name $col -MemberType NoteProperty)) {
        Write-Error "CSV is missing required column: $($col)"
        exit 1
    }
}

$totalDrivers = $drivers.count
$InstalledDrivers = 0


foreach ($driver in $drivers) {
    $driverInstalled = $null

    $DriverName = $driver.DriverName
    $InfFileDOTinf = Resolve-Path -Path ".\drivers\$($driver.InfFileDOTinf)"

    # Check if driver is already installed
    if (-not (Get-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue)) {
        Write-Output "Installing printer driver: $($DriverName)"
        try {
            pnputil /add-driver "$InfFileDOTinf" /install
            Start-Sleep -Seconds 3
            Add-PrinterDriver -Name $DriverName
            Write-Output "Driver installation complete."
            $driverInstalled = $true
        }
        catch {
            Write-Output "ERROR: $($_.Exception.Message)"
            $driverInstalled = $false
        }
    }
    else {
        Write-Output "Driver '$($DriverName)' already installed."
        $driverInstalled = $true
    }
    if ($driverInstalled) {
        $InstalledDrivers++
    }    
}

# Completion status
if ($InstalledDrivers -eq $totalDrivers) {
    exit 0
}
else {
    exit 1
}
