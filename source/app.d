import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.sdl2.mixer;
import derelict.sdl2.ttf;
import derelict.sdl2.net;

import phone.config;
import phone.ui.numerickeyboard;
import phone.ui.mouseEvent;

import std.stdio;

import core.thread;

shared static this() {
	// Load the SDL 2 library.
	DerelictSDL2.load(SharedLibVersion(2, 0, 3));

	// Load the SDL2_image library.
	DerelictSDL2Image.load();

	// Load the SDL2_mixer library.
	//DerelictSDL2Mixer.load();

	// Load the SDL2_net library.
	// DerelictSDL2Net.load();

	// Load the SDL2_ttf library
	DerelictSDL2ttf.load();

	TTF_Init();
}

void main()
{
	auto config = PhoneConfig.local;

	if (SDL_Init(SDL_INIT_VIDEO) != 0)
	{
		writeln("SDL_Init Error: ", SDL_GetError());
	}

	auto win = config.getWindow;

	//auto win = SDL_CreateWindow("Test SDL 2", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
        //                                   800, 600, SDL_WINDOW_SHOWN);

	auto ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

	if (ren is null)
	{
		writeln("SDL_CreateRenderer Error: ", SDL_GetError());
		return;
	}

	int height = config.screen.height - 350;
	auto keyboard = NumericKeyboard(
										Position(0, config.screen.height - height),
										Size(config.screen.width, height),
										config.colors.defaultStates);

	SDL_SetRenderDrawBlendMode(ren, SDL_BLENDMODE_BLEND);

	auto mouseEvent = MouseEvent();

	while(true)
	{
		auto isExit = false;
		const Uint8* keys = SDL_GetKeyboardState(null);
		SDL_Event e;

		while (SDL_PollEvent(&e))
		{
			if (keys[SDL_SCANCODE_X])
			{
				isExit = true;
			}
		}

		mouseEvent.updateFromSdl();

		if(isExit) {
			break;
		}

		config.colors.background.set(ren);
		//First clear the renderer
		SDL_RenderClear(ren);

		keyboard.process(mouseEvent);
	
		keyboard.render(ren).draw;
		//Update the screen
		SDL_RenderPresent(ren);
		//Take a quick break after all that hard work
		SDL_Delay(10);
	}

	scope(exit) {
		TTF_Quit();

		SDL_DestroyRenderer(ren);
		SDL_DestroyWindow(win);
		SDL_Quit();
	}
}
