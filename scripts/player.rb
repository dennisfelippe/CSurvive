class Player
	attr_reader :life, :x, :y, :hit, :direction, :moving
	attr_accessor :level, :exp, :life_x
    def initialize(window)
        @window = window
        @icon = Gosu::Image.load_tiles(@window, "imagen/player_stand.png",71,72,true)
        @x = window.width/2
        @y = window.height - 195
        #direção e movimento
        @direction = :right
        @move = Gosu::Image.load_tiles(@window, "imagen/player.png",-6,-1, true)
        @down = Gosu::Image.new(@window, "imagen/player_dead.png", true)
        @attack = Gosu::Image.load_tiles(@window, "imagen/player_at.png", 91,74,true)
        #definições para ataque
        @hit_sound = Gosu::Sample.new(@window, "audio/hit.wav")
        @hit = false
        @frame = 0
        @anima_stand = 0
        @moving = false
        @add = 0
        @a1 = 0
        @a11 = 0
        #Vida
        @life = 100
        @dead = false
        @t_attack = 0
        @life_up = Gosu::Image.load_tiles(@window, "imagen/life.png", 32, 28, true)
        @life_sound = Gosu::Sample.new(@window, "audio/up.wav")
        @lvlup = Gosu::Sample.new(@window, "audio/lvlup.wav")
        @life_x = rand(window.height)
        @life_grow = false
        @life_time = 0.0
        @level = 1
        @exp = 0
    end
#####--UPDATE----############################################################ 
    def update
        @a11 += 1
        if $estado == "JOGANDO" then
            if @exp >= 100
                @level += 1
                @exp = @exp - 100
                @life += (@life/rand(5..10)).to_i
                @lvlup.play
            end
            lifeup
            @life_time += 1.0/60
                if @life_time > 45
                    @life_grow = true
                    @life_time = 0
                end
            @moving = false
            @anima_stand += 1
            if @anima_stand == 25
            @a1 += 1
            @anima_stand = 0
            end
        if @window.button_down? Gosu::Button::KbSpace and !@hit and @t_attack > 1
            @hit = true
            @hit_sound.play
              if @t_attack > 1
                @t_attack =0
            end
        else
            if @t_attack > 1
                @hit = false
            end
            @t_attack += 1.0/25
        end

        if @window.button_down? Gosu::Button::KbLeft
            @hit = false
            if @x < 133 then
               @x
               else
               @direction = :left
               @moving = true
               @x += -1
               @life_x += 1.5
               @add +=1
               if @add == 8 then
               @frame += 1
               end
            end
        end
        if @window.button_down? Gosu::Button::KbRight
            @hit = false
            if @x > 610 then
                @x
                else@direction = :right
                @moving = true
                @x += 1
                @life_x -= 1.5
                @add +=1
                if @add == 8 then
                @frame += 1
                end
            end
        end
    end
    end
#####--DRAW------###########################################################
    def draw
        if @life_grow == true
        a = @a1 % @life_up.size
        @life_up[a].draw @life_x, 175,3,0.45,0.45,-1
        end

        if @dead
            @down.draw(@x,@y, 2,-1)            
        else
                if @hit
					if @direction == :right
                        a = @a1 % @attack.size
                        @attack[a].draw(@x+35,@y,2,-1)
                        
					else
                        a = @a1 % @attack.size
					    @attack[a].draw(@x-100,@y,2,1)
                        
					end
                else
                    @add = @add % 8
                    f = @frame % @move.size
                    a = @a1 % @icon.size
                    image = @moving ? @move[f] : @icon[a]
                    if @direction == :right
                    image.draw(@x,@y,2,-1)
                    else
                    image.draw(@x - 71,@y,2)
                    end
                end                
        end
    end
######--SOFRE ATQUE#########################################################
    def hit_by?(enemy)
        if Gosu::distance(enemy.x, enemy.y, @x, @y) < 25
            @life = @life - 1
            if @life == 0 
            @dead = true
            end
        end
    end
    def hit_by2?(enemy2)
        if Gosu::distance(enemy2.x, enemy2.y, @x, @y) < 80
            @life = @life - 1
            if @life == 0 
            @dead = true
            end
        end
    end
######--CORAÇÕES#########################################################
    def lifeup
        if @life_grow == true
            if @direction == :left
             if Gosu::distance(@life_x,180, @x, 180) < 65
             @life += 7+rand(5)
             @life_sound.play
             @life_grow = false
             @life_time = 0
             @lifex = rand(@window.height)
             end
            elsif @direction == :right
             if Gosu::distance(@life_x,180, @x, 180) < 2
             @life += 10+rand(5)
             @life_sound.play
             @life_grow = false
             @life_time = 0
             @lifex = rand(@window.height)
             end
            end
        end
    end
end
