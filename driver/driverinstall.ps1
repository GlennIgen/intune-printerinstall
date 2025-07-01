# Use this to install driver before the printer(s)
# Driver data
$PrinterDriverName = "Driver Name 1"
$InfPath = Resolve-Path ".\DRIVER-INF-FILE.inf"

# Set default state for $driverInstalled
$driverInstalled = $null

# Check if driver is already installed
if (-not (Get-PrinterDriver -Name $PrinterDriverName -ErrorAction SilentlyContinue)) {
    Write-Output "Installing printer driver: $PrinterDriverName"
    try {
        pnputil /add-driver "$InfPath" /install
        Start-Sleep -Seconds 3
        Add-PrinterDriver -Name $PrinterDriverName
        Write-Output "Driver installation complete."
        $driverInstalled = $true
    } catch {
        Write-Output "ERROR: $($_.Exception.Message)"
        $driverInstalled = $false
    }
} else {
    Write-Output "Driver '$PrinterDriverName' already installed."
    $driverInstalled = $true
}

# Completion status
if ($driverInstalled) {
    exit 0
} else {
    exit 1
}
