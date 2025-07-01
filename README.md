# Intune Printer Install

This repository is used to deploy printer drivers and shared printers via Microsoft Intune.

## Structure

- `driver/` – Place all printer driver files here, including the `.inf` and all related `.dll/.cat/.cab` files. This folder also contains the `driverinstall.ps1` script used to install the driver.
- `printer/` – Contains scripts to add printers using either IP-based setup or shared print server connections.

## How to Use

### 1. Add Driver Files

Place your extracted printer driver package (including `.inf`, `.cat`, `.dll`, etc.) inside the `driver/` folder.  
Example contents:
```
driver/
├── driverinstall.ps1
├── KOAWQJA.inf
├── KOAWQJA.cat
├── koawqja.dll
└── ...
```

### 2. Package and Deploy via Intune

1. Use the [Microsoft Win32 Content Prep Tool](https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool) to package the `driver/` folder into a `.intunewin` file.
2. In the Intune portal:
   - Upload the `.intunewin` file.
   - **Install command:**
     ```powershell
     C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File .\driverinstall.ps1
     ```
   - Define detection logic as needed (e.g., check for installed printer driver).



### 3. Deploy Printers (Optional)

To deploy shared or IP-based printers, see the scripts in the `printer/` folder. These can be packaged and assigned separately in Intune.

## Example Scripts

- `driverinstall.ps1` – Installs a specific printer driver using `pnputil` and `Add-PrinterDriver`.
- `deployprinterIP.ps1` – Adds printers using IP and port.
- `deployprinterShared.ps1` – Adds printers using a shared UNC path (e.g., `\\server\printer`).

---

## License

MIT License
