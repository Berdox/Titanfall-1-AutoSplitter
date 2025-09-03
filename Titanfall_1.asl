// state("Titanfall") {
//     // Gets the Training level index. The first one is the correct level index and the second is related to the level index which is used to trigger the final split.
//      int levelIndex : "client.dll", 0x16BC71C;
//      int levelIndex2 : "client.dll", 0x00AD1D48, 0x28, 0xC0, 0xB8, 0xF0, 0x68, 0x40, 0x8;

//     // A memory address that work with the start of the 100% Training levels
//      int startTrainingValue : "engine.dll", 0x20099A8;
// }

// startup {
//     print(" -------------------- TF1 Autosplitter starting -------------------- ");
//     vars.prevIndex = -1;
//     vars.preStartTrainingValue = -1;
//     vars.FINAL_INDEX = 13;
// // --- Category selection using parent-child settings ---
//     settings.Add("category", true, "Select Category (choose one; defaults to 100% Training if multiple or none selected)");
//     settings.SetToolTip("category", "Pick exactly one category for this run.");

//     settings.Add("cat100", true, "100% Training", "category");
//     settings.Add("catPilot", false, "Pilot", "category");
//     settings.Add("catTitan", false, "Titan", "category");

//     // --- Enforce that exactly one category is selected silently ---
//     int selected = ((bool)settings["cat100"] ? 1 : 0) +
//                    ((bool)settings["catPilot"] ? 1 : 0) +
//                    ((bool)settings["catTitan"] ? 1 : 0);

//     if (selected != 1) {
//         settings["cat100"] = true;
//         settings["catPilot"] = false;
//         settings["catTitan"] = false;
//     }
// }

// init {
//     print(" -------------------- TF1 Autosplitter Initilize -------------------- ");
//     vars.prevIndex = current.levelIndex;
// }

// update {
//     //print("Level Index: " + current.levelIndex);
//     //print("Level Index2: " + current.levelIndex2);
//     //print("trainvalue: " + current.startTrainingValue);
// }

// split {
//     // --- Final Split ---
//     // Trigger only when at the last level *and* the extra condition is met
//     if (current.levelIndex == vars.FINAL_INDEX && current.levelIndex2 == -2) {
//         //print("Final split triggered!");
//         vars.prevIndex = current.levelIndex;
//         return true;
//     }

//     // --- Normal Splits ---
//     // Split only when the index increases above 0
//     bool shouldSplit = (current.levelIndex > 0) && (current.levelIndex > vars.prevIndex);

//     //if (shouldSplit) {
//     //    print("Normal split triggered at index " + current.levelIndex);
//     //}

//     // Update prevIndex after the checks
//     vars.prevIndex = current.levelIndex;

//     return shouldSplit;
// }

// start {
//     // Checks the PreStart and CurrentStart values with certain numbers to trigger the timer start
//     bool started = (vars.preStartTrainingValue == 1063675494 && current.startTrainingValue == 1056964608);

//     // update after checking
//     vars.preStartTrainingValue = current.startTrainingValue;
    
//     return started;
// }

// state("Titanfall") {
//     // Tracks training level progression
//     int levelIndex     : "client.dll", 0x16BC71C;
//     int levelIndex2    : "client.dll", 0x00AD1D48, 0x28, 0xC0, 0xB8, 0xF0, 0x68, 0x40, 0x8;

//     // Value used to detect the start of 100% Training levels
//     int trainingStartValue : "engine.dll", 0x20099A8;
// }

// startup {
//     print(" -------------------- TF1 Autosplitter starting -------------------- ");

//     vars.prevIndex = -1;
//     vars.prevTrainingStartValue = -1;
//     vars.finalTrainingIndex = 13;

//     // Dropdown menu for categories (single choice)
//     // 0 = 100% Training, 1 = Pilot, 2 = Titan
//     // Create dropdown setting for category
// // Add category settings as radio-style booleans
// settings.Add("cat100", true, "100% Training", "category");
// settings.Add("catPilot", false, "Pilot", "category");
// settings.Add("catTitan", false, "Titan", "category");

// }

// init {
//     print(" -------------------- TF1 Autosplitter Initialize -------------------- ");
//     vars.prevIndex = current.levelIndex;
// }

// update {
//     // Uncomment for debug
//     // print("Level Index: " + current.levelIndex);
//     // print("Level Index2: " + current.levelIndex2);
//     // print("TrainingStart: " + current.trainingStartValue);
// }

// split {
//     bool shouldSplit = false;
//     int category = (int)settings["category"];

//     if (category == 0) { // 100% Training
//         bool isFinalSplit = (current.levelIndex == vars.finalTrainingIndex && current.levelIndex2 == -2);
//         shouldSplit = (isFinalSplit || (current.levelIndex > 0 && current.levelIndex > vars.prevIndex));
//     }
//     else if (category == 1) { // Pilot
//         // Example: split on each mission start
//         shouldSplit = (current.levelIndex > vars.prevIndex);
//     }
//     else if (category == 2) { // Titan
//         // Example: final Titan split
//         bool isFinalTitanSplit = (current.levelIndex == 20 && current.levelIndex2 == -99); 
//         shouldSplit = (isFinalTitanSplit || (current.levelIndex > vars.prevIndex));
//     }

//     if (shouldSplit) {
//         vars.prevIndex = current.levelIndex;
//         return true;
//     }

//     // Keep prevIndex updated if increased
//     if (current.levelIndex > vars.prevIndex) {
//         vars.prevIndex = current.levelIndex;
//     }

//     return false;
// }

// start {
//     bool started = false;
//     int category = (int)settings["category"];

//     if (category == 0) { // 100% Training
//         started = (
//             vars.prevTrainingStartValue == 1063675494 &&
//             current.trainingStartValue == 1056964608
//         );
//     }
//     else if (category == 1) { // Pilot
//         started = (current.levelIndex == 1 && vars.prevIndex == 0);
//     }
//     else if (category == 2) { // Titan
//         started = (current.levelIndex == 5 && vars.prevIndex == 4);
//     }

//     vars.prevTrainingStartValue = current.trainingStartValue;
//     return started;
// }

state("Titanfall") {
    // Gets the Training level index. The first one is the correct level index and the second is related to the level index which is used to trigger the final split.
     int levelIndex : "client.dll", 0x16BC71C;
     int levelIndex2 : "client.dll", 0x00AD1D48, 0x28, 0xC0, 0xB8, 0xF0, 0x68, 0x40, 0x8;

    // A memory address that work with the start of the 100% Training levels
     int startTrainingValue : "engine.dll", 0x20099A8;
}

startup {
    print(" -------------------- TF1 Autosplitter starting -------------------- ");
    vars.prevIndex = -1;
    vars.preStartTrainingValue = -1;
    vars.finalTrainingIndex = 13;

    // --- Category selection using parent-child settings ---
    settings.Add("category", true, "Select Category (choose one; defaults to 100% Training if multiple or none selected)");
    settings.SetToolTip("category", "Pick exactly one category for this run.");

    settings.Add("cat100", true, "100% Training", "category");
    settings.Add("catPilot", false, "Pilot", "category");
    settings.Add("catTitan", false, "Titan", "category");

    // --- Enforce that exactly one category is selected silently ---
    int selected = 1; //((bool)settings["cat100"] ? 1 : 0) + ((bool)settings["catPilot"] ? 1 : 0) + ((bool)settings["catTitan"] ? 1 : 0);

    if (selected != 1) {
        settings["cat100"] = true;
        settings["catPilot"] = false;
        settings["catTitan"] = false;
    }
}

init {
    print(" -------------------- TF1 Autosplitter Initialize -------------------- ");
    //vars.prevIndex = current.levelIndex;
}

update {
    //print("Level Index: " + current.levelIndex);
    //print("Level Index2: " + current.levelIndex2);
    //print("trainvalue: " + current.startTrainingValue);
}

split {
    bool shouldSplit = false;
    int category = 0; // default = 100% Training

    if (settings["cat100"]) category = 0;
    else if (settings["catPilot"]) category = 1;
    else if (settings["catTitan"]) category = 2;

    if (category == 0) { // 100% Training
        bool isFinalSplit = (current.levelIndex == vars.finalTrainingIndex) && (current.levelIndex2 == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 0 && current.levelIndex > vars.prevIndex);
    }
    else if (category == 1) { // Pilot
        //Example: split on each mission start
        shouldSplit = (current.levelIndex > vars.prevIndex);
    }
    else if (category == 2) { // Titan
        // Example: final Titan split
        bool isFinalSplit = (current.levelIndex == vars.finalTrainingIndex) && (current.levelIndex2 == -2);
        shouldSplit = isFinalSplit || (current.levelIndex > 0 && current.levelIndex > vars.prevIndex);
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
        started = (vars.preStartTrainingValue == 1063675494) && (current.startTrainingValue == 1056964608);
    }
    else if (category == 1) { // Pilot
        started = (current.levelIndex == 1 && vars.prevIndex == 0);
    }
    else if (category == 2) { // Titan
        started = (current.levelIndex == 5 && vars.prevIndex == 4);
    } 

    vars.preStartTrainingValue = current.startTrainingValue;
    return started;
}