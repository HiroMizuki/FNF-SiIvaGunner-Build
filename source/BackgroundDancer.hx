package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class BackgroundDancer extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		switch (Paths.formatToSongPath(PlayState.SONG.song))
		{
			case 'satin-panties-(in-game-version)':
				frames = Paths.getSparrowAtlas("limo/christmas/limoDancer");
			case 'high-(in-game-version)':
				frames = Paths.getSparrowAtlas("limo/vitas/limoDancer");
			case 'milf-(jp-version)':
				frames = Paths.getSparrowAtlas("limo/neko/limoDancer");
			default:
				frames = Paths.getSparrowAtlas("limo/limoDancer");
		}

		animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.play('danceLeft');
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	var danceDir:Bool = false;

	public function dance():Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
