package code {
	
	import flash.display.MovieClip;
	
	
	public class HealthPack extends GameObject {
		
		
		public function HealthPack(newx: Number, newy: Number) {
			x = newx;
			y = newy;
			super();
		}
		
		/** Heals the player on collision with it. */
		override public function onCollision(otherObj: GameObject): void 
		{
			if(otherObj is Player)
			{
				otherObj.loseHealth(-50);
				isDead = true;
			}
		}
	}
	
}
