$ErrorActionPreference = "Stop"

#Set name of printer, IP, Driver and Printer Port name below
$printers = @(
    @{ Name = "Printer 1";     IP = "192.168.0.10";  Driver = "Printer Driver 1"; PortName = "port_printer_Printer1" }
)

foreach ($printer in $printers) {
    if (-not (Get-PrinterPort -Name $printer.PortName -ErrorAction SilentlyContinue)) {
        try {
            Add-PrinterPort -Name $printer.PortName -PrinterHostAddress $printer.IP -ErrorAction Stop
        } catch {
            continue
        }
    }

    if (-not (Get-Printer -Name $printer.Name -ErrorAction SilentlyContinue)) {
        try {
            Add-Printer -Name $printer.Name -DriverName $printer.Driver -PortName $printer.PortName -ErrorAction Stop
        } catch {
            continue
        }
    }
}
