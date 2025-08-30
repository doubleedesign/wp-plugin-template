function find_and_replace_plugin_name_pascal($path, $newval) {
	(Get-Content $path) -replace 'NewPlugin', $newval | Set-Content $path
}
function find_and_replace_plugin_name_snake($path, $newval) {
	(Get-Content $path) -replace 'new_plugin', $newval | Set-Content $path
}
function find_and_replace_plugin_name_kebab($path, $newval) {
	(Get-Content $path) -replace 'new-plugin', $newval | Set-Content $path
}

function to_pascal_case($str) {
	$Text = $str -Replace '[^0-9A-Z]', ' '
	(Get-Culture).TextInfo.ToTitleCase($Text) -Replace ' ', ''
}

function find_and_replace($path, $oldVal, $newVal) {
	try {
		$content = Get-Content -Path $path
		$updatedContent = $content -replace [regex]::Escape($oldVal), $newVal
		Set-Content -Path $path -Value $updatedContent -Force

		Write-Host "Successfully replaced '$oldVal' with '$newVal' in '$path'"
	}
	catch {
		Write-Error "An error occurred: $($_.Exception.Message)"
		exit(1)
	}
}

# Ask the user for the plugin slug
$kebab = Read-Host "Enter your plugin name in kebab-case (e.g., my-plugin)"
$kebab = $kebab.Trim()
# Make sure it's actually kebab case
if ($kebab -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
	Write-Host "Error: The plugin name must be in kebab-case (lowercase letters, numbers, and hyphens only)." -ForegroundColor Red
	exit 1
}

# Convert plugin slug to the various cases
$pascal = to_pascal_case($kebab)
$snake = $kebab -replace '-', '_'
$title = (Get-Culture).TextInfo.ToTitleCase($kebab) -Replace '-', ' '
# Output as a table
@{
	"Kebab-case (plugin slug)" = $kebab
	"PascalCase (for class namespace)" = $pascal
	"snake_case (global function suffixes)" = $snake
	"Title Case (display name)" = $title
} | Format-Table | Out-String | Write-Host

# Ask the user for their GitHub/Packagist username, display name, email, website, etc
# defaulting to mine and assuming they're the same (because it'll only or mostly be me using this)
$username = Read-Host "Enter your GitHub/Packagist username (default: doubleedesign)"
$userPascal = to_pascal_case($username)
if ([string]::IsNullOrWhiteSpace($username)) {
	$username = "doubleedesign"
	$userPascal = "Doubleedesign"
}
$userWpName = Read-Host "Enter your name for the author field in index.php (default: Double-E Design)"
if ([string]::IsNullOrWhiteSpace($userWpName)) {
	$userWpName = "Double-E Design"
}
$userComposerName = Read-Host "Enter your name for the author field in composer.json (default: Leesa Ward)"
if ([string]::IsNullOrWhiteSpace($userComposerName)) {
	$userComposerName = "Leesa Ward"
}
$userEmail = Read-Host "Enter your email for the plugin author (default: leesa@doubleedesign.com.au)"
if ([string]::IsNullOrWhiteSpace($userEmail)) {
	$userEmail = "leesa@doubleedesign.com.au"
}
$userWebsite = Read-Host "Enter your website URL for the author URI field in index.php (default: https://www.doubleedesign.com.au)"
if ([string]::IsNullOrWhiteSpace($userWebsite)) {
	$userWebsite = "https://www.doubleedesign.com.au"
}
$includeGitHubLink = Read-Host "Include assumed GitHub URL as the plugin URI in index.php? (y/n, default: y)"
$pluginUri = ""
if ([string]::IsNullOrWhiteSpace($includeGitHubLink) -or $includeGitHubLink -eq 'y' -or $includeGitHubLink -eq 'Y') {
	$pluginUri = "https://github.com/$username/$kebab"
}
Write-Host "Your details to be used are: " -ForegroundColor Green
@{
	"GitHub/Packagist Username" = $username
	"Namespace prefix" = $userPascal
	"Author name (composer.json)" = $userComposerName
	"Author email (composer.json)" = $userEmail
	"Plugin author (index.php)" = $userWpName
	"Author URI" = $userWebsite
	"Plugin URI" = $pluginUri
} | Format-Table | Out-String | Write-Host

## Ask the user for a plugin description
$description = Read-Host "Enter a short description for your plugin"
$description = $description.Trim()
Write-Host "Plugin description to be used: '$description'" -ForegroundColor Green

# Update values applicable in both index.php and composer.json
foreach ($file in @("index.php", "composer.json")) {
	$path = Get-Item $file
	$path = $path.FullName
	Write-Host "Updating plugin name and namespace in $path" -ForegroundColor Cyan
	find_and_replace $path 'Doubleedesign' $userPascal
	find_and_replace_plugin_name_pascal $path $pascal
	find_and_replace_plugin_name_snake $path $snake
	find_and_replace_plugin_name_kebab $path $kebab
}

# Stuff specific to index.php
$file = 'index.php'
$path = Get-Item $file
$path = $path.FullName
Write-Host "Updating plugin header in $path" -ForegroundColor Cyan
find_and_replace $path 'Plugin Name:' "Plugin Name: $title"
find_and_replace $path 'Description:' "Description: $description"
find_and_replace $path 'Author:' "Author: $userWpName"
find_and_replace $path 'Author URI:' "Author URI: $userWebsite"
find_and_replace $path 'Plugin URI:' "Plugin URI: $pluginUri"

# Stuff specific to composer.json
$file = 'composer.json'
$path = Get-Item $file
$path = $path.FullName
Write-Host "Updating Composer file: $path" -ForegroundColor Cyan
find_and_replace $path 'doubleedesign' $username
find_and_replace $path '"description": ""' "`"description`": `"$description`""
find_and_replace $path 'Leesa Ward' $userComposerName
find_and_replace $path 'leesa@doubleedesign.com.au' $userEmail

# Loop through all files in src/ and replace NewPlugin, new_plugin, and new-plugin
Get-ChildItem -Path src -Recurse -File | ForEach-Object {
	$path = $_.FullName
	Write-Host "Updating class names in $path" -ForegroundColor Cyan
	find_and_replace $path 'Doubleedesign' $userPascal
	find_and_replace_plugin_name_pascal $path $pascal
	find_and_replace_plugin_name_snake $path $snake
	find_and_replace_plugin_name_kebab $path $kebab
}

# Run Composer install
Write-Host "Installing composer dependencies" -ForegroundColor Cyan
composer install

Write-Host "New plugin setup complete." -ForegroundColor Green

