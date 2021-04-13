# Defold Polygon Editor

Since [it's possible to use convex polygon collision shapes with Defold](https://forum.defold.com/t/does-defold-support-only-three-shapes-for-collision-solved/1985), but the Editor doesn't yet support creating and editing them, I wrote a little program(with Defold) to fill that gap. So you no longer have to make a text file and write in vertex coordinates, in counter-clockwise order, by hand!

It's very, very simple and unpolished. Here is a short list of features:
- Load an image as a reference for your polygon (unscaled and centered at origin).
- Open and save polygon files.
    - Uses [Def-Diags](https://github.com/andsve/def-diags/) for native file dialogs on Windows and Mac, and tries to use Zenity on Linux.
    - Can still save polygons in the application folder if none of those work.
- Highlights convex (and therefore invalid) vertices in red.
- Hold shift to snap vertices to 5-pixel increments.

!["Editor screenshot"](https://raw.githubusercontent.com/rgrams/defold_polygon_editor/master/screenshot.png)
