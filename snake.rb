require 'gosu'

class Czlon
	attr_reader :x, :y
	def initialize(x, y, okno)
		@x = x
		@y = y
		@okno = okno
	end

	def rysuj
		Gosu.draw_rect(
			@x * @okno.rozmiar_komorki,
			@y * @okno.rozmiar_komorki,
			@okno.rozmiar_komorki,
			@okno.rozmiar_komorki,
			Gosu::Color::WHITE)
	end

	def daj_nastepny kierunek
		x = @x
		y = @y

		case kierunek
		when :prawo
			x += 1
		when :lewo
			x -= 1
		when :gora
			y -= 1
		when :dol
			y += 1
		end

		x = 0 if x == @okno.szerokosc_okna
		x = @okno.szerokosc_okna - 1 if x == -1
		y = 0 if y == @okno.wysokosc_okna
		y = @okno.wysokosc_okna - 1 if y == -1

		Czlon.new(x, y, @okno)
	end
end

class OknoGlowne < Gosu::Window
	attr_reader :szerokosc_okna, :wysokosc_okna, :rozmiar_komorki

	def initialize
		@stan = :gra
		@szerokosc_okna = 40
		@wysokosc_okna = 30
		@rozmiar_komorki = 16
		super(
			@szerokosc_okna * @rozmiar_komorki,
			@wysokosc_okna * @rozmiar_komorki)
		self.caption = 'Snake'
		daj_smaczek
		@srodek = [
			Czlon.new(10, 10, self),
			Czlon.new(10, 11, self),
			Czlon.new(11, 11, self),
			Czlon.new(12, 11, self)]
		@poczatek = Czlon.new(13, 11, self)
		@koniec = Czlon.new(9, 10, self)
		@kierunek = :prawo

		@szybkosc = 15
		@licznik_klatek = @szybkosc
		@font = Gosu::Font.new(20)
		@duzy_font = Gosu::Font.new(100)
		@wynik = 0
	end

	def update
		if @stan == :gra
			@licznik_klatek -= 1
			if @licznik_klatek == 0
				@licznik_klatek = @szybkosc
				nowy = @poczatek.daj_nastepny @kierunek

				kolizje = ([@koniec] + @srodek).select do |czlon|
					czlon.x == nowy.x and czlon.y == nowy.y
				end
				unless kolizje.empty?
					@stan = :koniec
				end
				if @poczatek.x == @x_smaczka and @poczatek.y == @y_smaczka
					daj_smaczek
					@wynik += 1
				else
					@koniec = @srodek.shift
				end
				@srodek << @poczatek
				@poczatek = nowy
			end

			if Gosu.button_down? Gosu::KB_RIGHT and @kierunek != :lewo
				@kierunek = :prawo
			elsif Gosu.button_down? Gosu::KB_LEFT and @kierunek != :prawo
				@kierunek = :lewo
			elsif Gosu.button_down? Gosu::KB_UP and @kierunek != :dol
				@kierunek = :gora
			elsif Gosu.button_down? Gosu::KB_DOWN and @kierunek != :gora
				@kierunek = :dol
			end

		end
		exit if Gosu.button_down? Gosu::KB_ESCAPE
	end

	def draw
		if @stan == :gra
			@poczatek.rysuj
			@koniec.rysuj
			@srodek.each do |czlon|
				czlon.rysuj
			end
			if @poczatek.x != @x_smaczka or @poczatek.y != @y_smaczka
				Gosu.draw_rect(
					@x_smaczka * @rozmiar_komorki + 2,
					@y_smaczka * @rozmiar_komorki + 2,
					@rozmiar_komorki - 4,
					@rozmiar_komorki - 4,
					Gosu::Color::YELLOW)
			end
		else
			napis = "Koniec gry"
			@duzy_font.draw_text(
				napis,
				50,
				100,
				3,
				1.0,
				1.0,
				Gosu::Color::WHITE)
		end

		napis = "Wynik: " + @wynik.to_s
		@font.draw_text(
			napis,
			10,
			10,
			2,
			1.0,
			1.0,
			Gosu::Color::GREEN)
		@font.draw_text(
			napis,
			11,
			11,
			1,
			1.0,
			1.0,
			Gosu::Color::BLACK)
		
	end

	def daj_smaczek
		@x_smaczka = rand(@szerokosc_okna)
		@y_smaczka = rand(@wysokosc_okna)
	end
end

OknoGlowne.new.show