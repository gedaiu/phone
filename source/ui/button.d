module phone.ui.button;

import phone.config;
import phone.ui.text;
import vibe.data.json;
import std.stdio;

public import phone.ui.data;
public import phone.ui.mouseEvent;

struct Button
{
	Position position;
	Size size;

	ColorStates colorStates;

	Text text;

	private Color currentColor;

	void process(MouseEvent event) {
		currentColor = event.position.match(Rect(position, size)) && event.button != MouseButton.None ?
											colorStates.active : colorStates.main;
	}

	ButtonRender render(SDL_Renderer* render)
	{
		return ButtonRender(this, render);
	}

	Color color() {
		return currentColor;
	}
}

struct ButtonRender
{
	SDL_Renderer* render;
	Button button;
	TextRender text;

	this(Button button, SDL_Renderer* render)
	{
		this.render = render;
		this.button = button;
		this.text = button.text.render(render);
	}

	void draw()
	{
		SDL_Rect rect;
		rect.x = button.position.x;
		rect.y = button.position.y;
		rect.w = button.size.width;
		rect.h = button.size.height;

		button.color.set(render);

		SDL_RenderFillRect(render, &rect);
		text.drawCenter(Rect(button.position, button.size).center);
	}
}
