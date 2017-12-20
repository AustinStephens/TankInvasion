package code {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class SmallBullet extends Bullet {
		
		public function SmallBullet(player: Player) {
			super(1000, 25);
			angle(player);
		}
		
	}
	
}
