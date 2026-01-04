# WordPress/ClassicPress plugin template

This repo provides the boilerplate for a custom WordPress or ClassicPress plugin in the structure I like to use.

## Usage

1. Download as a zip file and extract it to where you want to work on your new plugin
2. Rename the folder to your plugin's name

> [!TIP]
> PowerShell users can automate steps 3-6 by running the `setup.ps1` script in the root of the extracted folder.

3. Search and replace all instances of `new-plugin`, `NewPlugin`, and `new_plugin` with your plugin's slug, class name, and function prefix respectively
4. Update the plugin header in `new-plugin.php` with your plugin and author information
5. Update `composer.json` with your plugin and author information
6. Update the namespace prefix from `Doubleedesign` to your own vendor name in `composer.json` and in the PHP files
7. Delete `setup.ps1`
8. Remove this template repo as the remote in Git (or just delete `.git` to start totally fresh)
9. Update README.md with details about your new plugin
10. Initialise and commit to your own Git repo.
