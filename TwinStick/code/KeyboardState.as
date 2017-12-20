package code {
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	import flash.ui.Keyboard;
	
	public class KeyboardState {
		// TODO: track EVERY key on the keyboard...
		public static const KEY_SPACE: int = 32;
		public static const KEY_LEFT: int = 37;
		public static const KEY_RIGHT: int = 39;
		public static const KEY_UP: int = 38;
		public static const KEY_DOWN: int = 40;
		
		public static const KEY_W: int = 87;
		public static const KEY_A: int = 65;
		public static const KEY_S: int = 83;
		public static const KEY_D: int = 68;
		
		private static var usedKeys: Array = new Array(KEY_SPACE, KEY_LEFT, KEY_RIGHT, KEY_DOWN, KEY_D, KEY_S, KEY_W, KEY_A);

		/** A booleam tp track the current state for each key */
		private static var keyStates: Array = new Array();
		/** A boolean to track the previous state of each key on the keyboard */
		private static var keyStatesPrev: Array = new Array();
		
		public static function setup(stage:Stage): void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			initialize(usedKeys);
		}
		
		public static function isKeyDown(keyCode: int): Boolean
		{
			if(keyCode < 0) return false;
			if(keyCode >= keyStates.length) return true;
			
			return keyStates[keyCode];
		}
		
		public static function onKeyDown(keyCode: int): Boolean 
		{
			if(keyCode < 0) return false;
			if(keyCode >= keyStates.length) return true;
			if(keyStates[keyCode] == null) return false;
			
			return (keyStates[keyCode] && !keyStatesPrev[keyCode]);
		}
		
		public static function update():void {
			
			for(var i: int = 0; i < keyStates.length; i++)
			{
				keyStatesPrev[i] = keyStates[i];
			}
		}
		
		private static function changeKey(keyCode:uint, isDown:Boolean):void {
			keyStates[keyCode] = isDown;
		}
		
		private static function handleKeyDown(e:KeyboardEvent):void {
			changeKey(e.keyCode, true);
		}
		
		private static function handleKeyUp(e:KeyboardEvent):void {
			changeKey(e.keyCode, false);
		}
		
		/** Using this because I can't find another way to initialize the entire array to something. */
		private static function initialize(keys: Array): void
		{
			for(var i: int = 0; i < keys.length; i++)
			{
				keyStates[keys[i]] = false;
				keyStatesPrev[keys[i]] = false;
			}
			
		}

	}
	
}
