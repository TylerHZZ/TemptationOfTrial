% ==========================================================================
% Anti-Drug Themed Adventure Game (MATLAB Pixel-Style Implementation)
% Core Mechanic: Players make choices across 5 worlds to resist drug temptations;
% Wrong choices deplete health (hearts), and full depletion triggers game over.
% Supports restart/quit functionality after victory or defeat.
% ==========================================================================

clc; clear; close all;  % Clear command window, workspace, and all open figures

% ====================== Main Function: Game Entry Point =======================
function main()
    % ---------------------- Global Game Constants (Accessible to Nested Functions) ----------------------
    MAX_HEARTS = 5;          % Maximum health points (5 red hearts = full health)
    SPRITE_SHEET = 'retro_pack.png';  % Path to the pixel art sprite sheet (contains all game assets)
    SPRITE_SIZE = 16;        % Pixel dimensions of a single sprite (16x16 pixels per asset)
    ZOOM_FACTOR = 8;         % Zoom scale for sprites (enlarges 16x16 sprites to fit the window)
    BACKGROUND_COLOR = [0,0,0];  % Global game window background color (solid black)
    is_quit = false;         % Quit flag: terminates the main game loop when set to TRUE

    % Display start screen and wait for any key press to begin
    showStartScreen(BACKGROUND_COLOR);
    
    % ---------------------- Main Game Loop (Handles Restart/Quit Logic) ----------------------
    while ~is_quit
        % Reinitialize game state on each loop iteration (fixes state retention issues on restart)
        heart_blank_count = 0;  % Number of depleted hearts (0 = full health at loop start)
        % Initialize the custom game engine (loads sprites, handles input/rendering)
        scene = simpleGameEngine(SPRITE_SHEET, SPRITE_SIZE, SPRITE_SIZE, ZOOM_FACTOR, BACKGROUND_COLOR);
        
        % ---------------------- Run World 1: Forest (Vaping Temptations) ----------------------
        [heart_blank_count, is_dead] = runForestWorld(scene, heart_blank_count, MAX_HEARTS);
        if is_dead  % Check if health is fully depleted
            is_quit = gameOverHandler(BACKGROUND_COLOR);  % Trigger game over screen
            if is_quit  % If player chooses to quit, exit the main loop
                break;
            else  % If player chooses to restart, skip to next loop iteration
                continue;
            end
        end
        
        % ---------------------- Run World 2: Broken Bridge (Illegal Drug Temptations) ----------------------
        [heart_blank_count, is_dead] = runBrokenBridgeWorld(scene, heart_blank_count, MAX_HEARTS);
        if is_dead
            is_quit = gameOverHandler(BACKGROUND_COLOR);
            if is_quit
                break;
            else
                continue;
            end
        end
        
        % ---------------------- Run World 3: Cave (Academic Pressure Temptations) ----------------------
        [heart_blank_count, is_dead] = runCaveWorld(scene, heart_blank_count, MAX_HEARTS);
        if is_dead
            is_quit = gameOverHandler(BACKGROUND_COLOR);
            if is_quit
                break;
            else
                continue;
            end
        end
        
        % ---------------------- Run World 4: Illusion City (Prescription Pill Misuse) ----------------------
        [heart_blank_count, is_dead] = runCityOfIllusionsWorld(scene, heart_blank_count, MAX_HEARTS);
        if is_dead
            is_quit = gameOverHandler(BACKGROUND_COLOR);
            if is_quit
                break;
            else
                continue;
            end
        end
        
        % ---------------------- Run World 5: Mountains (Body Image & Natural Drug Myths) ----------------------
        [heart_blank_count, is_dead] = runMountainsWorld(scene, heart_blank_count, MAX_HEARTS);
        if is_dead
            is_quit = gameOverHandler(BACKGROUND_COLOR);
            if is_quit
                break;
            else
                continue;
            end
        end
        
        % ---------------------- Victory Screen (Triggered After All Worlds Cleared) ----------------------
        % Returns TRUE if player quits, FALSE if player chooses to restart
        is_quit = showVictoryScreen(heart_blank_count, MAX_HEARTS, BACKGROUND_COLOR);
        % Loop continues for restart (is_quit=FALSE) or terminates for quit (is_quit=TRUE)
    end
end

% ====================== Function: Game Start Screen (Initial Launch UI) =======================
function showStartScreen(background_color)
    % Create game window: set background color, position (x,y,width,height), and hide axes
    fig = figure('Color', background_color, 'Position', [100, 100, 800, 600]);
    ax = gca; ax.Visible = 'off';  % Disable axis rendering for clean UI
    
    % Draw game title (large, bold white text centered at top)
    text(0.5, 0.7, 'Anti-Drug Adventure', ...
         'Color', 'white', 'FontSize', 32, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');  % Use normalized coordinates (0-1) for responsive layout
    
    % Draw game introduction text (two-line gray subtitle)
    intro_text = ['Resist temptation, protect your health', char(10), 'Cross 5 worlds and make the right choices!'];
    text(0.5, 0.5, intro_text, ...
         'Color', [0.8, 0.8, 0.8], 'FontSize', 16, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    % Draw key press prompt (yellow text for visibility)
    text(0.5, 0.3, 'Press any key to start', ...
         'Color', 'yellow', 'FontSize', 14, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    waitforbuttonpress;  % Block execution until any key is pressed
    close(fig);  % Close the start screen and proceed to the main game
end

% ====================== Function: Game Over Handler (R=Restart/Q=Quit) =======================
function should_quit = gameOverHandler(background_color)
    should_quit = false;  % Default: assume player will restart
    close all;  % Close all active scene windows before showing game over UI
    
    % Create game over window (same size/position as start screen for consistency)
    fig = figure('Color', background_color, 'Position', [100, 100, 800, 600]);
    ax = gca; ax.Visible = 'off';
    
    % Draw game over title (large red text for emphasis)
    text(0.5, 0.6, 'YOU HAVE DIED', ...
         'Color', 'red', 'FontSize', 36, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    % Draw anti-drug educational message (white instructional text)
    text(0.5, 0.4, 'Your health is exhausted: Value healthy choices and stay away from dangerous temptations!', ...
         'Color', 'white', 'FontSize', 14, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    % Draw restart/quit prompt (light blue text for interactivity)
    text(0.5, 0.2, 'Press R to Restart | Press Q to Quit Game', ...
         'Color', [0.5, 0.7, 1.0], 'FontSize', 16, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    % ---------------------- Key Detection Loop (R/Q Only) ----------------------
    while true
        pause(0.05);  % Reduce CPU usage with small delay
        key = get(fig, 'CurrentKey');  % Get the currently pressed key
        
        % Restart: close game over window and return FALSE (main loop continues)
        if strcmp(key, 'r') || strcmp(key, 'R')
            close(fig);
            should_quit = false;
            return;
        % Quit: close all windows and return TRUE (main loop terminates)
        elseif strcmp(key, 'q') || strcmp(key, 'Q')
            close all;
            should_quit = true;
            return;
        end
    end
end

% ====================== Function: Victory Screen (Add Restart Option) =======================
function should_quit = showVictoryScreen(heart_blank_count, max_hearts, background_color)
    should_quit = false;  % Default: restart if no quit input
    remaining_hearts = max_hearts - heart_blank_count;  % Calculate surviving health
    
    % Create victory window (matching style of start/game over screens)
    fig = figure('Color', background_color, 'Position', [100, 100, 800, 600]);
    ax = gca; ax.Visible = 'off';
    
    % Draw victory title (gold/yellow text for celebration)
    text(0.5, 0.7, 'VICTORY!', ...
         'Color', [1.0, 0.84, 0.0], 'FontSize', 36, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    % ---------------------- Dynamic Victory Message (Based on Remaining Health) ----------------------
    if remaining_hearts == max_hearts  % Perfect run (no health lost)
        result_text = sprintf(['You successfully resisted all temptations!', char(10), ...
            'Remaining health: %d/%d', char(10), 'Perfect clearance: You have strong self-control!'], ...
            remaining_hearts, max_hearts);
    else  % Successful run with partial health loss
        result_text = sprintf(['You successfully resisted all temptations!', char(10), ...
            'Remaining health: %d/%d', char(10), 'Excellent performance: Healthy choices make a better you!'], ...
            remaining_hearts, max_hearts);
    end
    % Draw victory message (white text with health stats)
    text(0.5, 0.5, result_text, ...
         'Color', 'white', 'FontSize', 16, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    % Draw restart/quit prompt (consistent with game over screen for user familiarity)
    text(0.5, 0.2, 'Press R to Restart | Press Q to Quit Game', ...
         'Color', [0.5, 0.7, 1.0], 'FontSize', 16, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Units', 'normalized');
    
    % ---------------------- Key Detection Loop (R/Q Only) ----------------------
    while true
        pause(0.05);
        key = get(fig, 'CurrentKey');
        
        % Restart: close victory window and return FALSE
        if strcmp(key, 'r') || strcmp(key, 'R')
            close(fig);
            should_quit = false;
            return;
        % Quit: close all windows and return TRUE
        elseif strcmp(key, 'q') || strcmp(key, 'Q')
            close all;
            should_quit = true;
            return;
        end
    end
end

% ====================== Utility Function: Wait for 1/2 Key Input (Choice Mechanic) =======================
function choice = waitForKey12(scene_obj)
    choice = 0;  % Initialize choice to invalid value
    % Loop until valid input (1 or 2) is detected
    while true
        key = scene_obj.getKeyboardInput();  % Get input from custom game engine
        if strcmp(key, '1')  % Player selects option 1
            choice = 1; 
            return;
        elseif strcmp(key, '2')  % Player selects option 2
            choice = 2; 
            return;
        end
        pause(0.05);  % Reduce CPU load during input wait
    end
end

% =========================================================================
% World 1: Forest (Vaping & Nicotine Temptations)
% 3 Scenarios: Peer pressure to vape, bathroom vaping, nicotine misconception
% =========================================================================
function [updated_blank, is_dead] = runForestWorld(scene, current_blank, max_hearts)
    updated_blank = current_blank;  % Inherit current health state
    is_dead = false;  % Initialize death flag to FALSE
    
    % ---------------------- Sprite Frame Indices (Map to retro_pack.png) ----------------------
    % Terrain sprites
    trees1_fw = 36; trees2_fw = 69; sapling1_fw = 3; sapling2_fw = 2; grass1_fw = 65;
    % Character/entity sprites
    player_fw = 29; monsterForest_fw = 60;  % Monster = "Vapora" (vaping-themed enemy)
    % Health sprites
    red_heart_fw = 731; blank_heart_fw = 729;  % Red = full health, blank = depleted
    % UI text sprites (LIFE:)
    L_fw = 991; I_fw = 988; F_fw = 985; E_fw = 984; colon_fw = 958;
    % Scene grid dimensions (10x10 sprite grid)
    rows_fw = 10; cols_fw = 10;

    % Anonymous function to calculate text position (centered above the scene)
    computeTopCenter_fw = @() deal( ...
        (cols_fw/2)*scene.sprite_width*scene.zoom, ...
        (10.3)*scene.sprite_height*scene.zoom ...
    );

    % ---------------------- Scene 1.1: Friend Offers Vape (Peer Pressure) ----------------------
    figure;  % Create new figure for the scene
    % Generate base forest background (grass + trees)
    background1_fw = createForestBackground(rows_fw, cols_fw, trees1_fw, trees2_fw, grass1_fw);
    % Add interactive elements (player, monster, health UI, text sprites)
    background1_fw = fillForestElements(background1_fw, trees1_fw, trees2_fw, sapling1_fw, sapling2_fw, grass1_fw, ...
                                     red_heart_fw, L_fw, I_fw, F_fw, E_fw, colon_fw, monsterForest_fw, player_fw);
    % Update health display: replace red hearts with blank hearts for depleted health
    for i_fw = 1:current_blank
        heart_col_fw = 6 + i_fw - 1;  % Health UI starts at column 6 (LIFE: [hearts])
        if heart_col_fw <= 10, background1_fw(1, heart_col_fw) = blank_heart_fw; end
    end
    % Render the scene using the custom game engine
    drawScene(scene, background1_fw);
    ax1_fw = gca; title(ax1_fw, 'World 1: The Forest — Monster: Vapora', 'Color', 'white');
    % Calculate text position and draw scenario prompt/choices
    [text_x_fw, text_y_fw] = computeTopCenter_fw();
    text(ax1_fw, text_x_fw, text_y_fw, 'Your friends offer you a vape to "just try once."', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax1_fw, text_x_fw, text_y_fw + 50, 'Press 1: A. Say no and suggest another activity.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax1_fw, text_x_fw, text_y_fw + 100, 'Press 2: B. Try it to fit in.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    % Wait for player to choose 1/2
    choice1_fw = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: try vape)
    if choice1_fw == 2
        updated_blank = min(updated_blank + 1, max_hearts);  % Deplete 1 heart (capped at max)
        if updated_blank == max_hearts  % Check if health is fully depleted
            is_dead = true;
            close(gcf);  % Close current scene
            return;
        end
    end
    close(gcf);  % Close scene after choice is made

    % ---------------------- Scene 1.2: Vaping in School Bathroom (Observational Temptation) ----------------------
    figure;
    background2_fw = createForestBackground(rows_fw, cols_fw, trees1_fw, trees2_fw, grass1_fw);
    background2_fw = fillForestElements(background2_fw, trees1_fw, trees2_fw, sapling1_fw, sapling2_fw, grass1_fw, ...
                                     red_heart_fw, L_fw, I_fw, F_fw, E_fw, colon_fw, monsterForest_fw, player_fw);
    % Update health display
    for i_fw = 1:updated_blank
        heart_col_fw = 6 + i_fw - 1; background2_fw(1, heart_col_fw) = blank_heart_fw; end
    % Adjust player position for scene progression
    background2_fw(6,5) = player_fw; background2_fw(6,2) = grass1_fw;
    drawScene(scene, background2_fw);
    ax2_fw = gca; title(ax2_fw, 'World 1: The Forest — Monster: Vapora', 'Color','white');
    [text_x_fw, text_y_fw] = computeTopCenter_fw();
    text(ax2_fw, text_x_fw, text_y_fw, 'You see someone vaping in the school bathroom.', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax2_fw, text_x_fw, text_y_fw + 50, 'Press 1: A. Report it to a teacher or counselor.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax2_fw, text_x_fw, text_y_fw + 100, 'Press 2: B. Join them to see what it''s like.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice2_fw = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: join in)
    if choice2_fw == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 1.3: Nicotine Misconception (Educational True/False) ----------------------
    figure;
    background3_fw = createForestBackground(rows_fw, cols_fw, trees1_fw, trees2_fw, grass1_fw);
    background3_fw = fillForestElements(background3_fw, trees1_fw, trees2_fw, sapling1_fw, sapling2_fw, grass1_fw, ...
                                     red_heart_fw, L_fw, I_fw, F_fw, E_fw, colon_fw, monsterForest_fw, player_fw);
    % Update health display
    for i_fw = 1:updated_blank
        heart_col_fw = 6 + i_fw - 1; background3_fw(1, heart_col_fw) = blank_heart_fw; end
    % Adjust player position for final scene of the world
    background3_fw(6,7) = player_fw; background3_fw(6,[2,5]) = grass1_fw;
    drawScene(scene, background3_fw);
    ax3_fw = gca; title(ax3_fw, 'World 1: The Forest — Monster: Vapora', 'Color', 'white');
    [text_x_fw, text_y_fw] = computeTopCenter_fw();
    text(ax3_fw, text_x_fw, text_y_fw, '"Nicotine helps people focus better long-term."', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax3_fw, text_x_fw, text_y_fw + 50, 'Press 1: False — It harms focus and memory.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax3_fw, text_x_fw, text_y_fw + 100, 'Press 2: True — It helps you stay calm and focused.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice3_fw = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: believe the myth)
    if choice3_fw == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close all;  % Close all scene windows before moving to next world
end

% ---------------------- Helper: Fill Forest Scene with Interactive Elements ----------------------
function background_fw = fillForestElements(background_fw, trees1_fw, trees2_fw, sapling1_fw, sapling2_fw, grass1_fw, ...
                                         red_heart_fw, L_fw, I_fw, F_fw, E_fw, colon_fw, monsterForest_fw, player_fw)
    % Add terrain details (trees, saplings, grass)
    background_fw(4,[2,5,7]) = trees1_fw; background_fw(5,[3,6]) = trees2_fw;
    background_fw(6,[1,9]) = sapling1_fw; background_fw(7,[4,8]) = sapling2_fw;
    background_fw(8:9,1:10) = grass1_fw;
    % Add health UI (LIFE: + 5 red hearts)
    background_fw(1, 6:10) = red_heart_fw;
    background_fw(1, [1:4]) = [L_fw, I_fw, F_fw, E_fw]; background_fw(1,5) = colon_fw;
    % Add player and monster positions
    background_fw(6,10) = monsterForest_fw; background_fw(6,2) = player_fw;
end

% ---------------------- Helper: Create Base Forest Background (Terrain Only) ----------------------
function background_fw = createForestBackground(rows_fw, cols_fw, trees1_fw, trees2_fw, grass1_fw)
    background_fw = ones(rows_fw, cols_fw) * grass1_fw;  % Base layer = grass
    % Add tree rows (alternating tree1/tree2 for visual variety)
    for r = 2:3
        for c = 1:cols_fw
            if mod(c,2)==0  % Even columns = tree1
                background_fw(r,c) = trees1_fw;
            else  % Odd columns = tree2
                background_fw(r,c) = trees2_fw;
            end
        end
    end
end

% =========================================================================
% World 2: Broken Bridge (Illegal Drug Temptations)
% 3 Scenarios: Skip class for drugs, friend with addiction, post-argument drug offer
% =========================================================================
function [updated_blank, is_dead] = runBrokenBridgeWorld(scene, current_blank, max_hearts)
    updated_blank = current_blank; 
    is_dead = false;
    
    % ---------------------- Sprite Frame Indices ----------------------
    % Terrain sprites (water, broken bridge planks, lilypads)
    water_bb = 169; broken1_bb = 177; broken2_bb = 178; lilypad_bb = 206;
    % Character/entity sprites (monster = "Toxikon" (drug-themed enemy))
    player_bb = 29; monster_bb = 286;
    % Health/UI sprites (same as World 1 for consistency)
    red_heart_bb = 731; blank_heart_bb = 729;
    L_bb = 991; I_bb = 988; F_bb = 985; E_bb = 984; colon_bb = 958;
    % Scene grid dimensions
    rows_bb = 10; cols_bb = 10;

    % Calculate centered text position (reusable for all scenes in this world)
    computeTopCenter_bb = @() deal( ...
        (cols_bb/2)*scene.sprite_width*scene.zoom, ...
        (10.3)*scene.sprite_height*scene.zoom ...
    );

    % ---------------------- Scene 2.1: Friend Pressures to Skip Class for Drugs ----------------------
    figure;
    background1_bb = createBrokenBridgeBackground(rows_bb, cols_bb, water_bb);  % Base = water
    background1_bb = fillBrokenBridgeElements(background1_bb, broken1_bb, broken2_bb, lilypad_bb, water_bb, ...
                                             red_heart_bb, L_bb, I_bb, F_bb, E_bb, colon_bb, monster_bb, player_bb);
    % Update health display
    for i_bb = 1:updated_blank
        heart_col_bb = 6 + i_bb - 1;
        if heart_col_bb <= 10, background1_bb(1, heart_col_bb) = blank_heart_bb; end
    end
    drawScene(scene, background1_bb);
    ax1_bb = gca; title(ax1_bb, 'World 2: The Broken Bridge — Monster: Toxikon', 'Color', 'white');
    [text_x_bb, text_y_bb] = computeTopCenter_bb();
    text(ax1_bb, text_x_bb, text_y_bb, 'A friend pressures you to skip class and use drugs.', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax1_bb, text_x_bb, text_y_bb + 50, 'Press 1: A. Refuse and explain why it''s not worth it.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax1_bb, text_x_bb, text_y_bb + 100, 'Press 2: B. Go along to keep them happy.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice1_bb = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: comply)
    if choice1_bb == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 2.2: Friend Struggling with Addiction (Intervention Choice) ----------------------
    figure;
    background2_bb = createBrokenBridgeBackground(rows_bb, cols_bb, water_bb);
    background2_bb = fillBrokenBridgeElements(background2_bb, broken1_bb, broken2_bb, lilypad_bb, water_bb, ...
                                             red_heart_bb, L_bb, I_bb, F_bb, E_bb, colon_bb, monster_bb, player_bb);
    for i_bb = 1:updated_blank
        heart_col_bb = 6 + i_bb - 1; background2_bb(1, heart_col_bb) = blank_heart_bb; end
    background2_bb(6,5) = player_bb; background2_bb(6,2) = water_bb;  % Adjust player position
    drawScene(scene, background2_bb);
    ax2_bb = gca; title(ax2_bb, 'World 2: The Broken Bridge — Monster: Toxikon', 'Color','white');
    [text_x_bb, text_y_bb] = computeTopCenter_bb();
    text(ax2_bb, text_x_bb, text_y_bb, 'You see a friend struggling with addiction.', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax2_bb, text_x_bb, text_y_bb + 50, 'Press 1: A. Encourage them to get help.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax2_bb, text_x_bb, text_y_bb + 100, 'Press 2: B. Ignore it.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice2_bb = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: ignore addiction)
    if choice2_bb == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 2.3: Post-Argument Drug Offer (Emotional Temptation) ----------------------
    figure;
    background3_bb = createBrokenBridgeBackground(rows_bb, cols_bb, water_bb);
    background3_bb = fillBrokenBridgeElements(background3_bb, broken1_bb, broken2_bb, lilypad_bb, water_bb, ...
                                             red_heart_bb, L_bb, I_bb, F_bb, E_bb, colon_bb, monster_bb, player_bb);
    for i_bb = 1:updated_blank
        heart_col_bb = 6 + i_bb - 1; background3_bb(1, heart_col_bb) = blank_heart_bb; end
    background3_bb(6,7) = player_bb; background3_bb(6,[2,5]) = water_bb;  % Final player position
    drawScene(scene, background3_bb);
    ax3_bb = gca; title(ax3_bb, 'World 2: The Broken Bridge — Monster: Toxikon', 'Color','white');
    [text_x_bb, text_y_bb] = computeTopCenter_bb();
    text(ax3_bb, text_x_bb, text_y_bb, 'After an argument someone says, "This will calm you down."', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax3_bb, text_x_bb, text_y_bb + 50, 'Press 1: No. Find healthy coping methods.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax3_bb, text_x_bb, text_y_bb + 100, 'Press 2: Yes.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice3_bb = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: use drugs to cope)
    if choice3_bb == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close all;
end

% ---------------------- Helper: Fill Broken Bridge Scene Elements ----------------------
function background_bb = fillBrokenBridgeElements(background_bb, broken1_bb, broken2_bb, lilypad_bb, water_bb, ...
                                                  red_heart_bb, L_bb, I_bb, F_bb, E_bb, colon_bb, monster_bb, player_bb)
    % Add broken bridge planks (5-7 rows = bridge structure)
    background_bb(5,:) = [broken1_bb, broken2_bb, broken1_bb, broken2_bb, broken1_bb, broken2_bb, broken2_bb, broken1_bb, broken2_bb, broken1_bb];
    background_bb(6,:) = [broken2_bb, broken1_bb, broken2_bb, broken1_bb, broken2_bb, broken1_bb, broken1_bb, broken2_bb, broken1_bb, broken2_bb];
    background_bb(7,:) = [broken1_bb, broken1_bb, broken2_bb, broken2_bb, broken1_bb, broken2_bb, broken1_bb, broken2_bb, broken1_bb, broken2_bb];
    % Add lilypads (visual detail for water)
    background_bb(5,[3,8]) = lilypad_bb; background_bb(6,[2,9]) = lilypad_bb; background_bb(7,5) = lilypad_bb;
    % Add health UI (same as World 1)
    background_bb(1,6:10) = red_heart_bb;
    background_bb(1, [1:4]) = [L_bb, I_bb, F_bb, E_bb]; background_bb(1,5) = colon_bb;
    % Add player and monster
    background_bb(6,10) = monster_bb; background_bb(6,2) = player_bb;
end

% ---------------------- Helper: Create Base Broken Bridge Background ----------------------
function background_bb = createBrokenBridgeBackground(rows_bb, cols_bb, water_bb)
    background_bb = ones(rows_bb, cols_bb) * water_bb;  % Base layer = water (bridge over river)
end

% =========================================================================
% World 3: Cave (Academic Pressure & Substance Misuse)
% 3 Scenarios: Schoolwork overwhelm, "one hit won't hurt" myth, test failure discouragement
% =========================================================================
function [updated_blank, is_dead] = runCaveWorld(scene, current_blank, max_hearts)
    updated_blank = current_blank; 
    is_dead = false;
    
    % ---------------------- Sprite Frame Indices ----------------------
    % Cave terrain (wall filler, rocks, walls, rails)
    wall_fill = 1; rock = 555; wall = 417; rail = 102; brokerail = 103;
    % Character/entity sprites (monsters = "Tensora" (stress-themed enemies))
    player = 29; dirt = 402; dirt2 = 481; dirt3 = 482;
    % Health/UI sprites
    red_heart = 731; blank_heart = 729;
    L = 991; I = 988; F = 985; E = 984; colon = 958;
    monster1 = 223; monster2 = 221; monster3 = 219;
    % Scene grid dimensions
    rows = 10; cols = 10;

    computeTopCenter = @() deal( ...
        (cols/2)*scene.sprite_width*scene.zoom, ...
        (10.3)*scene.sprite_height*scene.zoom ...
    );

    % ---------------------- Scene 3.1: Overwhelmed by Schoolwork (Stress Temptation) ----------------------
    figure;
    background1 = createCaveBackground(rows, cols, wall_fill, wall, rock);  % Base = cave walls/rocks
    background1 = fillScene1Elements(background1, rail, brokerail, player, dirt, dirt2, dirt3, red_heart, L, I, F, E, colon, monster1, monster2, monster3);
    % Update health display
    for i = 1:updated_blank
        heart_col = 6 + i - 1;
        if heart_col <= 10, background1(1, heart_col) = blank_heart; end
    end
    drawScene(scene, background1);
    ax1 = gca; title(ax1, 'World 3: The Cave — Monster: Tensora', 'Color', 'white');
    [text_x, text_y] = computeTopCenter();
    text(ax1, text_x, text_y, 'You are overwhelmed by schoolwork.', 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    text(ax1, text_x, text_y + 50, 'Press 1: A. Talk to a counselor or organize your schedule.', 'Color', 'white', 'FontSize', 10, 'HorizontalAlignment', 'center');
    text(ax1, text_x, text_y + 100, 'Press 2: B. Use substances to calm yourself.', 'Color', 'white', 'FontSize', 10, 'HorizontalAlignment', 'center');
    choice1 = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: use substances to cope with stress)
    if choice1 == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 3.2: Classmate's "One Hit Won't Hurt" Myth (Peer Misinformation) ----------------------
    figure;
    background2 = createCaveBackground(rows, cols, wall_fill, wall, rock);
    background2 = fillScene1Elements(background2, rail, brokerail, player, dirt, dirt2, dirt3, red_heart, L, I, F, E, colon, monster1, monster2, monster3);
    for i = 1:updated_blank
        heart_col = 6 + i - 1;
        if heart_col <= 10, background2(1, heart_col) = blank_heart; end
    end
    background2(6,5) = player; background2(6,2) = wall_fill;  % Adjust player position
    drawScene(scene, background2);
    ax2 = gca; title(ax2, 'World 3: The Cave — Monster: Tensora', 'Color', 'white');
    [text_x, text_y] = computeTopCenter();
    text(ax2, text_x, text_y, 'A classmate says "Just one hit cannot affect your brain long-term"', 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    text(ax2, text_x, text_y + 50, 'Press 1: A. Use relaxation or talk to supportive friends.', 'Color', 'white', 'FontSize', 10, 'HorizontalAlignment', 'center');
    text(ax2, text_x, text_y + 100, 'Press 2: B. Try it "just once."', 'Color', 'white', 'FontSize', 10, 'HorizontalAlignment', 'center');
    choice2 = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: believe the myth)
    if choice2 == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 3.3: Discouraged After Failing a Test (Giving Up Temptation) ----------------------
    figure;
    background3 = createCaveBackground(rows, cols, wall_fill, wall, rock);
    background3 = fillScene1Elements(background3, rail, brokerail, player, dirt, dirt2, dirt3, red_heart, L, I, F, E, colon, monster1, monster2, monster3);
    for i = 1:updated_blank
        heart_col = 6 + i - 1;
        if heart_col <= 10, background3(1, heart_col) = blank_heart; end
    end
    background3(6,7) = player; background3(6,[2,5]) = wall_fill;  % Final player position
    drawScene(scene, background3);
    ax3 = gca; title(ax3, 'World 3: The Cave — Monster: Tensora', 'Color', 'white');
    [text_x, text_y] = computeTopCenter();
    text(ax3, text_x, text_y, 'You failed a test and feel discouraged.', 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    text(ax3, text_x, text_y + 50, 'Press 1: A. Learn from it and try again.', 'Color', 'white', 'FontSize', 10, 'HorizontalAlignment', 'center');
    text(ax3, text_x, text_y + 100, 'Press 2: B. Give up.', 'Color', 'white', 'FontSize', 10, 'HorizontalAlignment', 'center');
    choice3 = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: give up)
    if choice3 == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close all;
end

% ---------------------- Helper: Fill Cave Scene Elements ----------------------
function background = fillScene1Elements(background, rail, brokerail, player, dirt, dirt2, dirt3, red_heart, L, I, F, E, colon, monster1, monster2, monster3)
    % Add cave details (rails, dirt patches)
    background(7,[2,3,5]) = rail; background(7,[4,6]) = brokerail;
    background(6,2) = player;
    background(5,[1,5,7,8]) = dirt; background(8,[2,3,9,10]) = dirt;
    background(5,[2,9,10]) = dirt2; background(8,[4,9]) = dirt2;
    background(7,[1,9]) = dirt3;
    % Add health UI
    background(1, 6:10) = red_heart;
    background(1, [1:4]) = [L, I, F, E]; background(1,5) = colon;
    % Add multiple monsters (stress-themed enemies)
    background(6,5) = monster3; background(6,7) = monster2; background(6,10) = monster1;
end

% ---------------------- Helper: Create Base Cave Background ----------------------
function background = createCaveBackground(rows, cols, wall_fill, wall, rock)
    background = ones(rows, cols) * wall_fill;  % Base = wall filler
    % Add wall/rock rows (target rows = 2-4, 8-10 for cave structure)
    target_rows = [2:4, 8:10];
    for r = target_rows
        for c = 1:cols
            if mod(c,2)==1  % Odd columns = wall
                background(r, c) = wall;
            else  % Even columns = rock
                background(r, c) = rock;
            end
        end
    end
end

% =========================================================================
% World 4: Illusion City (Prescription Pill Misuse & Exam Pressure)
% 3 Scenarios: Adderall for focus, unlabeled pills in friend's bag, exam pill misuse
% =========================================================================
function [updated_blank, is_dead] = runCityOfIllusionsWorld(scene, current_blank, max_hearts)
    updated_blank = current_blank; 
    is_dead = false;
    
    % ---------------------- Sprite Frame Indices ----------------------
    % City terrain (road, buildings, sidewalk)
    road_4w = 136; building1_4w = 339; building2_4w = 609; sidewalk_4w = 87;
    % Character/entity sprites (monster = "Pillax" (pill misuse enemy))
    player_4w = 29; monster_4w = 93;
    % Health/UI sprites
    red_heart_4w = 731; blank_heart_4w = 729;
    L_4w = 991; I_4w = 988; F_4w = 985; E_4w = 984; colon_4w = 958;
    % Scene grid dimensions
    rows_4w = 10; cols_4w = 10;

    computeTopCenter_4w = @() deal( ...
        (cols_4w/2)*scene.sprite_width*scene.zoom, ...
        (10.3)*scene.sprite_height*scene.zoom ...
    );

    % ---------------------- Scene 4.1: Offered Adderall for Focus (Academic Performance Temptation) ----------------------
    figure;
    background1_4w = createCityBackground(rows_4w, cols_4w, road_4w, building1_4w, building2_4w, sidewalk_4w);  % Base = cityscape
    background1_4w = fillCityElements(background1_4w, road_4w, building1_4w, building2_4w, sidewalk_4w, ...
                                     red_heart_4w, L_4w, I_4w, F_4w, E_4w, colon_4w, monster_4w, player_4w);
    % Update health display
    for i_4w = 1:updated_blank
        heart_col_4w = 6 + i_4w - 1;
        if heart_col_4w <= 10, background1_4w(1, heart_col_4w) = blank_heart_4w; end
    end
    drawScene(scene, background1_4w);
    ax1_4w = gca; title(ax1_4w, 'World 4: The City of Illusions — Monster: Pillax', 'Color', 'white');
    [text_x_4w, text_y_4w] = computeTopCenter_4w();
    text(ax1_4w, text_x_4w, text_y_4w, 'Someone offers you Adderall to "help you focus."', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax1_4w, text_x_4w, text_y_4w + 50, 'Press 1: A. Refuse and talk to your doctor about focus issues.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax1_4w, text_x_4w, text_y_4w + 100, 'Press 2: B. Take it for a quick boost.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice1_4w = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: misuse Adderall)
    if choice1_4w == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 4.2: Found Unlabeled Pills in Friend's Bag (Curiosity Temptation) ----------------------
    figure;
    background2_4w = createCityBackground(rows_4w, cols_4w, road_4w, building1_4w, building2_4w, sidewalk_4w);
    background2_4w = fillCityElements(background2_4w, road_4w, building1_4w, building2_4w, sidewalk_4w, ...
                                     red_heart_4w, L_4w, I_4w, F_4w, E_4w, colon_4w, monster_4w, player_4w);
    for i_4w = 1:updated_blank
        heart_col_4w = 6 + i_4w - 1; background2_4w(1, heart_col_4w) = blank_heart_4w; end
    background2_4w(6,5) = player_4w; background2_4w(6,2) = road_4w;  % Adjust player position
    drawScene(scene, background2_4w);
    ax2_4w = gca; title(ax2_4w, 'World 4: The City of Illusions — Monster: Pillax', 'Color','white');
    [text_x_4w, text_y_4w] = computeTopCenter_4w();
    text(ax2_4w, text_x_4w, text_y_4w, 'You find pills in a friend''s bag without labels.', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax2_4w, text_x_4w, text_y_4w + 50, 'Press 1: A. Leave them and tell a trusted adult.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax2_4w, text_x_4w, text_y_4w + 100, 'Press 2: B. Try one to see what it does.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice2_4w = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: experiment with unlabeled pills)
    if choice2_4w == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 4.3: Exam Pressure Pill Misuse (Performance Anxiety) ----------------------
    figure;
    background3_4w = createCityBackground(rows_4w, cols_4w, road_4w, building1_4w, building2_4w, sidewalk_4w);
    background3_4w = fillCityElements(background3_4w, road_4w, building1_4w, building2_4w, sidewalk_4w, ...
                                     red_heart_4w, L_4w, I_4w, F_4w, E_4w, colon_4w, monster_4w, player_4w);
    for i_4w = 1:updated_blank
        heart_col_4w = 6 + i_4w - 1; background3_4w(1, heart_col_4w) = blank_heart_4w; end
    background3_4w(6,7) = player_4w; background3_4w(6,[2,5]) = road_4w;  % Final player position
    drawScene(scene, background3_4w);
    ax3_4w = gca; title(ax3_4w, 'World 4: The City of Illusions — Monster: Pillax', 'Color','white');
    [text_x_4w, text_y_4w] = computeTopCenter_4w();
    text(ax3_4w, text_x_4w, text_y_4w, 'You feel pressured during exams.', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax3_4w, text_x_4w, text_y_4w + 50, 'Press 1: No. Healthy coping works better.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax3_4w, text_x_4w, text_y_4w + 100, 'Press 2: Yes. Use random pills to stay awake.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice3_4w = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: use random pills for exams)
    if choice3_4w == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close all;
end

% ---------------------- Helper: Fill City Scene Elements ----------------------
function background_4w = fillCityElements(background_4w, road_4w, building1_4w, building2_4w, sidewalk_4w, ...
                                         red_heart_4w, L_4w, I_4w, F_4w, E_4w, colon_4w, monster_4w, player_4w)
    % Add health UI (consistent with prior worlds)
    background_4w(1, 6:10) = red_heart_4w;
    background_4w(1, [1:4]) = [L_4w, I_4w, F_4w, E_4w]; background_4w(1,5) = colon_4w;
    % Add player and monster positions
    background_4w(6,10) = monster_4w;
    background_4w(6,2) = player_4w;
end

% ---------------------- Helper: Create Base City Background ----------------------
function background_4w = createCityBackground(rows_4w, cols_4w, road_4w, building1_4w, building2_4w, sidewalk_4w)
    background_4w = ones(rows_4w, cols_4w) * road_4w;  % Base layer = road
    % Add building rows (2-4 rows = city skyline)
    for r = 2:4
        for c = 1:cols_4w
            if mod(c,2)==0  % Even columns = building1
                background_4w(r,c) = building1_4w;
            else  % Odd columns = building2
                background_4w(r,c) = building2_4w;
            end
        end
    end
    % Add sidewalk (8-9 rows = pedestrian area)
    background_4w(8:9,1:10) = sidewalk_4w;
end

% =========================================================================
% World 5: Mountains (Body Image & Natural Drug Myths)
% 3 Scenarios: Body image insecurity, natural drug safety myth, "drugs make you cool" peer pressure
% =========================================================================
function [updated_blank, is_dead] = runMountainsWorld(scene, current_blank, max_hearts)
    updated_blank = current_blank; 
    is_dead = false;
    
    % ---------------------- Sprite Frame Indices ----------------------
    % Mountain terrain (snow, mountain peaks, rocks)
    snow_5w = 215; mountain1_5w = 757; mountain2_5w = 643; rock_5w = 52;
    % Character/entity sprites (monster = "Vainor" (body image/envy enemy))
    player_5w = 29; monster_5w = 93;
    % Health/UI sprites
    red_heart_5w = 731; blank_heart_5w = 729;
    L_5w = 991; I_5w = 988; F_5w = 985; E_5w = 984; colon_5w = 958;
    % Scene grid dimensions
    rows_5w = 10; cols_5w = 10;

    computeTopCenter_5w = @() deal( ...
        (cols_5w/2)*scene.sprite_width*scene.zoom, ...
        (10.3)*scene.sprite_height*scene.zoom ...
    );

    % ---------------------- Scene 5.1: Body Image Insecurity (Weight Loss Temptation) ----------------------
    figure;
    background1_5w = createMountainBackground(rows_5w, cols_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w);  % Base = snowy mountains
    background1_5w = fillMountainElements(background1_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w, ...
                                         red_heart_5w, L_5w, I_5w, F_5w, E_5w, colon_5w, monster_5w, player_5w);
    % Update health display
    for i_5w = 1:updated_blank
        heart_col_5w = 6 + i_5w - 1;
        if heart_col_5w <= 10, background1_5w(1, heart_col_5w) = blank_heart_5w; end
    end
    drawScene(scene, background1_5w);
    ax1_5w = gca; title(ax1_5w, 'World 5: The Mountains — Monster: Vainor', 'Color', 'white');
    [text_x_5w, text_y_5w] = computeTopCenter_5w();
    text(ax1_5w, text_x_5w, text_y_5w, 'You''re insecure about your body image.', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax1_5w, text_x_5w, text_y_5w + 50, 'Press 1: A. Eat healthy and focus on your strengths.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax1_5w, text_x_5w, text_y_5w + 100, 'Press 2: B. Use substances to lose weight fast.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice1_5w = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: use substances for weight loss)
    if choice1_5w == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 5.2: Natural Drug Safety Myth (Educational True/False) ----------------------
    figure;
    background2_5w = createMountainBackground(rows_5w, cols_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w);
    background2_5w = fillMountainElements(background2_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w, ...
                                         red_heart_5w, L_5w, I_5w, F_5w, E_5w, colon_5w, monster_5w, player_5w);
    for i_5w = 1:updated_blank
        heart_col_5w = 6 + i_5w - 1; background2_5w(1, heart_col_5w) = blank_heart_5w; end
    background2_5w(6,5) = player_5w; background2_5w(6,2) = 1;  % Adjust player position
    drawScene(scene, background2_5w);
    ax2_5w = gca; title(ax2_5w, 'World 5: The Mountains — Monster: Vainor', 'Color','white');
    [text_x_5w, text_y_5w] = computeTopCenter_5w();
    text(ax2_5w, text_x_5w, text_y_5w, '⚠️ True or False: "Natural drugs or herbs are always safe."', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax2_5w, text_x_5w, text_y_5w + 50, 'Press 1: False. Many can be harmful.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax2_5w, text_x_5w, text_y_5w + 100, 'Press 2: True. They''re natural so safe.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice2_5w = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: believe natural = safe myth)
    if choice2_5w == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close(gcf);

    % ---------------------- Scene 5.3: "Drugs Make You Cool" Peer Pressure (Social Acceptance Temptation) ----------------------
    figure;
    background3_5w = createMountainBackground(rows_5w, cols_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w);
    background3_5w = fillMountainElements(background3_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w, ...
                                         red_heart_5w, L_5w, I_5w, F_5w, E_5w, colon_5w, monster_5w, player_5w);
    for i_5w = 1:updated_blank
        heart_col_5w = 6 + i_5w - 1; background3_5w(1, heart_col_5w) = blank_heart_5w; end
    background3_5w(6,7) = player_5w; background3_5w(6,[2,5]) = 1;  % Final player position
    drawScene(scene, background3_5w);
    ax3_5w = gca; title(ax3_5w, 'World 5: The Mountains — Monster: Vainor', 'Color','white');
    [text_x_5w, text_y_5w] = computeTopCenter_5w();
    text(ax3_5w, text_x_5w, text_y_5w, 'A friend says drugs make you "cool."', ...
         'Color','white','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(ax3_5w, text_x_5w, text_y_5w + 50, 'Press 1: A. Say no and build real confidence.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    text(ax3_5w, text_x_5w, text_y_5w + 100, 'Press 2: B. Try them to fit in.', ...
         'Color','white','FontSize',10,'HorizontalAlignment','center');
    choice3_5w = waitForKey12(scene);
    % Penalty for wrong choice (Option 2: use drugs to fit in)
    if choice3_5w == 2
        updated_blank = min(updated_blank + 1, max_hearts);
        if updated_blank == max_hearts
            is_dead = true;
            close(gcf);
            return;
        end
    end
    close all;
end

% ---------------------- Helper: Fill Mountain Scene Elements ----------------------
function background_5w = fillMountainElements(background_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w, ...
                                             red_heart_5w, L_5w, I_5w, F_5w, E_5w, colon_5w, monster_5w, player_5w)
    % Add health UI
    background_5w(1, 6:10) = red_heart_5w;
    background_5w(1, [1:4]) = [L_5w, I_5w, F_5w, E_5w]; background_5w(1,5) = colon_5w;
    % Add player and monster positions
    background_5w(6,10) = monster_5w;
    background_5w(6,2) = player_5w;
    background_5w(6,[1,3:9]) = 1;  % Clear path for player movement
end

% ---------------------- Helper: Create Base Mountain Background ----------------------
function background_5w = createMountainBackground(rows_5w, cols_5w, snow_5w, mountain1_5w, mountain2_5w, rock_5w)
    background_5w = ones(rows_5w, cols_5w) * snow_5w;  % Base layer = snow
    % Add mountain/rock rows (2-5 rows = mountain range)
    for r = 2:5
        for c = 1:cols_5w
            if mod(c,3)==0  % Columns divisible by 3 = mountain1
                background_5w(r,c) = mountain1_5w;
            elseif mod(c,3)==1  % Columns mod 3 =1 = mountain2
                background_5w(r,c) = mountain2_5w;
            else  % Remaining columns = rock
                background_5w(r,c) = rock_5w;
            end
        end
    end
end

% Execute the main function to start the game
main();