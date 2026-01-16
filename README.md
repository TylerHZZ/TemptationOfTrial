# TemptationOfTrial
A retro-style adventure game developed with MATLAB, leveraging the `simpleGameEngine` for interactive scene rendering, mouse control, and sprite-based visuals. Players navigate through three unique worlds, solving puzzles and overcoming trials in a nostalgic gaming experience.

## 📋 Project Overview
TemptationOfTrial is an educational and entertaining adventure game built for MATLAB environments. It integrates object-oriented programming (OOP) with the `simpleGameEngine` to create immersive, interactive scenes.

The core experience revolves around three distinct game worlds—Forest, Broken Bridge, and Cave—each with custom-designed puzzles and visual themes. The game utilizes retro-style sprites for graphics and mouse input for player interaction, offering a cohesive and engaging trial-based gameplay loop.

## 🛠️ Technical Stack & Dependencies
### Core Technologies
- **Programming Language**: MATLAB (supports R2018b+)
- **Game Engine**: `simpleGameEngine` (OOP-based MATLAB class for scene rendering and input handling)
- **Graphics**: Retro-style sprite sheets (PNG format)
- **Documentation**: PDF design specifications and preview materials

### Required Dependencies
- MATLAB Image Processing Toolbox (for sprite import/processing)
- No external libraries required—all core functionality relies on MATLAB's built-in functions and the included `simpleGameEngine`

## 🚀 Quick Start
### 1. Clone the Repository
```bash
git clone https://github.com/TylerHZZ/TemptationOfTrial.git
cd TemptationOfTrial
```

### 2. Prepare the Environment
1. Ensure MATLAB is installed on your system (R2018b or later recommended)
2. Place all project files in the same directory (maintain the provided folder structure)
3. Verify sprite files (`retro_cards.png`, `retro_pack.png`, etc.) are in the `resources/images` directory

### 3. Run the Game
1. Open MATLAB and navigate to the project directory
2. In the MATLAB Command Window, execute the main script:
   ```matlab
   Whole.m
   ```
3. The game will launch with a title screen—click anywhere to start your adventure

## 📂 Project Structure
```
TemptationOfTrial/
├── code/
│   └── matlab/
│       ├── Whole.m                # Main entry point (launches the full game)
│       ├── simpleGameEngine.m     # Core game engine (handles rendering/input)
│       ├── preview.m              # Preview script for testing components
│       ├── SGE_demo.mlx           # Demo notebook for engine usage
│       ├── world1_forest.m        # Forest world scenario logic
│       ├── world2_brokenbridge.m  # Broken Bridge world scenario logic
│       └── world3_cave.m          # Cave world scenario logic
├── docs/
│   ├── Preview.docx               # Project preview documentation
│   ├── Preview.pdf                # PDF version of project preview
│   ├── design for each world and questions.pdf  # World design specs
│   └── SDP_Graphics_Preview_Au25.pdf           # Graphics design docs
├── resources/
│   ├── images/
│   │   ├── retro_blank.png        # Blank sprite template
│   │   ├── retro_cards.png        # Card-themed sprites
│   │   ├── retro_dice.png         # Dice sprites
│   │   ├── retro_pack.png         # UI/title screen sprites
│   │   └── retro_simple_dice.png  # Simplified dice sprites
│   └── archives/
│       └── retro_images.zip       # Compressed sprite backup
├── html/                          # Supplementary HTML resources
└── README.md                      # Project documentation (this file)
```

## 🔑 Core Features
- **Three Unique Worlds**: Forest, Broken Bridge, and Cave—each with distinct puzzles and visual styles
- **Retro Visuals**: Sprite-based graphics from curated retro-style sprite sheets for nostalgic appeal
- **Mouse Interaction**: Intuitive click-based controls powered by `simpleGameEngine`'s `getMouseInput()` function
- **Modular Design**: Separate scripts for each world enable easy expansion or modification of scenarios
- **Educational Value**: Demonstrates MATLAB OOP principles, sprite handling, and interactive program development

## 🎮 Gameplay Introduction
1. **Startup**: Launch via `Whole.m` and click the title screen to begin
2. **World Navigation**: Progress through three sequential worlds, each presenting unique trials
3. **Interaction**: Use mouse clicks to interact with in-game elements (solve puzzles, navigate paths)
4. **Objective**: Overcome challenges in each world to complete the full trial experience

## 📌 Development & Extension Guidelines
### Modify Existing Worlds
1. Edit the corresponding world script (e.g., `world1_forest.m`) to adjust puzzle logic or visuals
2. Update sprite references by modifying the sprite array configurations in the script
3. Test changes using `preview.m` before integrating with the main game

### Add New Worlds
1. Create a new script (e.g., `world4_mountain.m`) following the structure of existing world files
2. Import additional sprites to `resources/images` and update the sprite loading logic
3. Register the new world in `Whole.m` to integrate it into the gameplay sequence

## 🐞 Troubleshooting
- **Sprite Loading Errors**: Ensure sprite files are in the correct `resources/images` directory and file paths in scripts are accurate
- **Engine Initialization Issues**: Verify `simpleGameEngine.m` is in the project directory and MATLAB version supports OOP
- **Mouse Input Not Working**: Confirm no other MATLAB windows are active during gameplay—click the game window to activate input

## 📄 License
This project is intended for educational purposes. All sprite assets and engine components are used with permission for non-commercial use. See individual documentation files for specific asset licenses.

## 🙏 Acknowledgments
- The `simpleGameEngine` development team for providing the core rendering and input handling framework
- Curators of the retro-style sprite sheets used in the game's visual design
- Educational resources supporting MATLAB game development and OOP principles
