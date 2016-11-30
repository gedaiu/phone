module phone.ui.data;

public import derelict.sdl2.sdl;
public import derelict.sdl2.image;
public import derelict.sdl2.mixer;
public import derelict.sdl2.ttf;
public import derelict.sdl2.net;

import std.math;

struct Size
{
	int width;
	int height;
}

struct Position
{
	int x;
	int y;
}

struct Color
{
	ubyte r;
	ubyte g;
	ubyte b;

	ubyte a;
}

struct ColorStates {
	Color main;
	Color active;
}

struct Rect {
  Position position;
  Size size;

  @property pure {
		Position center() {
			return Position(position.x + size.width / 2, position.y + size.height / 2);
		}

		Position p1() { return position; }
		Position p2() { return Position(p1.x + size.height, p1.y); }
		Position p3() { return Position(p1.x + size.height, p1.y + size.width); }
		Position p4() { return Position(p1.x, p1.y + size.width); }
	}
}

double distance(Position a, Position b) pure {
	immutable double d1 = (b.x - a.x);
	immutable double d2 = (b.y - a.y);

	return sqrt(d1*d1 + d2*d2);
}

double area(Position a, Position b, Position c) pure {
		immutable auto aa = distance(a, b);
		immutable auto bb = distance(b, c);
		immutable auto cc = distance(c, a);

		immutable auto p = (aa + bb + cc) / 2;

		return sqrt(p * (p - aa) * (p - bb) * (p - cc));
}

@("Triangle area computation")
unittest {
	auto res = area(Position(0,0), Position(1,1), Position(0,1)) - 0.5;

	assert(res < 0.1);
}


double area(Rect rect) pure {
	return area(rect.p1, rect.p2, rect.p3) + area(rect.p3, rect.p4, rect.p1);
}

bool match(Position p, Rect rect) pure {
	import std.stdio;
	auto area1 = rect.area;

	if(p.x < rect.position.x || p.y < rect.position.y) {
		return false;
	}

	if(p.x > rect.position.x + rect.size.width || p.y > rect.position.y + rect.size.height) {
		return false;
	}

	return true;
}

@("Point matching inside rectangle")
unittest {
	import std.stdio;

	auto rect = Rect(Position(5, 5), Size(5, 5));
	auto rect2 = Rect(Position(3, 147), Size(100, 78));

	assert(!Position(0,0).match(rect));
	assert(Position(6,6).match(rect));
	assert(Position(60, 202).match(rect2));
}

void set(Color color, SDL_Renderer* render)
{
	SDL_SetRenderDrawColor(render, color.r, color.g, color.b, color.a);
}
