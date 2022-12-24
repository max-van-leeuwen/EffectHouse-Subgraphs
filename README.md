# EffectHouse-Subgraphs

Some of the subgraphs I made and use in my projects.
Feel free to use them for your own work! Do give me a little shoutout if you can :)


- Cubic In/Out
    - Converts a 0-1 value from linear to Cubic (curve In + Out). Apply this to a fade-out or when lerping an object from position A to B, it will make it more smooth!
- Score Counter Animated
    - This setup makes counting a score possible, using 6 digits of text! Since 'real' text is not supported in Effect House (yet), this subgraph reads textures for all digits 0-9 and applies them to the right Images. It animates from the previous score to the new one! See the example project for more information.
- Score Counter Digit Textures
    - This subgraph is like 'Score Counter Animated', except without the score animation. It simply converts any number between 0-999999 to a combination of textures of digits (0-9), so you can apply those to the right Images!
- Canvas to Screen
    - Converts the 2D position of an object in a Canvas to a screen position (0-1). Useful, for example, to find the distance between a 2D Image and the Hand Tracking position (when both are converted to screen space).