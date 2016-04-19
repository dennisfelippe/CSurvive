class Back
	def initialize(window)
		@window = window
		@back = Gosu::Image.load_tiles "imagen/bg.png",-1,-3
		@x = -300
		@a1 = 0
		@a11 = 0
		
	end

	def update(player,enemy,enemy2)
	if player.direction == :right and player.moving == true
		@x = @x -=1.55
		enemy.x -=1.55
		enemy2.x -=1.55
		elsif player.direction == :left and player.moving == true
		@x = @x +=1.55
		enemy.x += 1.55
		enemy2.x += 1.55
		end

		@a1 += 1
          if @a1 == 15
                @a11 += 1
                @a1 = 0
          end
	end

	def draw
	a = @a11 % @back.size
	@back[a].draw @x, 1, 1, 1.4,1.40
	end
end

