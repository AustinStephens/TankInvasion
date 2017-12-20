package code {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import fl.motion.easing.Back;
	import code.GameScenes.GameScenePlay;
	
	public class Camera extends MovieClip{

		/** Player variable, what the camera follows. */
		private var target: Player;
		
		/** How far the player can go in any direction before the camera beings to move. */
		private const LIMIT: Number = 200;
		/** Slows down the camera as it follows the player to make a slide effect. */
		private const MULT: Number = .20;
		/** Size of the rooom. */
		private const ROOM_SIZE: Number = 1600;
		
		/** Vector (to be specific on the type, not sure if it is really more efficient) holding all GameObjects in the scene. */
		public var gameScene: Vector.<GameObject> = new Vector.<GameObject>();
		/** Seperate vector to hold particles, so they dont have to check if they collide with anything. */
		private var particles: Vector.<Particle> = new Vector.<Particle>();
		
		/** Rooms in the scene. */
		private var rooms: Array = new Array();
		/** Doors are label 0-3, 0 being the left door and going clockwise. This array holds the adjecent door index of a door at the index. 0 = left, adjecent would be 2. */
		private var oppositeDoor: Array = new Array(2,3,0,1);
		/** Makes sure we don't spawn more than one room at a time. */
		private var alreadySpawned: Boolean = false;
		/** Index of the new room's door that is missing. */
		private var indexOfDoor: int;
		/** If there is more than one room at the time. */
		private var isSecondRoom: Boolean = false;
		
		/** Counter to determine when we spawn a new room. */
		private var totalPortals: int = Room.totalPortals;
		
		/** Time between each portal being spawned. */
		private var portalTimer: Number = 5;
		/** Time between each portal being spawned. */
		private var portalTimerMax: Number = 10;
		/** Time between each healthpack being spawned. */
		private var hpTimer: Number = 20;
		/** The player's score. */
		public var score = 0;
		
		/** Sets up the scene and spawns portals. */
		public function Camera(player: Player) {
			target = player;
			rooms.push(new Room());
			rooms[0].x = rooms[0].y = 0;
			addChild(rooms[0]);
			
			
			gameScene.push(target);
			for(var i: int = 0; i < Room.startingPortals; ++i)
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
			
			if(isSecondRoom)
			{
				switch(indexOfDoor) 
				{
					case 0:
						if(target.aabb.edgeL >= rooms[1].x - 700) onNewRoomEnter();
						break;
					case 1:
						if(target.aabb.edgeT >= rooms[1].y - 700) onNewRoomEnter();
						break;
					case 2:
						if(target.aabb.edgeR <= rooms[1].x + 700) onNewRoomEnter();
						break;
					case 3:
						if(target.aabb.edgeB <= rooms[1].y + 700) onNewRoomEnter();
						break;
				}
			}
		}
		
		/** Updates timers. */
		private function timers(): void
		{
			if(portalTimer > 0) portalTimer -= Game.deltaTime;
			else if (totalPortals > 0) {
				spawnPortal();
				portalTimer = 12;
			}
			else if (!alreadySpawned) {
				spawnNewRoom();
				alreadySpawned = true;
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
		private function spawnPortal(): void
		{
			var randx: Number = rooms[0].x + Math.random() * 1300 - 650;
			var randy: Number = rooms[0].y + Math.random() * 1300 - 650;
			
			var port: Portal = new Portal(randx, randy);
			
			gameScene.push(port);
			addChild(port);
			--totalPortals;
		}
		
		/** Spawns a healthpack at a random location. */
		private function spawnHealthPack(): void
		{
			var randx: Number = rooms[0].x + Math.random() * 1300 - 650;
			var randy: Number = rooms[0].y + Math.random() * 1300 - 650;
			
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
		
		/** Spawns room in a random direction. Increases game difficulty. */
		private function spawnNewRoom(): void // direction is 1-west, 2-north, 3-east, 4-south, 0 is for starting room;
		{
			GameScenePlay(parent).roomText.visible = true;
			var direction: int = int(Math.random() * 4);
			rooms[0].removeChild(rooms[0].doors[direction]);
			rooms[0].doors.removeAt(direction);
			
			rooms.push(new Room());
			
			switch (direction)
			{
				case 0:
					rooms[1].x = rooms[0].x - ROOM_SIZE;
					rooms[1].y = rooms[0].y;
					break;
				case 1:
					rooms[1].x = rooms[0].x;
					rooms[1].y = rooms[0].y - ROOM_SIZE;
					break;
				case 2:
					rooms[1].x = rooms[0].x + ROOM_SIZE;
					rooms[1].y = rooms[0].y;
					break;
				case 3:
					rooms[1].x = rooms[0].x;
					rooms[1].y = rooms[0].y + ROOM_SIZE;
					break;
			}
			addChild(rooms[1]);
			isSecondRoom = true;
			
			if(Math.random() > .5) ++Room.startingPortals;
			++Room.totalPortals;
			
			var rand: Number = Math.random();
			if(rand > .666) Enemy.enemyDamageScalar += .25;  // damage increase
			else if(rand > .333) EnemyBullet.enemySpeedScalar += .25; // bullet speed increase
			else if(Enemy.shootMax - .25 >= 1) Enemy.shootMax -= .25; // shoot speed increase
			 
			if(Math.random() > .5 && Portal.maxTimer - .3 >= 1) Portal.maxTimer -= .3; // time for portal to spawn enemies
			else if(portalTimerMax - 1 >= 3) portalTimerMax -= 1; // time for portals to spawn
			
			Player.pointsScalar *= 1.2;
			
			rooms[1].removeChild(rooms[1].doors[oppositeDoor[direction]]);
			rooms[1].doors.removeAt(oppositeDoor[direction]);
			indexOfDoor = oppositeDoor[direction];
			
			rooms[1].setBoxes();
		}
		
		/** When the player enters a new room. Respawns the door, spawns portals, and clears the gameScene. */
		private function onNewRoomEnter(): void
		{
			GameScenePlay(parent).roomText.visible = false;
			isSecondRoom = false;
			var door: GameObject;
			
			if(indexOfDoor % 2)
				door = new DoorHorizontal(0, (indexOfDoor == 1 ? -750 : 750));
			else
				door = new DoorVertical((indexOfDoor == 0 ? -750 : 750), 0);
			
			rooms[1].doors.insertAt(indexOfDoor, door);
			rooms[1].setBox(indexOfDoor);
			
			var i: int;
			for(i = gameScene.length - 1; i >= 0; --i)
			{
				if(!(gameScene[i] is Player)) removeChild(gameScene[i]);
				gameScene.pop();
			}
			// dont really need to do it for particles.
			gameScene.length = 0;
			gameScene.push(target);
			
			removeChild(rooms[0]);
			rooms.removeAt(0);
			
			totalPortals = Room.totalPortals;
			for(i = 0; i < Room.startingPortals; ++i)
			{
				spawnPortal();
			}
			alreadySpawned = false;
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
