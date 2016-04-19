class Enemy
    attr_reader :x, :y, :alive, :life
    attr_writer :x
    def initialize(window)
        @window = window
        @icon = Gosu::Image.load_tiles(@window, "imagen/enemy.png",-3,-1,true)
        @x = 1000
        @y = window.height-180
        @alive = true
        @anima_stand = 0
        @a1 = 0
        @life = 8
        @speed = 0.4
        @xp = 15
        @hit = Gosu::Sample.new(@window, "audio/hit_e.wav")
    end
#####--UPDATE----############################################################   
    def update(player,back)
        #Realiza Animação do Inimigo Andando.
        if @alive
            @anima_stand += 1
            if @anima_stand == 20
                @a1 += 1
                @anima_stand = 0
            end
                @x = @x -@speed 
                if @x < player.x+10
                @x = player.x+20
                end
        else
        @x = 750+rand(200)
        @alive = true
        @life = 8+rand(@window.tempo/3).to_i
        @speed += 0.08
        end    
    end
#####--DRAW------###########################################################  
    def draw
        if @alive
        a = @a1 % @icon.size
        image = @icon[a]
        image.draw(@x,@y,2,-1)
        end
    end
######--SOFRE ATQUE#########################################################
    def hit_by?(player)
        if Gosu::distance(player.x,player.y,@x,@y) < 55 and player.hit == true and player.direction == :right
            @life = @life -(2*player.level)
            @hit.play
            @x += 30
            if @life < 1 
            @alive = false
            player.exp += ((@xp+rand(5))/player.level).to_i
            end

        end
    end

end
