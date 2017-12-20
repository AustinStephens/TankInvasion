package code {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import code.Sounds.Shot;
	
	
	public class LargeBullet extends Bullet {
		
		/** Any objects within this radius (in pixels) will be damaged. */
		private const BLAST_RADIUS: Number = 150;
		/** If the smoke particle hasn't been spawned already. */
		private var noSmoke: Boolean = true;
		
		public function LargeBullet(player: Player) {
			super(1200, 100);
			angle(player);
			var shot: Shot = new Shot();
			shot.play();
		}
		
		/** If it's not the player or a healthpack, and it isn't already dead, then damage the object by 200, and everything else by 50, also spawns smoke particle. */
		override public function onCollision(otherObj: GameObject): void
		{
			if(!(otherObj is Player) && !(otherObj is HealthPack) && !isDead) // added !isDead because of same reason as noSmoke
			{
				isDead = true;
				otherObj.loseHealth(damage); // walls wont do anything when this is called
				if(noSmoke) // added this because the smoke would spawn twice if it collided with 2 items in the same frame;
				{
					Camera(parent).spawnParticle(new ParticleSmoke(x,y));
					noSmoke = false;
				}
				
				for(var i: int = 0; i < Camera(parent).gameScene.length; ++i)  // damages everything in a 100 pixel radius by 50
				{
					if(Camera(parent).gameScene[i] is Player) continue;

					var distance: Number = Math.sqrt(Math.pow(Camera(parent).gameScene[i].x - x, 2) + Math.pow(Camera(parent).gameScene[i].y - y, 2));
					if(distance < (Camera(parent).gameScene[i].width / 2) + BLAST_RADIUS) // just used width for this, i don't have radial collision here.
						Camera(parent).gameScene[i].loseHealth(50);
				}
			}
		}
	}
	
}
