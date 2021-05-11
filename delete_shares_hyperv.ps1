$shares=net view . | select-string "[\w]{32}" -AllMatches
$shares | forEach-Object { net share $_.toString().split(" ")[0] /delete }