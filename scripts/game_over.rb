class Over
    def initialize(window)
        @window = window
        @icon = Gosu::Image.load_tiles(@window, "imagen/cat.png",-3,-1,true)
        @icon2 = Gosu::Image.new(@window, "imagen/cat_2.png", true)
        @cat = Gosu::Sample.new(@window, "audio/cat.wav")
        @x = -15
        @y = window.height - 170
        @anima_stand = 0
        @a1 = 0
        @down = 0
    end
    
    def update
        @anima_stand += 1
        if @anima_stand == 15
            @a1 += 1
            @anima_stand = 0
        end
        if @x < 150 then
        @x = @x + 1
        else
        @down = @down + 1
            if @down == 1
                @cat.play
            end
        end
    end
    
    def draw 
        if @down > 0
        @icon2.draw(@x, @y,1)
        else
        a = @a1 % @icon.size
        image = @icon[a]
        image.draw(@x,@y,1)
        end
    end
end

