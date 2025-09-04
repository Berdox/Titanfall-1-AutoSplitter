state("Titanfall") {
    // Gets the Training level index. The first one is the correct level index and 
    // the second one is related to the level index which is used to trigger the final split.
    int levelIndex : "client.dll", 0x16BC71C;
    int levelIndexPointer : "client.dll", 0x00AD1D48, 0x28, 0xC0, 0xB8, 0xF0, 0x68, 0x40, 0x8;

    // A memory address that work with the start of the 100% Training levels
    int Training100StartValue : "engine.dll", 0x20099A8;
    
    // pilot and titan starting values
    int pilotTitanTrainingStartValue : "engine.dll", 0x2EB6B80;

    // Four Reset values so false positive don't happen
    int resetValue : "engine.dll", 0x229F5D0; //  4096
    int resetValue2 : "engine.dll", 0x229EE94; // 27136
    int resetValue3 : "engine.dll", 0x229F4EC; // 22784
    int resetValue4 : "engine.dll", 0x229EE8C; // 13439

}

startup {
    print(" -------------------- TF1 Autosplitter Starting Up -------------------- ");

    // Variables
    vars.prevLevelIndex = -1;
    vars.prevTraining100StartValue = -1;
    vars.prevPilotTitanTrainingStartValue = -1;

    // Constants
    vars.FINAL_TRAINING_INDEX = 13;
    vars.PILOT_FINAL_TRAINING_INDEX = 9;

    // Category selection using parent-child settings
    settings.Add("category", true, "Select Category (choose one)");
    settings.SetToolTip("category", "Pick exactly one category for this run.");

    settings.Add("cat100", true, "100% Training", "category");
    settings.Add("catPilot", false, "Pilot", "category");
    settings.Add("catTitan", false, "Titan", "category");
}

init {
    print(" -------------------- TF1 Autosplitter Initialize -------------------- ");
}

update {
    // Levels
    //print("Level Index: " + current.levelIndex);
    //print("Level Pre-Index: " + vars.prevLevelIndex);
    //print("Level Index Pointer: " + current.levelIndexPointer);

    // Start values
    //print("trainvalue: " + current.Training100StartValue);
    //print("trainvalue: " + current.pilotTitanTrainingStartValue);
}

split {
    bool shouldSplit = false;

    // check for split
    if (settings["cat100"]) { // 100% Training
        bool isFinalSplit = (current.levelIndex == vars.FINAL_TRAINING_INDEX) &&
                            (current.levelIndexPointer == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 0 && current.levelIndex > vars.prevLevelIndex);
    }
    else if (settings["catPilot"]) { // Pilot
        bool isFinalSplit = (current.levelIndex == vars.PILOT_FINAL_TRAINING_INDEX) &&
                            (current.levelIndexPointer == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 0 && current.levelIndex > vars.prevLevelIndex);
    }
    else if (settings["catTitan"]) { // Titan
        bool isFinalSplit = (current.levelIndex == vars.FINAL_TRAINING_INDEX) &&
                           (current.levelIndexPointer == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 10 && current.levelIndex > vars.prevLevelIndex);
    }

    // update prevLevelIndex after split
    if (shouldSplit) {
        vars.prevLevelIndex = current.levelIndex;
        return true;
    }

    return shouldSplit;
}

start {
    bool started = false;
    if (settings["cat100"]) { // 100% Training
        //print("100% Training Start");
        started = (current.Training100StartValue == 1056964608 && vars.prevTraining100StartValue == 1063675494);
        //Sets the value of preLevelIndex for the splits
        if (started) vars.prevLevelIndex = 0;
    }
    else if (settings["catPilot"]) { // Pilot
        //print("Pilot Training Start");
        started = (current.pilotTitanTrainingStartValue == 858595429 && vars.prevPilotTitanTrainingStartValue == 1935635566);
        //Sets the value of preLevelIndex for the splits
        if (started) vars.prevLevelIndex = 0;
    }
    else if (settings["catTitan"]) { // Titan
        //print("Titan Training Start");
        started = (current.pilotTitanTrainingStartValue == 875372645 && vars.prevPilotTitanTrainingStartValue == 1935635566);
        //Sets the value of preLevelIndex for the splits
        if (started) vars.prevLevelIndex = 10;
    } 

    vars.prevTraining100StartValue = current.Training100StartValue;
    vars.prevPilotTitanTrainingStartValue = current.pilotTitanTrainingStartValue; 
    return started;
}

reset {
    // Values at the main menu that the auto splitter looks for to reset
    if (current.resetValue  == 4096  &&
        current.resetValue2 == 27136 &&
        current.resetValue3 == 22784 &&
        current.resetValue4 == 13439) {
        return true;
    }
}