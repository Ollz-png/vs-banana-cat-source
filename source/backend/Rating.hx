package backend;

import backend.ClientPrefs;

class Rating
{
	public var name:String = '';
	public var image:String = '';
	public var hitWindow:Null<Float> = 0.0; //ms
	public var ratingMod:Float = 1;
	public var score:Int = 350;
	public var noteSplash:Bool = true;
	public var hits:Int = 0;

	public function new(name:String)
	{
		this.name = name;
		this.image = name;
		this.hitWindow = 0;

		var window:String = name + 'Window';
		try
		{
			this.hitWindow = Reflect.field(ClientPrefs.data, window);
		}
		catch(e) FlxG.log.error(e);
	}

	public static function loadDefault():Array<Rating>
	{
var ratingsData:Array<Rating> = [];
	// Add perfect rating first (highest)
	var perfectRating:Rating = new Rating('perfect');
	perfectRating.ratingMod = 1;     // Highest modifier
	perfectRating.score = 400;       // You can choose a score higher than 'sick'
	perfectRating.noteSplash = true; // Assuming perfect has a note splash effect
	ratingsData.push(perfectRating);

	// Now add sick rating
	var sickRating:Rating = new Rating('sick');
	sickRating.ratingMod = 0.85;
	sickRating.score = 350;
	sickRating.noteSplash = true;
	ratingsData.push(sickRating);

	// Then good
	var goodRating:Rating = new Rating('good');
	goodRating.ratingMod = 0.67;
	goodRating.score = 200;
	goodRating.noteSplash = false;
	ratingsData.push(goodRating);

	// Then bad
	var badRating:Rating = new Rating('bad');
	badRating.ratingMod = 0.34;
	badRating.score = 100;
	badRating.noteSplash = false;
	ratingsData.push(badRating);

	// Then shit
	var shitRating:Rating = new Rating('shit');
	shitRating.ratingMod = 0;
	shitRating.score = 50;
	shitRating.noteSplash = false;
	ratingsData.push(shitRating);
	
	return ratingsData;
	}
}
