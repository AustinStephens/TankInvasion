package code {
	
	import flash.display.MovieClip;
	
	
	public class WallVertical extends GameObject {
		
		public function WallVertical(newx: Number, newy: Number) {
			x = newx;
			y = newy;
			super();
		}
		
		/** Called every function, calls the move and check function. */
		override public function update(): void 
		{
		}
		
	}
	
}
