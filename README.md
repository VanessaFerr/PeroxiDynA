# PeroxiDynA - Tool for Peroxisome Dynamics' Analyses in ImageJ

## ABOUT THIS TOOL
PeroxiDynA (Peroxisome Dynamics’ Analyses) is a tool for ImageJ that enables the quantification of peroxisome number and spatial distribution in mammalian cultured cells from 2D confocal/super-resolution microscopy images. This tool was developed by Vanessa Ferreira in the Virus-Host Cell Interactions laboratory at University of Aveiro, while trying to study peroxisome dynamics in adherent mammalian cells. 

## APPLICATIONS
- Determination of peroxisomes’ area and predicted diameter
- Analysis of peroxisome spatial localization within a single cell

## NOTES

To accurately measure peroxisome dynamics with this macro, consider the following:

- Image resolution must be sufficient to enable analysis (retrieved from confocal or super-resolution microscopy).
- Ensure good conditions during sample preparation and image acquisition (e.g. equal laser parameters between different images; do not use exaggerated laser power that lead to overexposure in the peroxisome channel).
- During acquisition, select the same focal plane among the different cells.
- Use an appropriate number of replicates per condition to accurately represent the cell population, due to peroxisomes’ heterogeneity.

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
3. Select “Plugins” and click on “PeroxiDynA”

## EDIT

This macro was developed and optimized for MacOS. For Windows, the stacks are formed in a different order, therefore, please change the numbering of the peroxisomes and the nuclei channels in the corresponding coding lines.

1. Open ImageJ, select “Plugins” – “Macros” – “Edit” and edit the lines of the macro. 

For example, substitute the code lines 37 to 43 in the original script with the following code:

setSlice(3); </br> 
run(“Create Selection”); </br> 
run(“Clear Outside”; “stack”); </br> 
setSlice(1); </br> 
run(“Create Selection”); </br> 
run(“Next Slice [>]”); </br> 
run(“Next Slice [>]”); </br> 
run(“Next Slice [>]”); </br> 
run(“Clear”; “slice”); </br> 

## CODE 

run("Split Channels"); </br> 
run("Duplicate...", "title=nuc"); </br> 
waitForUser [select cytoplasm channel] </br> 
rename("cyt"); </br> 
waitForUser [select PO channel] </br> 
rename("po"); </br> 
selectWindow("po"); </br> 
run("Duplicate...", "title=po-1") </br> 
run("Subtract Background...", "rolling=6"); </br> 
waitForUser [select manual threshold via “Default” and apply] </br> 
run("Watershed"); </br> 
run("Convert to Mask"); </br> 
selectWindow("nuc"); </br> 
run("Median...", "radius=3"); </br> 
setAutoThreshold("Otsu dark"); </br> 
//run("Threshold..."); </br> 
waitForUser [select manual threshold via “Otsu” and apply] </br> 
run("Convert to Mask"); </br> 
run("Duplicate...", "title=nuc-1"); </br> 
selectWindow("cyt"); </br> 
run("Duplicate...", "title=cyt-1"); </br> 
selectWindow("cyt"); </br> 
run("Median...", "radius=12"); </br> 
waitForUser [select cell by hand, clear outside; and select manual threshold via “Otsu” and apply] </br> 
run("Images to Stack", "use keep"); </br> 
close("cyt") </br> 
close("nuc-1") </br> 
close("po-1") </br> 
selectWindow("cyt-1") </br> 
rename("all-cyt") </br> 
selectWindow("nuc") </br> 
rename("all-nuc") </br> 
selectWindow("po") </br> 
rename("all-po") </br> 
selectWindow("Stack"); </br> 
//setTool("wand"); </br> 
setSlice(2); [adapt coding line for Windows – start here] </br> 
run("Create Selection");  </br> 
run("Clear Outside", "stack"); </br> 
setSlice(3); </br> 
run("Create Selection"); </br> 
run("Next Slice [>]"); </br> 
run("Clear", "slice"); [adapt coding line for Windows – stop here] </br> 
run("Stack to Images"); </br> 
close("cyt-1") </br> 
close("po") </br> 
close("nuc") </br> 
selectWindow("nuc-1") </br> 
run("Convert to Mask"); </br> 
selectWindow("po-1") </br> 
run("Convert to Mask"); </br> 
selectWindow("cyt") </br> 
run("Convert to Mask"); </br> 
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3"); </br> 
selectWindow("po-1"); </br> 
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear"); </br> 
waitForUser; [save results] </br> 
close("Results") </br> 
selectWindow("nuc-1"); </br> 
run("Create Selection"); </br> 
run("Measure"); </br> 
selectWindow("cyt"); </br> 
run("Create Selection"); </br> 
run("Measure"); </br> 
waitForUser [save results] </br> 
close("Results") </br> 
selectWindow("cyt"); </br> 
run("Images to Stack", "use keep"); </br> 
selectWindow("Stack"); </br> 
run("RGB Color"); </br> 
waitForUser [save image] </br> 
close("Stack"); </br> 
close("po-1"); </br> 
close("nuc-1"); </br> 
close("cyt") </br> 
selectWindow("all-po") </br> 
rename("po") </br> 
selectWindow("all-cyt") </br> 
rename("cyt") </br> 
selectWindow("all-nuc") </br> 
rename("nuc") </br> 
