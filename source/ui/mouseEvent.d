module phone.ui.mouseEvent;

import derelict.sdl2.sdl;
public import phone.ui.data;

enum MouseButton {
  None,
  Left,
  Right,
  Middle
}

struct MouseEvent {
  Position position;

  MouseButton button;
}

void updateFromSdl(ref MouseEvent mouseEvent) {
  auto state = SDL_GetMouseState(&mouseEvent.position.x, &mouseEvent.position.y);

  if (state & SDL_BUTTON(SDL_BUTTON_LEFT)) {
    mouseEvent.button = MouseButton.Left;
  } else if (state & SDL_BUTTON(SDL_BUTTON_RIGHT)) {
    mouseEvent.button = MouseButton.Right;
  } else if (state & SDL_BUTTON(SDL_BUTTON_MIDDLE)) {
    mouseEvent.button = MouseButton.Middle;
  } else {
    mouseEvent.button = MouseButton.None;
  }

  version(ARM) {} else {
    mouseEvent.position.x *= 2;
    mouseEvent.position.y *= 2;
  }
}
