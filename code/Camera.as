package code {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import fl.motion.easing.Back;
	
	public class Camera extends MovieClip{

		/** Player variable, what the camera follows. */
		public var target: Player;
		
		/** How far the player can go in any direction before the camera beings to move. */
		public const LIMIT: Number = 200;
		/** Slows down the camera as it follows the player to make a slide effect. */
		public const MULT: Number = .20;
		/** Size of the rooom. */
		public const ROOM_SIZE: Number = 1600;
		
		/** Vector (to be specific on the type, not sure if it is really more efficient) holding all GameObjects in the scene. */
		public var gameScene: Vector.<GameObject> = new Vector.<GameObject>();
		/** Seperate vector to hold particles, so they dont have to check if they collide with anything. */
		public var particles: Vector.<Particle> = new Vector.<Particle>();
		
		/** Rooms in the scene. */
		public var rooms: Array = new Array();
		/** Doors are label 0-3, 0 being the left door and going clockwise. This array holds the adjecent door index of a door at the index. 0 = left, adjecent would be 2. */
		private var oppositeDoor: Array = new Array(2,3,0,1);
		/** Makes sure we don't spawn more than one room at a time. */
		private var alreadySpawned: Boolean = false;
		
		/** Counter to determine when we spawn a new room. */
		public var totalPortals: int = 0;
		
		/** Time left before portal is spawned. */
		public var portalTimer: Number = 6;
		/** Time between each portal being spawned. */
		public var portalTimerMax: Number = 10;
		/** Time between each healthpack being spawned. */
		public var hpTimer: Number = 20;
		/** The player's score. */
		public var score: int = 0;
		
		/** Sets up the scene and spawns portals. */
		public function Camera(player: Player) {
			target = player;
			rooms.push(new Room());
			rooms[0].x = rooms[0].y = 0;
			addChild(rooms[0]);
			
			
			gameScene.push(target);
			for(var i: int = 0; i < 4; ++i)
			{
				spawnPortal();
			}
		
		}
		
		/** Called every frame. Moves the camera, updates everything, checks for collisions and if objects are "dead". */
		public function update(): void
		{
			var targetX: Number = 500 - target.x;
			var targetY: Number = 500 - target.y;
			
			if(targetX - x > LIMIT)
				x += (targetX - x - LIMIT) * MULT;
			else if(targetX - x < -LIMIT)
				x += (targetX - x + LIMIT) * MULT;
	
			if(targetY - y > LIMIT)
				y += (targetY - y - LIMIT) * MULT;
			else if(targetY - y < -LIMIT)
				y += (targetY - y + LIMIT) * MULT;
		
			updates();
			collisions();
			checkForDead();
			timers();
		}
		
		/** Updates timers. */
		private function timers(): void
		{
			if(portalTimer > 0) portalTimer -= Game.deltaTime;
			else {
				spawnPortal();
				portalTimer = portalTimerMax;
			}
			
			if(hpTimer > 0) hpTimer -= Game.deltaTime;
			else {
				spawnHealthPack();
				hpTimer = 20;
			}
		}
		
		/** Updates all objects in scene. */
		private function updates(): void
		{
			var i: int;
			// UPDATES & COLLISIONS FOR ROOMS ////////////////////////////////
			
			for(i = rooms.length - 1; i >= 0; --i)
			{
				rooms[i].update();
			}
			
			// UPDATES FOR REST ////////////////////////////////////////
			for(i = gameScene.length - 1; i >= 0; --i)
			{
				gameScene[i].update();
			}
			
			for(i = particles.length - 1; i >= 0; --i)
			{
				particles[i].update();
			}
		}
		
		/** Checks for collisions. */
		private function collisions(): void
		{
			for(var i: int = 0; i < gameScene.length - 1; ++i)
			{
				for(var j: int = i + 1; j < gameScene.length; ++j)
				{
					if(gameScene[i].aabb.checkOverlap(gameScene[j].aabb))
					{
						gameScene[i].onCollision(gameScene[j]);
						gameScene[j].onCollision(gameScene[i]);
					}
				}
			}
		}
		
		/** Checks for "dead" objects. */
		private function checkForDead(): void
		{
			for(var i: int = gameScene.length - 1; i >= 0; --i)
			{
				if(gameScene[i].isDead)
				{
					removeChild(gameScene[i]);
					gameScene.removeAt(i);
				}
			}
			
			for(i = particles.length - 1; i >= 0; --i)
			{
				if(particles[i].isDead)
				{
					removeChild(particles[i]);
					particles.removeAt(i);
				}
			}
			
		}
		
		/** Spawns a portal at a random location. */
		public function spawnPortal(): void
		{
			var randx: Number = rooms[0].x + Math.random() * 1300 - 650;
			var randy: Number = rooms[0].y + Math.random() * 1300 - 650;
			
			var port: Portal = new Portal(randx, randy);
			
			gameScene.push(port);
			addChild(port);
			++totalPortals;
			//trace("total: " + totalPortals);
			if(totalPortals > 5 && totalPortals % 2 == 0) // or !(totalPortals % 2)
			{
				var rand: Number = Math.random();
				if(rand < .333) Enemy.enemyDamageScalar += .2;  // damage increase
				else if (rand < .666) EnemyBullet.enemySpeedScalar += .2; // bullet speed increase
				else Enemy.shootMax -= .2; // shoot speed increase
				
				if(Math.random() > .5) Portal.maxTimer -= .15; // time for portal to spawn enemies
				else portalTimerMax -= .25; // time for portals to spawn
				
				Player.pointsScalar *= 1.05;
				
				/*trace("Player.points: " + Player.pointsScalar);
				trace("Portal.maxTimer: " + Portal.maxTimer);
				trace("portaltimermax: " + portalTimerMax);
				trace("Enemy.damagescalar: " + Enemy.enemyDamageScalar);
				trace("Enemy.shootMax: " + Enemy.shootMax);
				trace("EnemyBullet.speed: " + EnemyBullet.enemySpeedScalar);*/
			}
		}
		
		/** Spawns a healthpack at a random location. */
		public function spawnHealthPack(): void
		{
			var randx: Number = Math.random() * 1300 - 650;
			var randy: Number = Math.random() * 1300 - 650;
			
			var hp: HealthPack = new HealthPack(randx,randy);
			
			gameScene.push(hp);
			addChild(hp);
		}
		
		/** Spawns enemy at a given location. */
		public function spawnEnemy(newx: Number, newy: Number): void
		{
			var enemy: Enemy = new Enemy(target);
			enemy.x = newx;
			enemy.y = newy;
			
			gameScene.push(enemy);
			addChild(enemy);
		}

		/** Shoots a given bullet. */
		public function shootGun(bullet: Bullet): void
		{
			gameScene.push(bullet);
			addChildAt(bullet, 0);
		}
		
		/** Spawns a given particle. */
		public function spawnParticle(p: Particle): void
		{
			particles.push(p);
			addChild(p);
		}

	}
	
}
