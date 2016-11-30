module phone.ui.numerickeyboard;

public import phone.ui.data;

import std.stdio, std.conv;
import std.algorithm.iteration;

import phone.ui.button;
import phone.ui.text;

struct NumericKeyboard
{
	immutable int border = 3;

	Position position;
	Size size;
	Color color;

	Button[] buttons;

	void delegate(string value) onKeyPress;

	this(Position position, Size size, ColorStates states)
	{
		this.position = position;
		this.size = size;
		this.color = color;

		auto width = size.width / 3;
		auto height = size.height / 4;
		int index = 1;

		for (int i = 0; i < 3; i++)
		{
			for (int j = 0; j < 3; j++)
			{
				int x = position.x + j * width + border;
				int y = position.y + i * height + border;

				buttons ~= new Button(Position(x, y), Size(width - border * 2,
						height - border * 2), states, new Text(index.to!string));
				index++;
			}
		}

    for (int i = 0; i < 3; i++) {
			int x = position.x + i * width + border;
			int y = position.y + 3 * height + border;

      buttons ~= new Button(Position(x, y), Size(width - border * 2,
          height - border * 2), states, new Text("0"));
    }

    buttons[9].text.value = "*";
    buttons[11].text.value = "#";

		foreach(button; buttons) {
			button.onPress = &this.buttonPressed;
		}
	}

	private void buttonPressed(Button button) {
		if(onKeyPress !is null) {
			onKeyPress(button.text.value);
		}
	}

	void process(MouseEvent event) {
		buttons.each!((ref a) => a.process(event));
	}

	NumericKeyboardRender render(SDL_Renderer* render)
	{
		return NumericKeyboardRender(this, render);
	}
}

struct NumericKeyboardRender
{
	ButtonRender[] buttons;

	this(NumericKeyboard keyboard, SDL_Renderer* render)
	{
		foreach (button; keyboard.buttons)
		{
			buttons ~= button.render(render);
		}
	}

	void draw()
	{
		foreach (button; buttons)
		{
			button.draw;
		}
	}
}
