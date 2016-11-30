module phone.ui.label;

import phone.config;
import phone.ui.text;
import vibe.data.json;
import std.stdio;

public import phone.ui.data;
public import phone.ui.mouseEvent;

struct Label
{
	Position position;
	Size size;

	Color color;
	Text text;

  this(Position position, Size size, Color color) {
    text = new Text();
    this.position = position;
    this.size = size;
    this.color = color;
  }

	LabelRender render(SDL_Renderer* render)
	{
		return LabelRender(this, render);
	}
}

struct LabelRender
{
	SDL_Renderer* render;
	Label label;
	TextRender text;

	this(ref Label label, SDL_Renderer* render)
	{
		this.render = render;
		this.label = label;
		this.text = label.text.render(render);
	}

	void draw()
	{
		SDL_Rect rect;
		rect.x = label.position.x;
		rect.y = label.position.y;
		rect.w = label.size.width;
		rect.h = label.size.height;

		label.color.set(render);

		SDL_RenderFillRect(render, &rect);
		text.drawCenter(Rect(label.position, label.size).center);
	}
}
