# PeroxiDynA - Tool for Peroxisome Dynamics' Analyses in ImageJ

## ABOUT THIS TOOL
PeroxiDynA (Peroxisome Dynamics’ Analyses) is a tool for ImageJ that enables the quantification of peroxisome number and spatial distribution in mammalian cultured cells from 2D confocal/super-resolution microscopy images. This tool was developed by Vanessa Ferreira in the Virus-Host Cell Interactions laboratory at University of Aveiro, while trying to study peroxisome dynamics in adherent mammalian cells. 

## APPLICATIONS
- Determination of peroxisomes’ area and predicted diameter
- Analysis of peroxisome spatial localization within a single cell
- Assessment of peroxisome abundance in cells

## IMAGING REQUIREMENTS

- Image resolution must be sufficient to enable analysis (retrieved from confocal or super-resolution microscopy).
- For image acquisition, two channels are required: one for peroxisome staining and another for nuclear staining. An additional channel for cytoplasmic/plasma membrane staining may be included but is optional. If only the peroxisome and nuclear channels are available, the user must indicate in the first pop-up window of the macro that the nuclear staining will also be used for the cytoplasm-related processing.
- Supported image formats include .lsm, .tiff, and other file types compatible with ImageJ. If the native image format from the microscope is not supported by ImageJ, users should convert their images to .tiff files prior to running the macro. This conversion can be performed using the microscope’s acquisition software or with Fiji. 


## NOTES

To accurately measure peroxisome dynamics with this macro, consider the following:

- Limit the number of cells per image to facilitate accurate processing of cellular dynamics (e.g.  6 A549 cells per image). Users should optimize this number based on their specific samples.
- Ensure consistent and high-quality sample preparation and image acquisition conditions. This includes maintaining identical laser settings across images, avoiding excessive laser power that may lead to overexposure in the peroxisome channel, and ensuring sufficient signal in the nuclear channel to allow automatic nuclear threshold detection by the macro.
- During acquisition, select the same focal plane across different cells by imaging them at their center Z-plane.
- Use an appropriate number of cells per condition to account for their inherent heterogeneity of peroxisomes and to ensure accurate representation of the cell population.
- Peroxisome and cytoplasm channels are always duplicates so that you can use the original images as references for thresholding. Please watch the video for visualization of the workflow.


## INSTALLATION

You should have ImageJ installed. 
1. Download the file denominated “PeroxiDynA.ijm”
2. Go to the ImageJ app folder in your computer. 
3. Move the file “PeroxiDynA.ijm” to “plugins”. 
4. Start ImageJ
5. Select “Plugins”, then select “Install”, go to the folder from step 3 and click on “PeroxiDynA.ijm”.

## RUN

1. Open ImageJ
2. Open an image to process
3. Go to “Analyze”, click on “Set Scale…”, and enter “µm” in the “Unit of Length” field [Note: this step is only required the first time you use the software]
4. Select “Plugins” and click on “PeroxiDynA”


## FAQ

1. What is the first pop-up window?
This window prompts you to select the channels corresponding to each target structure in your image (peroxisomes, nuclei, and optionally cytoplasm). You will also be asked whether the nuclei channel should be used for cytoplasmic measurements. Additionally, you can set values for background subtraction in the peroxisome channel and define the median filter radius for the cytoplasm and nuclei channels. If left unmodified, default values will be applied. Default values were optimized based on confocal images, please refer to the publication below for detailed acquisition settings.

2. Why am I prompted to select a folder?
The selected folder will be used to automatically save all output files generated during the analysis (tables and images). You will only need to assign a name to each file afterwards.

4. Which files am I saving?
For each analyzed cell, the following files will be saved in sequence: 
	- a results table with peroxisome parameters in the target cell
	- a results table with cytoplasm and nucleus parameters in the target cell
	- a results table with the spatial localization of each peroxisome in the target cell
	- a results table with the maximum length (MAX) for the target cell
	- a stack image of the segmented target cell

## MANUAL STEPS OF THE MACRO
- Insert informations in the first pop-up window
- Define a threshold for peroxisomes for the target cell
- Define a threshold for the cytoplasm for the same target cell as above
- Save files (please read FAQ)


## CODE 

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

