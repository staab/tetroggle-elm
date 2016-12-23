- question mark for help overlay
- animate submit success/failure

- Refactor existing code into a more sensible structure. 
    + Make the game a single module.
    + Make blocks a list, and keep shape blocks out of it. Matrixify when necessary.
    + Write an abstraction layer that deals with block filtering/path finding, formatting, modification, merging, etc.
- Handle randomness via tasks?
- Add touch functionality
    + Set a mode build parameter through ports
    + Create an explicit path from clicked tiles rather than tracking input
    + Don't show input
- Port it to mobile
- Make it look nice
    + Remove blocks one at a time starting from the beginning of the word
    + Animate points
    + Animate blocks disappearing
- Add effects in as the game goes along
    + Unselectable blocks
    + Blocks that when used explode, destroying everything adjacent
    + Blocks that when used remove everything in their row/column
    + Blocks that slow time
    + Blocks that you can collect that populate a power-up thing in the sidebar. When you click the power up, you can remove a block you don't want.
    + 
- Lock down some effects so that people have to buy them
- Add menus
    + Help with a key to the various effects
    + Stats
    + High scores - imitate Influence
- Multiplayer?
    + Blocks that you can collect to attack your opponent