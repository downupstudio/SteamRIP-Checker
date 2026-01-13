$gamesListUrl = "https://steamrip.com/games-list-page/"
$baseUrl = "https://steamrip.com"

Write-Host "SteamRIP Game Checker" -ForegroundColor Cyan
Write-Host "Type a game name to search or type 'exit' to quit" -ForegroundColor Gray
Write-Host "--------------------------------------------------" -ForegroundColor Gray

try {
    Write-Host "`nDownloading the latest SteamRIP game list..." -ForegroundColor Cyan
    $htmlContent = (Invoke-WebRequest -Uri $gamesListUrl -UseBasicParsing).Content

    $gameDictionary = @{}
    $exactShortTitles = @()
    $exceptions = @("wwe", "nba")

    $pattern = '<a[^>]+href="([^"]+)"[^>]*>([^<]+Free Download[^<]*)</a>'
    $allMatches = [regex]::Matches($htmlContent, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    foreach ($match in $allMatches) {
        $linkUrl = $match.Groups[1].Value
        $fullTitle = $match.Groups[2].Value

        $fullTitle = [System.Net.WebUtility]::HtmlDecode($fullTitle)
        $fullTitle = $fullTitle -replace '\u2013', '-'

        $cleanTitle = $fullTitle -replace '\s*Free Download\s*', ''
        
        $cleanTitle = $cleanTitle -replace '\s*\([^)]+\)\s*', ''
        $cleanTitle = $cleanTitle -replace '\s*\[[^\]]+\]\s*', ''
        
        $cleanTitle = $cleanTitle.Trim()

        if ($cleanTitle.Length -ge 1 -and $cleanTitle.Length -le 3) {
            $exactShortTitles += $cleanTitle.ToLower()
        }

        if (-not $linkUrl.StartsWith("http")) {
            $linkUrl = $baseUrl + $linkUrl
        }

        $gameDictionary[$cleanTitle.ToLower()] = @{
            OriginalTitle = $cleanTitle
            Url = $linkUrl
        }
    }

    Write-Host "Ready! Loaded $($gameDictionary.Count) games.`n" -ForegroundColor Green

    while ($true) {
        $userInput = Read-Host "Enter game name"

        if ($userInput -eq "exit") {
            Write-Host "Exiting SteamRIP Game Checker. Goodbye!" -ForegroundColor Yellow
            break
        }

        if ([string]::IsNullOrWhiteSpace($userInput)) {
            Write-Host "Please enter a game name.`n" -ForegroundColor Yellow
            continue
        }

        $cleanInput = $userInput.Trim().ToLower()

        if ($cleanInput -eq "nba") {
            $cleanInput = "nba 2k"
        }

        if ($cleanInput.Length -le 3 -and $exceptions -notcontains $userInput.ToLower()) {
            $isExactShortTitle = $false
            foreach ($shortTitle in $exactShortTitles) {
                if ($shortTitle -eq $cleanInput) {
                    $isExactShortTitle = $true
                    break
                }
            }

            if (-not $isExactShortTitle) {
                Write-Host "`nSearch term '$userInput' is too short (1-3 letters)." -ForegroundColor Red
                Write-Host "You can only search with 1-3 letters if it EXACTLY matches a game title." -ForegroundColor Yellow
                Write-Host "Try a longer search term (4+ letters).`n" -ForegroundColor Gray
                continue
            }
        }

        $foundGames = @()

        foreach ($gameKey in $gameDictionary.Keys) {
            if ($gameKey.StartsWith($cleanInput)) {
                $foundGames += $gameDictionary[$gameKey]
            }
        }

        if ($foundGames.Count -gt 0) {
            Write-Host "`nFound $($foundGames.Count) match(es):" -ForegroundColor Green

            foreach ($game in $foundGames) {
                Write-Host " - $($game.OriginalTitle)" -ForegroundColor Yellow
                Write-Host "   $($game.Url)" -ForegroundColor White
            }

            Write-Host ""
        } else {
            Write-Host "`nNo matches found for: $userInput" -ForegroundColor Red
            Write-Host "Try different spelling or check the full list at: $gamesListUrl`n" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "`nERROR: Failed to retrieve data. Check internet connection." -ForegroundColor Red
}