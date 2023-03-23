require 'gosu'

class Czlon
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
		case kierunek
		when :prawo
			Czlon.new(@x + 1, @y, @okno)
		when :lewo
			Czlon.new(@x - 1, @y, @okno)
		when :gora
			Czlon.new(@x, @y - 1, @okno)
		when :dol
			Czlon.new(@x, @y + 1, @okno)
		end
	end
end

class OknoGlowne < Gosu::Window
	attr_reader :szerokosc_okna, :wysokosc_okna, :rozmiar_komorki

	def initialize
		@szerokosc_okna = 40
		@wysokosc_okna = 30
		@rozmiar_komorki = 16
		super(
			@szerokosc_okna * @rozmiar_komorki,
			@wysokosc_okna * @rozmiar_komorki)
		self.caption = 'Snake'
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
	end

	def update
		@licznik_klatek -= 1
		if @licznik_klatek == 0
			@licznik_klatek = @szybkosc
			nowy = @poczatek.daj_nastepny @kierunek
			@koniec = @srodek.shift
			@srodek << @poczatek
			@poczatek = nowy
		end
	end

	def draw
		@poczatek.rysuj
		@koniec.rysuj
		@srodek.each do |czlon|
			czlon.rysuj
		end
	end
end

OknoGlowne.new.show