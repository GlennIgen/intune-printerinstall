# Intune Printer Deployment (CSV-Based)

This repository provides PowerShell scripts and CSV files for deploying **printer drivers** and **IP-based printers** via Microsoft Intune.  
The scripts automate driver installation, printer setup, and support multiple devices without manual configuration.

---

## 📁 Repository Structure

| File / Folder          | Description |
|------------------------|-------------|
| `driverInstall.ps1`    | Installs printer drivers based on `drivers.csv`. |
| `printerInstallIP.ps1` | Installs printers (name, port, IP, driver) based on `printers.csv`. |
| `drivers.csv`          | List of printer drivers to install. |
| `printers.csv`         | List of printers to deploy. |
| `drivers/`             | Folder containing printer driver `.inf` files and supporting files. |

---

## ⚙️ How It Works

### 1. Driver Installation  
`driverInstall.ps1`:
- Reads driver entries from `drivers.csv`
- Installs drivers using the `.inf` file
- Performs validation and error handling

### 2. Printer Installation  
`printerInstallIP.ps1`:
- Reads printer entries from `printers.csv`
- Creates the printerport if missing
- Installs the printer using the specified driver
- Skips printers where the printerport cannot be created

---

## 🧪 CSV Formats

### `drivers.csv`
| DriverName | InfFile |
|------------|---------|
| HP Universal Printing PCL 6 | hpcu123.inf |

### `printers.csv`
| PrinterName | PrinterPort | PrinterIP | DriverName |
|-------------|-------------|-----------|------------|
| HP-Office-1 | HP-Office-1 | 10.0.0.50 | HP Universal Printing PCL 6 |

---

## 📦 Deploying via Microsoft Intune

### 🔹 1. Create Two Win32 Apps

#### App 1 — Driver Installation  
Include:
```
driverInstall.ps1
drivers/
drivers.csv
```

#### App 2 — Printer Installation  
Include:
```
printerInstallIP.ps1
printers.csv
```

Set **App 2 → Depends on → App 1**.

---

### 🔹 2. Install Commands

Driver app:
```powershell
powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File .\driverInstall.ps1 "-CsvPath .\drivers.csv"
```

Sysnative path
```powershell
C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File .\driverInstall.ps1 "-CsvPath .\drivers.csv"
```
Printer app:
```powershell
powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File .\printerInstallIP.ps1 "-CsvPath .\printers.csv"
```
Sysnative path:
```powershell
C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File .\printerInstallIP.ps1 "-CsvPath .\printers.csv"
```

---

## 🔍 Detection Rules

### ✔ Driver Detection  
Driver presence can be validated using registry paths under:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers
```

#### Version-3 driver example:
```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-3\HP Universal Printing PCL 6
```

#### Version-4 driver example:
```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-4\HP Universal Printing PCL 6
```

Each installed driver will appear as a key named after the driver's display name.

---

### ✔ Printer Detection (IP-based)

To detect an installed IP printer, check:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\<PrinterName>
```

Example:
```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\HP-Office-1
```

If the key exists, the printer is installed.

---

## 📝 Requirements
- Windows 10/11  
- Local admin rights during installation (installed as a System Package)
- Packaged as Win32 apps using Microsoft Win32 Content Prep Tool  

---

## 📄 License
MIT License
