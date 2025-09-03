state("Titanfall") {
    // Gets the Training level index. The first one is the correct level index and the second is related to the level index which is used to trigger the final split.
    int levelIndex : "client.dll", 0x16BC71C;
    int levelIndexPointer : "client.dll", 0x00AD1D48, 0x28, 0xC0, 0xB8, 0xF0, 0x68, 0x40, 0x8;

    // A memory address that work with the start of the 100% Training levels
    int Training100StartValue : "engine.dll", 0x20099A8;
    
    // titan
    int titanTrainingStartValue : "engine.dll", 0x2EB6B80;

}

startup {
    print(" -------------------- TF1 Autosplitter starting -------------------- ");
    vars.prevIndex = -1;
    vars.prevTraining100StartValue = -1;
    vars.prevtitanTrainingStartValue = -1;
    vars.finalTrainingIndex = 13;
    vars.PilotFinalTrainingIndex = 9;

    // --- Category selection using parent-child settings ---
    settings.Add("category", true, "Select Category (choose one; defaults to 100% Training if multiple or none selected)");
    settings.SetToolTip("category", "Pick exactly one category for this run.");

    settings.Add("cat100", true, "100% Training", "category");
    settings.Add("catPilot", false, "Pilot", "category");
    settings.Add("catTitan", false, "Titan", "category");
}

init {
    print(" -------------------- TF1 Autosplitter Initialize -------------------- ");
    int selected = (settings["cat100"] ? 1 : 0) +
               (settings["catPilot"] ? 1 : 0) +
               (settings["catTitan"] ? 1 : 0);

    if (selected >= 2) {
        settings["cat100"] = true;
        settings["catPilot"] = false;
        settings["catTitan"] = false;
    }
}

update {
    // Levels
    //print("Level Index: " + current.levelIndex);
    //print("Level Index Pointer: " + current.levelIndexPointer);

    // Start values
    //print("trainvalue: " + current.Training100StartValue);
    //print("trainvalue: " + current.titanTrainingStartValue);
}

split {
    bool shouldSplit = false;
    int category = 0; // default = 100% Training

    if (settings["cat100"]) category = 0;
    else if (settings["catPilot"]) category = 1;
    else if (settings["catTitan"]) category = 2;

    if (category == 0) { // 100% Training
        bool isFinalSplit = (current.levelIndex == vars.finalTrainingIndex) && (current.levelIndexPointer == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 0 && current.levelIndex > vars.prevIndex);
    }
    else if (category == 1) { // Pilot
        //Example: split on each mission start
        bool isFinalSplit = (current.levelIndex == vars.PilotFinalTrainingIndex) && (current.levelIndexPointer == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 0 && current.levelIndex > vars.prevIndex);
    }
    else if (category == 2) { // Titan
        // Example: final Titan split
        bool isFinalSplit = (current.levelIndex == vars.finalTrainingIndex) && (current.levelIndexPointer == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 10 && current.levelIndex > vars.prevIndex);
    }

    if (shouldSplit) {
        vars.prevIndex = current.levelIndex;
        return true;
    }

    // Keep prevIndex updated if increased
    if (current.levelIndex > vars.prevIndex) {
        vars.prevIndex = current.levelIndex;
    }

    return false;
}

start {
    bool started = false;
    int category = 0; // default = 100% Training
    if (settings["cat100"]) category = 0; 
    else if (settings["catPilot"]) category = 1;
    else if (settings["catTitan"]) category = 2;

    if (category == 0) { // 100% Training
        //print("100% Training Start");
        started = (vars.prevTraining100StartValue == 1063675494) && (current.Training100StartValue == 1056964608);
    }
    else if (category == 1) { // Pilot
        //print("Pilot Training Start");
        started = (current.titanTrainingStartValue == 858595429 && vars.prevtitanTrainingStartValue == 1935635566);
    }
    else if (category == 2) { // Titan
        //print("Titan Training Start");
        started = (current.titanTrainingStartValue == 875372645 && vars.prevtitanTrainingStartValue == 1935635566);
    } 

    vars.prevTraining100StartValue = current.Training100StartValue;
    vars.prevtitanTrainingStartValue = current.titanTrainingStartValue; 
    return started;
}