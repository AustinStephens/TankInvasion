package code {
	
	import flash.display.MovieClip;
	
	
	public class WallHorizontal extends GameObject {
		
		public function WallHorizontal(newx: Number, newy: Number) {
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
