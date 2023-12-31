package;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import haxe.Json;
import haxe.format.JsonParser;
import Song;

using StringTools;

typedef StageFile = {
	var directory:String;
	var defaultZoom:Float;
	var isPixelStage:Bool;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
	var hide_girlfriend:Bool;

	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
	var camera_speed:Null<Float>;
}

class StageData {
	public static var forceNextDirectory:String = null;
	public static function loadDirectory(SONG:SwagSong) {
		var stage:String = '';
		if(SONG.stage != null) {
			stage = SONG.stage;
		} else if(SONG.song != null) {
			switch (SONG.song.toLowerCase().replace(' ', '-'))
			{
				case 'bopeebo-(in-game-version)':
					stage = 'pigInAWig';
				case 'bopeebo-(newgrounds-build)':
					stage = 'angryBirds';
				case 'fresh-(itchio-build)':
					stage = 'bus';
				case 'fresh-(poop-version)':
					stage = 'palace';
				case 'spookeez' | 'spookeez-(beta-mix)' | 'south-(nice-mix)' | 'spookeez-(in-game-version)' | 'spookeez-(week-7-update)' | 'spookeez-(jpn-version)' | 'south' | 'south-(beta-mix)' | 'south-(in-game-version)' | 'monster' | 'monster-(in-game-version)':
					stage = 'spooky';
				case 'pico-(ost-version)' | 'blammed' | 'blammed-(week-4-update)' | 'blammed-(ost-version)' | 'blammed-(in-game-version)' | 'blammed-(extended-version)' | 'philly-nice' | 'philly-nice-(in-game-version)' | 'fresh-(ost-version)':
					stage = 'philly';
				case 'pico':
					stage = 'tyler';
				case 'pico-(in-game-version)':
					stage = 'louvre';
				case 'milf' | 'milf-(beta-mix)' | 'milf-(short-mix)' | 'milf-(in-game-version)' | 'milf-(jp-version)' | 'milf-(ost-version)' | 'milf-(itchio-build)' | 'satin-panties-(in-game-version)' | 'satin-panties-(short-version)' | 'satin-panties' | 'high' | 'high-(extended-mix)' | 'high-(in-game-version)' | 'high-(jp-version)' | 'ridge-(unused)':
					stage = 'limo';
				case 'cocoa' | 'cocoa-(short-version)' | 'eggnog' | 'eggnog-(short-version)':
					stage = 'mall';
				case 'winter-horrorland' | 'winter-horrorland-(short-version)':
					stage = 'mallEvil';
				case 'roses' | 'roses-(beta-mix)' | 'roses-(in-game-version)' | 'lunchbox-ripped' | 'lunchbox-original' | 'lunchbox-in-game-version' | 'roses-(itchio-build)':
					stage = 'school';
				case 'roses-(ost-version)':
					stage = 'bridge';
				case 'senpai':
					stage = 'beach';
				case 'senpai-(beta-mix)':
					stage = 'island';
				case 'senpai-(in-game-version)':
					stage = 'town';
				case 'thorns':
					stage = 'schoolEvil';
				case 'thorns-(beta-mix)':
					stage = 'earthboundEvil';
				case 'ugh-(alterneeyyytive-mix)' | 'ugh-(in-game-version)' | 'guns-(short-version)' | 'stress':
					stage = 'tank';
				case 'ugh':
					stage = 'homeDepot';
				case 'test':
					stage = 'wolves';
				case 'lo-fight':
					stage = 'alley';
				case 'wocky' | 'beathoven':
					stage = 'arcade';
				default:
					stage = 'stage';
			}
		} else {
			stage = 'stage';
		}

		var stageFile:StageFile = getStageFile(stage);
		if(stageFile == null) { //preventing crashes
			forceNextDirectory = '';
		} else {
			forceNextDirectory = stageFile.directory;
		}
	}

	public static function getStageFile(stage:String):StageFile {
		var rawJson:String = null;
		var path:String = Paths.getPreloadPath('stages/' + stage + '.json');

		#if MODS_ALLOWED
		var modPath:String = Paths.modFolders('stages/' + stage + '.json');
		if(FileSystem.exists(modPath)) {
			rawJson = File.getContent(modPath);
		} else if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(Assets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end
		else
		{
			return null;
		}
		return cast Json.parse(rawJson);
	}
}