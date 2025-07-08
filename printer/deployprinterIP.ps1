# Deploy printers over IP (useful when cloudonly solution)
# Set name of printer, IP, Driver and Printer Port name below
$printers = @(
    @{ Name = "Printer 1";     IP = "192.168.0.10";  Driver = "Printer Driver 1"; PortName = "port_printer_Printer1" },
    @{ Name = "Printer 2";     IP = "192.168.0.11";  Driver = "Printer Driver 2"; PortName = "port_printer_Printer2" }
)
$printersOK = $null
$printerPortsOK = $null
# Install Printer port
foreach ($printer in $printers) {
    if (-not (Get-PrinterPort -Name $printer.PortName -ErrorAction SilentlyContinue)) {
        try {
            Add-PrinterPort -Name $printer.PortName -PrinterHostAddress $printer.IP
            $printerPortsOK = $true
        } catch {
            Write-Host "Error installing printer port: $($printer.PortName)"
            $printerPortsOK = $false
        }
    }

# Add printe with; name, driver and port name
    $existingPrinter = Get-Printer -Name $printer.Name -ErrorAction SilentlyContinue
    if (-not $existingPrinter -or $existingPrinter.PortName -ne $printer.PortName) {
        try {
        if($existingPrinter){
            Remove-Printer -Name $printer.Name -ErrorAction SilentlyContinue
        }
            Add-Printer -Name $printer.Name -DriverName $printer.Driver -PortName $printer.PortName
            $printersOK = $true
        } catch {
            Write-Host "Error adding printer: $($printer.Name)"
            $printersOK = $false
        }
    }else{
        Write-Host "Printer, and printer port already installed."
        $printersOK = $true
    }
}
# Completion status
if ($printersOK -and $printerPortsOK) {
    exit 0
} else {
    exit 1
}
