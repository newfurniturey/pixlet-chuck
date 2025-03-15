"""
Applet: Pixlet Chuck
Summary: Random Chuck Norris Joke
Description: Displays a random Chuck Norris joke.
Author: newfurniturey
"""

load("render.star", "render")
load("schema.star", "schema")
load("http.star", "http")
load("encoding/base64.star", "base64")

def get_delay(joke):
    if len(joke) > 160:
        return 50
    return 100

def build_landscape_layout(joke, icon):
    return render.Root(
        delay = get_delay(joke),
        child = render.Column(
            expanded = True,
            cross_align = "center",

            children = [
                render.Image(src = icon, height = 16),

                render.Marquee(
                    child = render.Padding(
                        pad = (0, 12, 0, 0),
                        child = render.WrappedText(joke),
                    ),
                    scroll_direction = "vertical",
                    height = 16,
                    offset_start = 5,
                    offset_end = 5,
                ),
            ],

        ),
    )

def build_portrait_layout(joke, icon):
    return render.Root(
        delay = get_delay(joke),
        child = render.Row(
            expanded = True,
            cross_align = "center",

            children = [
                render.Padding(
                    pad = 1,
                    child = render.Image(src = icon, height = 25),
                ),

                render.Marquee(
                    child = render.Padding(
                        pad = (0, 12, 0, 0),
                        child = render.WrappedText(joke),
                    ),
                    scroll_direction = "vertical",
                    height = 32,
                    offset_start = 5,
                    offset_end = 5,
                ),
            ],

        ),
    )
def main(config):
    resp = http.get("https://waffles.dev/api/chuck/joke", ttl_seconds = 3600).json()
    if not resp["success"]:
        print("Error: ", resp["error"])
        return

    joke = resp["joke"]
    layout = resp["layout"]
    icon = http.get(resp["icon"], ttl_seconds = 3600).body()

    if layout == "landscape":
        return build_landscape_layout(joke, icon)
    
    return build_portrait_layout(joke, icon)
