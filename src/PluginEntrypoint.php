<?php

namespace Doubleedesign\NewPlugin;

class PluginEntrypoint {

	private static string $version = '0.0.1';

	public function __construct() {
		// Instantiate plugin classes here
	}

	public static function get_version(): string {
		return self::$version;
	}

	public static function activate() {
		// Activation logic here
	}

	public static function deactivate() {
		// Deactivation logic here
	}

	public static function uninstall() {
		// Uninstallation logic here
	}
}
