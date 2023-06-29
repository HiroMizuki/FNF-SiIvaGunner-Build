package options;

#if DISCORD_ALLOWED
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class MusicSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Music Settings';
		rpcTitle = 'Music Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		var option:Option = new Option('Lunchbox:',
			'Changes the dialogue tune for Senpai.\nPress ENTER to preview.',
			'lunchbox',
			'string',
			'Ripped',
			['Original', 'Ripped', 'In-Game Version']);
		addOption(option);

		super();
	}

	override function update(elapsed:Float) {
		var shit = 'lunchbox-' + ClientPrefs.lunchbox.toLowerCase().replace(' ', '-');

		if (curSelected == 1) {
			PlayState.SONG = Song.loadFromJson(shit, shit);

			if(FlxG.keys.justPressed.ENTER) {
				LoadingState.loadAndSwitchState(new PlayState());
				PlayState.seenCutscene = false;
			}
		}

		super.update(elapsed);
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}
}