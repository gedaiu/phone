module phone.ui.button;

import phone.config;
import phone.ui.text;
import vibe.data.json;
import std.stdio;

public import phone.ui.data;
public import phone.ui.mouseEvent;

class Button
{
	Position position;
	Size size;

	ColorStates colorStates;

	Text text;

	void delegate(Button value) onPress;

	private Color currentColor;
	private bool pressed = false;

	this(Position position, Size size, ColorStates colorStates) {
		this.position = position;
		this.size = size;
		this.colorStates = colorStates;
	}

	this(Position position, Size size, ColorStates colorStates, Text text) {
		this(position, size, colorStates);
		this.text = text;
	}

	void process(MouseEvent event) {
		currentColor = event.position.match(Rect(position, size)) && event.button != MouseButton.None ?
											colorStates.active : colorStates.main;

		if(event.button == MouseButton.None) {
			pressed = false;
		}

		if(event.position.match(Rect(position, size)) && onPress !is null && event.button != MouseButton.None && !pressed) {
			onPress(this);
			pressed = true;
		}
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

	this(ref Button button, SDL_Renderer* render)
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
