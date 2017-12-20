package code {
	
	import flash.display.MovieClip;
	
	
	public class DoorHorizontal extends GameObject {
		
		public function DoorHorizontal(newx: Number = 0, newy: Number = 0) {
			gotoAndStop(1);
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
