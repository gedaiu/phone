module phone.ui.text;

import phone.config;
import phone.ui.data;
import std.exception;
import std.stdio, std.conv, std.string;

struct Text
{
	string value;

	TextRender render(SDL_Renderer* render)
	{
		return TextRender(this, render);
	}
}

struct TextRender
{
	Text text;
	SDL_Renderer* render;
	SDL_Texture* texture;
	int width;
	int height;

	this(Text text, SDL_Renderer* render)
	{
		this.text = text;
		this.render = render;

		SDL_Color textColor = SDL_Color(255, 255, 255);
		auto textSurface = TTF_RenderText_Solid(PhoneConfig.local.fonts.basic,
				text.value.toStringz, textColor);

		enforce(textSurface !is null, "Unable to create text: " ~ TTF_GetError().fromStringz);

		width = textSurface.w;
		height = textSurface.h;

		texture = SDL_CreateTextureFromSurface(render, textSurface);
		SDL_FreeSurface(textSurface);

		enforce(texture !is null, "Unable to create texture: " ~ SDL_GetError().fromStringz);
	}

	void draw(Position position)
	{
		SDL_Rect rect;
		rect.x = position.x;
		rect.y = position.y;
		rect.w = width;
		rect.h = height;

		auto result = SDL_RenderCopy(render, texture, null, &rect);
		enforce(result == 0, "Unable to render test: " ~ SDL_GetError().fromStringz);
	}

	void drawCenter(Position position)
	{
		SDL_Rect rect;
		rect.x = position.x - width / 2;
		rect.y = position.y - height / 2;
		rect.w = width;
		rect.h = height;

		auto result = SDL_RenderCopy(render, texture, null, &rect);
		enforce(result == 0, "Unable to render test: " ~ SDL_GetError().fromStringz);
	}
}
