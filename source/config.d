module phone.config;

import phone.ui.data;

import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import std.stdio;
import std.file;
import std.string;
import std.exception;
import vibe.data.json;

struct PhoneConfig
{
	static PhoneConfig local;
	static this() {
		local = "config.json".readText.parseJsonString.deserializeJson!PhoneConfig;
	}

	string title;

	PhoneColors colors;
	PhoneScreen screen;
	FontList fonts;
}

struct PhoneColors {
	Color background;

	ColorStates defaultStates;
}

struct PhoneScreen
{
	int width;
	int height;
}

struct FontList {
	TTF_Font *basic;
	TTF_Font *small;
	TTF_Font *number;

	Json src;

	void update() {
		basic = TTF_OpenFont(cast(const(char)*)src["basic"]["path"].to!string, src["basic"]["size"].to!int);
		enforce(basic !is null, "Unable to create font: " ~ TTF_GetError().fromStringz);

		small = TTF_OpenFont(cast(const(char)*)src["small"]["path"].to!string, src["small"]["size"].to!int);
		enforce(small !is null, "Unable to create font: " ~ TTF_GetError().fromStringz);

		number = TTF_OpenFont(cast(const(char)*)src["number"]["path"].to!string, src["number"]["size"].to!int);
		enforce(number !is null, "Unable to create font: " ~ TTF_GetError().fromStringz);
	}

	static FontList fromJson(Json src) {
		FontList fontList;

		fontList.src = src;

		return fontList;
	}

	Json toJson() const {
		throw new Exception("not implemented");
	}
}

auto getWindow(ref PhoneConfig config)
{
	auto numdrivers = SDL_GetNumVideoDrivers();

  writeln("Drivers count: ", numdrivers);

  for (int i=0;i<numdrivers;i++)
  {
    SDL_RendererInfo drinfo;
    SDL_GetRenderDriverInfo(i, &drinfo);

    writeln("Driver name: ", drinfo.name.fromStringz);
  }

	version(ARM) {
		auto win = SDL_CreateWindow(cast(const(char)*) config.title, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
				config.screen.width, config.screen.height, SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN);
	} else {
		auto win = SDL_CreateWindow(cast(const(char)*) config.title, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
				config.screen.width, config.screen.height, SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI);
	}

	enforce(win !is null, "SDL_CreateWindow Error: " ~ SDL_GetError().fromStringz);

	SDL_GL_GetDrawableSize(win, &config.screen.width, &config.screen.height);

	writeln("w", config.screen.width, " h", config.screen.height);
	PhoneConfig.local.fonts.update;

	return win;
}
