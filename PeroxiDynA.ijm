Dialog.create("Image Preprocessing Options");

// 1. Ask user to assign each role to a channel
Dialog.addChoice("Channel for NUC:", newArray("C1", "C2", "C3"), "C1");
Dialog.addChoice("Channel for PO:",  newArray("C1", "C2", "C3"), "C2");
Dialog.addChoice("Channel for CYT:", newArray("C1", "C2", "C3"), "C3");

// 2. Duplicate nuclear channel as cytosol
Dialog.addCheckbox("Duplicate nuclear channel as cytosol?", false);

// 3. Subtract Background parameters
Dialog.addNumber("Rolling ball radius (Subtract Background):", 6);

// 4. Median filter radius nucleus
Dialog.addNumber("Median filter radius nuc (pixels):", 3);

// 5. Median filter radius cytoplasm
Dialog.addNumber("Median filter radius cyt (pixels):", 12);

Dialog.show();

// Get user input
channelNUC = Dialog.getChoice(); // example: "C1"
channelPO = Dialog.getChoice(); // example: "C2"
channelCYT  = Dialog.getChoice(); // example: "C3"

duplicateNuclear = Dialog.getCheckbox();
rollingBall = Dialog.getNumber();
medianRadiusNuc = Dialog.getNumber();
medianRadiusCyt = Dialog.getNumber();


run("Split Channels");

function renameChannel(channelPrefix, newName) {
   titles = getList("image.titles"); 
    for (i = 0; i < titles.length; i++) {
        if (startsWith(titles[i], channelPrefix)) {
            selectWindow(titles[i]);
            rename(newName);
            return;
        }
    }
    print("Channel not found: " + channelPrefix);
}

// Rename channels
renameChannel(channelNUC, "nuc");
renameChannel(channelPO, "po");

if (duplicateNuclear) {
    // Duplicate NUC as CYT
    selectWindow("nuc");
    run("Duplicate...", "title=cyt");
} else {
    renameChannel(channelCYT, "cyt");
}

titles = getList("image.titles");
for (i = 0; i < titles.length; i++) {
    name = titles[i];
    if (!(name == "nuc" || name == "cyt" || name == "po")) {
        selectWindow(name);
        close();
    }
}

selectWindow("po");
run("Duplicate...", "title=po-1");
run("Subtract Background...", "radius=" + rollingBall);
setAutoThreshold("Default dark");
run("Threshold...");
setOption("BlackBackground", true);
call("ij.plugin.frame.ThresholdAdjuster.setMode", "B&W");
resetThreshold;
waitForUser("Select & Apply", "manual default threshold");
close("Threshold");
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Median...", "radius=" + medianRadiusNuc);
setAutoThreshold("Otsu dark");
run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask");
close("Threshold");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=" + medianRadiusCyt);
setAutoThreshold("Default dark");
run("Threshold...");
setOption("BlackBackground", true);
resetThreshold;
waitForUser("Select & Apply", "manual threshold");
setTool("freehand");
waitForUser("selection", "outline the cell");
run("Clear Outside");
selectWindow("po-1");
rename("1-po");
selectWindow("cyt");
rename("2-cyt");
selectWindow("nuc");
rename("3-nuc");
run("Images to Stack", "use keep");
close("2-cyt");
close("nuc-1");
close("1-po");
selectWindow("po");
rename("all-po");
selectWindow("cyt-1");
rename("all-cyt");
selectWindow("3-nuc");
rename("all-nuc");

selectWindow("Stack");
stackTitle = getTitle();
numSlices = nSlices();

poSlice = -1;
cytSlice = -1;
nucSlice = -1;

for (i = 1; i <= numSlices; i++) {
    setSlice(i);
    label = getMetadata("Label");
    
    if (label == "1-po") poSlice = i;
    if (label == "2-cyt") cytSlice = i;
    if (label == "3-nuc") nucSlice = i;
}

if (poSlice != -1 && cytSlice != -1 && nucSlice != -1) {
    slicesToExtract = "" + poSlice + "," + cytSlice + "," + nucSlice;
    run("Make Substack...", "slices=" + slicesToExtract);
} else {
    showMessage("Error", "One or more target slices (po/cyt/nuc) not found.");
}

setOption("ScaleConversions", true);
run("8-bit");
run("Convert to Mask", "background=Dark calculate black");
close("Stack");
setTool("wand");
setSlice(2);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(3);
run("Create Selection");
run("Previous Slice [<]");
run("Previous Slice [<]");
run("Clear", "slice");
run("Stack to Images");
selectWindow("3-nuc");
run("Convert to Mask");
selectWindow("1-po");
run("Convert to Mask");
selectWindow("2-cyt");
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("1-po");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
baseDir = getDirectory("Choose a folder to save all outputs");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
selectWindow("3-nuc");
run("Create Selection");
run("Measure");
selectWindow("2-cyt");
run("Create Selection");
run("Measure");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
selectWindow("2-cyt");
run("Select All");
run("Invert");
selectWindow("3-nuc");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("1-po");
run("Set Measurements...", "area min redirect=[EDM of 3-nuc] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
imageCalculator("Subtract create", "EDM of 3-nuc","2-cyt");
selectWindow("Result of EDM of 3-nuc");
setTool("freehand");
waitForUser("selection", "outline the cell");
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
filename = getString("Enter a name for the stack (no extension)", "Stack");
fullPath = baseDir + filename + ".tif";
saveAs("Tiff", fullPath);
run("Close");
close("1-po");
close("3-nuc");
close("Result of EDM of 3-nuc");
close("EDM of 3-nuc");
close("2-cyt");
selectWindow("all-po");
rename("po");
selectWindow("all-cyt");
rename("cyt");
selectWindow("all-nuc");
rename("nuc");


for (i = 1; i < 10; i++) {
selectWindow("po");
run("Duplicate...", "title=po-1");
run("Subtract Background...", "radius=" + rollingBall);
setAutoThreshold("Default dark");
run("Threshold...");
resetThreshold;
waitForUser("Select & Apply", "manual default threshold");
close("Threshold");
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=" + medianRadiusCyt);
setAutoThreshold("Default dark");
run("Threshold...");
setOption("BlackBackground", true);
resetThreshold;
waitForUser("Select & Apply", "manual threshold");
setTool("freehand");
waitForUser("selection", "outline the cell");
run("Clear Outside");
selectWindow("cyt");
rename("2-cyt");
selectWindow("nuc");
rename("3-nuc");
selectWindow("po-1");
rename("1-po");
run("Images to Stack", "use keep");
close("2-cyt");
close("nuc-1");
close("1-po");
selectWindow("cyt-1");
rename("all-cyt");
selectWindow("3-nuc");
rename("all-nuc");
selectWindow("po");
rename("all-po");

selectWindow("Stack");
stackTitle = getTitle();
numSlices = nSlices();

poSlice = -1;
cytSlice = -1;
nucSlice = -1;

for (i = 1; i <= numSlices; i++) {
    setSlice(i);
    label = getMetadata("Label");
    
    if (label == "1-po") poSlice = i;
    if (label == "2-cyt") cytSlice = i;
    if (label == "3-nuc") nucSlice = i;
}

if (poSlice != -1 && cytSlice != -1 && nucSlice != -1) {
    slicesToExtract = "" + poSlice + "," + cytSlice + "," + nucSlice;
    run("Make Substack...", "slices=" + slicesToExtract);
} else {
    showMessage("Error", "One or more target slices (po/cyt/nuc) not found.");
}

setOption("ScaleConversions", true);
run("8-bit");
run("Convert to Mask", "background=Dark calculate black");
close("Stack");
setTool("wand");
setSlice(2);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(3);
run("Create Selection");
run("Previous Slice [<]");
run("Previous Slice [<]");
run("Clear", "slice");
run("Stack to Images");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("1-po");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
selectWindow("3-nuc");
run("Create Selection");
run("Measure");
selectWindow("2-cyt");
run("Create Selection");
run("Measure");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
selectWindow("2-cyt");
run("Select All");
run("Invert");
selectWindow("3-nuc");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("1-po");
run("Set Measurements...", "area min redirect=[EDM of 3-nuc] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
imageCalculator("Subtract create", "EDM of 3-nuc","2-cyt");
selectWindow("Result of EDM of 3-nuc");
setTool("freehand");
waitForUser("selection", "outline the cell");
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
selectWindow("Results");
filename = getString("Enter a name for the table (no extension)", "Results");
fullPath = baseDir + filename + ".csv";
saveAs("Results", fullPath);
close("Results");
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
filename = getString("Enter a name for the stack (no extension)", "Stack");
fullPath = baseDir + filename + ".tif";
saveAs("Tiff", fullPath);
run("Close");
close("1-po");
close("3-nuc");
close("Result of EDM of 3-nuc");
close("EDM of 3-nuc");
close("2-cyt");
selectWindow("all-po");
rename("po");
selectWindow("all-cyt");
rename("cyt");
selectWindow("all-nuc");
rename("nuc");
}
