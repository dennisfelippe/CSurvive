class Window < Gosu::Window
	attr_reader :texto, :tempo
	def initialize
		#Criar Janela do Jogo Para o Tamanho Definido e se vai ou não estar em FULLSCREEN
		super(650,320,false)
		self.caption = "C. Survive VR. 1.0 - REDES IFRN 2015.2N" #Determina Titulo da Janela
		@player = Player.new(self) #Carrega Classe Player (jogador)
		#Carrega as Classes Inimigos
		@enemy = Enemy.new(self)
		@enemy2 = Enemy2.new(self)
		#Musicas de Fundo Para Inicio/Meio/Fim
		@song = Gosu::Song.new(self, "audio/bg.ogg") #MUSICA 1 EM JOGO
		@song2 = Gosu::Song.new(self, "audio/bg-2.ogg") #MUSICA 2 EM JOGO
		@song3 = Gosu::Song.new(self, "audio/bg-3.ogg") #MUSICA 3 EM JOGO
		@time_song = 0
		@faixa = rand(0..2)# MUSICA INICIAL ALEATORIA

		@song1 = Gosu::Song.new(self, "audio/bg1.ogg") #MUSICA TELA INCIAL
		@lose = Gosu::Song.new(self, "audio/lose.ogg") #MUSICA TELA FINAL
        #Fundo e Texto e Fonte.
        @back = Back.new(self) # FUNDO EM JOGO
        @back2 = Gosu::Image.new "imagen/bg_d.png" # FUNDO FINAL
		@back3 = Gosu::Image.new "imagen/bg_1.png" # FUNDO INICIAL
		@pend = Gosu::Image.new "imagen/pend.png" # PENDANTE
        @texto = Gosu::Font.new(self, 'dados/font.ttf', 15)
        @texto2 = Gosu::Font.new(self, 'dados/font2.ttf', 20)
		#Efeito de FIM de Jogo
        @over = Over.new(self)
        #Cria o Estado do Jogo
        $estado = "INICIO"
        #Cria o Contador de Tempo
        @tempo = 0.0
	
	end
	
	def button_down id #Define a Tecla ESC como Saida Para o Jogo
    close if id == Gosu::KbEscape
  	end

	def update
		if ($estado == "INICIO" )
			@song1.play #Toca Musica Inicial
			#Aguarda a Instruçã do Botao ENTER Para Inicio do Jogo
			if button_down? Gosu::Button::KbReturn
			$estado = "JOGANDO" 
			end
			@angle = Math.sin(Time.now.to_f)*20 #Realize o Efeito de Balanço do Pendulo

		elsif ($estado =="JOGANDO" ) then
				@tempo += 1.0/60 #Contagem do Tempo
				@song1.stop #Para Musica Inicial
					
					if @faixa == 0
					@song.play(true) # Inicia 1ª Musica do Gameplay
					elsif @faixa == 1
					@song2.play(true) # Inicia 2ª Musica do Gameplay	
					elsif @faixa == 2
					@song3.play(true) # Inicia 3ª Musica do Gameplay
					end
					#SISTEMA DE TROCA DE MUSICAS A CADA 2 Min.
					@time_song += 1.0/60
					if @time_song > 120
						if @faixa < 2
						@faixa += 1
						@time_song = 0
						else
						@faixa = 0
						@time_song = 0
						end
					end
				##--Condições Para Final do Jogo--##
				if @player.hit_by? @enemy
            	@song.stop
            	@lose.play
				$estado = "FIM"
				elsif @player.hit_by2? @enemy2
            	@song.stop
            	@lose.play
				$estado = "FIM"
           		##--Caso Não Finalize o Jogo Rode--##
           		else
				@player.update
				@enemy.update @player,@back
				@enemy2.update @player
				@enemy.hit_by? @player
				@enemy2.hit_by? @player
				@back.update @player,@enemy,@enemy2
				end
			##--Efeitos Para o FIM do Jogo--##
			elsif ($estado == "FIM")
			@over.update
			@player.update
        end
	
        

	end
	
	def draw
		###MOSTRAR CORDENDAS (Utilizado Apenas Para Teste)###
		#@texto.draw("Cordenadas Jogador: #{@player.x} #{@player.y}", 20, 20, 3.0, 1.0, 1.0, 0xffff0000)
		#@texto.draw("Cordenadas Life: #{@player.life_x}", 20, 35, 3.0, 1.0, 1.0, 0xffff0000)
		#@texto.draw("Cordenadas Inimigo: #{@enemy2.x} #{@enemy2.y}", 20, 50, 3.0, 1.0, 1.0, 0xffff0000)

		if ($estado == "INICIO" ) then

		@texto.draw("Bem Vindo, Pressione a Tecla [ENTER] para Iniciar.",100,160,5,1.3, 1.3)
		@texto.draw("<= | => Para se movimentar e Espaco para Atacar",80,285,5,1.0, 1.0)
		@texto.draw("E Possivel Restaurar um Pouco de Vida Pegando Coracoes.",50,305,5,1.0, 1.0)
		@back3.draw 0, 0, 0, 1.0,1.0
		@pend.draw_rot 520,0,2 , @angle


		elsif ($estado =="JOGANDO" ) then
		@texto2.draw("TEMPO: #{@tempo.to_i}", 400, 10, 2.0, 2.0, 2.0, 0xffffffff)
		@texto2.draw("TEMPO: #{@tempo.to_i}", 401, 11, 2.0, 2.0, 2.0, 0xff_ff0000)
		@player.draw
		@enemy.draw
		@enemy2.draw
		#DESENHA LIFE INIMIGO
		@texto.draw("Vida: #{@enemy.life}",@enemy.x-35, @enemy.y-20, 3.0, 1.25, 1.25)
		@texto.draw("Vida: #{@enemy2.life}",@enemy2.x, @enemy2.y-20, 3.0, 1.25, 1.25)
		#DESENHA FUNDO
		@back.draw #FUNDO ANIMADO

		#ESQUEMA DE DESENHO DA VIDA DO JOGADOR
		#CONDIÇÃO PARA O DESENHO DO NOME VIDA EXPERIENCIA E A SUA PORCENTAGEM
		if @player.life > 0 
		@texto.draw("Vida: #{@player.life}", 25, 11, 4.0, 1.3, 1.3, 0xff_000000)
		@texto.draw("Vida: #{@player.life}", 26, 12, 4.0, 1.3, 1.3, 0xffffffff)
		#DESENHA EXPERIENCIA
		@texto.draw("Level: #{@player.level}/ XP: #{@player.exp}", 12, 33, 4.0, 1.1, 1.0, 0xff_000000)
		@texto.draw("Level: #{@player.level}/ XP: #{@player.exp}", 13, 34, 4.0, 1.1, 1.0, 0xffffffff)
		#BARRA DE EXPERIENCIA
		draw_quad(8, 33, 0xff000000, 8, 49, 0xff000000, 9+100*1.3, 49, 0xff000000, 12+100*1.3, 33, 0xff000000, 2)
		draw_quad(10, 35, 0xff99ffff, 10, 47, 0xff000000, 9+@player.exp*1.3, 47, 0xff000000, 12+@player.exp*1.3, 35, 0xff99ffff, 2)


		#CONDIÇÃO E ESQUEMA DE DESENHO DO FUNDO PRETO NA BARRA DE VIDA
			if @player.life <= 100 
		draw_quad(8, 8, 0xff000000, 8, 32, 0xff000000, 18+100*1.3, 8, 0xff000000, 12+100*1.3, 32, 0xff000000, 2)
			else
		draw_quad(8, 8, 0xff000000, 8, 32, 0xff000000, 18+@player.life*1.3, 8, 0xff000000, 12+@player.life*1.3, 32, 0xff000000, 2)
			end
		#DESENHO VIDA NORMAL AMARELO-VERDE
			if @player.life > 50 and @player.life <= 100
			draw_quad(10, 10, 0xffffc800, 10, 30, 0xff000000, 15+@player.life*1.3, 10, 0xff00ff00, 10+@player.life*1.3, 30, 0xff000000, 3)
		#DESENHO VIDA CRITICA VERMELHO-AMARELO
			elsif @player.life <= 50
			draw_quad(10, 10, 0xffff0000, 10, 30, 0xff000000, 15+@player.life*1.3, 10, 0xffffc800, 10+@player.life*1.3, 30, 0xff000000, 3)
		#DESENHO VIDA ACIMA DE 100% VERDE-AZUL	
			else
			draw_quad(10, 10, 0xff00ff00, 10, 30, 0xff000000, 15+@player.life*1.3, 10, 0xff_0066ff, 10+@player.life*1.3, 30, 0xff000000, 3)
			end
		else
		
		end
		#Desenhos para Fim de Jogo
		elsif ($estado == "FIM") then
		msg = "Game Over" #Menssagem
		@texto.draw(msg, self.width/3.75, self.height/2.75, 3, 4.0, 4.0, 0xff_000000) #Texto de Game Over
		@texto.draw(msg, self.width/3.7, self.height/2.70, 3, 4.0, 4.0, 0xffffff00) #Sombra do Texto Game Over
		@texto.draw("Pressione Tecla [ESC] para sair.", 10 , 300, 3, 1.0, 1.0)
		@texto.draw("Voce Conseguiu sobreviver por #{@tempo.to_i} segundos." , 160 , 200, 3, 1.0, 1.0, 0xffffffff)
		@texto.draw("Sua Vida se Foi.", 25, 13, 4.0, 1.3, 1.3, 0xff_000000) #Desenha No Local onde é a barra de vida.
		@texto.draw("Sua Vida se Foi.", 26, 14, 4.0, 1.3, 1.3, 0xffffffff)
		#Desenha Fundo de FIM+Player e o Final.
		@player.draw
		@over.draw
		@back2.draw -300, 0, 0, 1.4,1.4
		end

	end
	
end
