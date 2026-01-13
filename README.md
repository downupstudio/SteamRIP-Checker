# SteamRIP Checker

## How to run
Run this command in your terminal.
```powershell
Invoke-Expression (Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/downupstudio/SteamRIP-Checker/refs/heads/main/steamripchecker.ps1").Content
```

## What the script does
- **Website Connection**: Establishes a secure connection to SteamRIP's games list
- **Data Collection**: Downloads and parses the complete game list from the website
- **Game Database**: Creates a searchable local database with game titles and URLs
- **User Interface**: Provides an interactive console interface for game searches
- **Search Functionality**: Allows real-time searching through thousands of game entries
- **Result Display**: Shows matching games with proper titles and direct links
- **Encoding Handling**: Processes special characters and HTML entities correctly

## Technical Features
- **Error Handling**: Includes try-catch blocks for connection failures
- **Memory Management**: Efficiently processes large datasets
- **User Experience**: Clean interface with color-coded messages
- **Search Algorithm**: Fast substring matching across all game titles
- **Exit Control**: Graceful shutdown with exit command support

## Requirements
- **Operating System**: Windows 10 or Windows 11
- **PowerShell Version**: PowerShell 5.1 or higher (Windows PowerShell)
- **.NET Framework**: .NET Framework 4.7.2 or later
- **Internet Connection**: Required for downloading the game list from SteamRIP

## Notes
- The script is respectful of the website's servers. The script makes only one initial request to load the game list.
- This script is for educational purposes only. Respect website terms of service and copyright laws.
- Some special characters in game titles may not display correctly depending on your console's font and encoding settings.
