package code {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import code.Sounds.Pew;
	import flash.media.SoundTransform;
	
	
	public class SmallBullet extends Bullet {
		
		public function SmallBullet(player: Player) {
			super(1000, 25);
			angle(player);
			var pew: Pew = new Pew();
			pew.play(0, 0, new SoundTransform(.15));
		}
		
	}
	
}
