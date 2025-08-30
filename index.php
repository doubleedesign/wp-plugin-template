<?php
/**
 * Plugin Name:
 * Description:
 * Requires PHP: 8.3
 * Author:
 * Plugin URI:
 * Author URI:
 * Version: 0.0.1
 * Text domain: new-plugin
 */

include __DIR__ . '/vendor/autoload.php';
use Doubleedesign\NewPlugin\PluginEntrypoint;

new PluginEntrypoint();

function activate_new_plugin(): void {
	PluginEntrypoint::activate();
}
function deactivate_new_plugin(): void {
	PluginEntrypoint::deactivate();
}
function uninstall_new_plugin(): void {
	PluginEntrypoint::uninstall();
}
register_activation_hook(__FILE__, 'activate_new_plugin');
register_deactivation_hook(__FILE__, 'deactivate_new_plugin');
register_uninstall_hook(__FILE__, 'uninstall_new_plugin');
