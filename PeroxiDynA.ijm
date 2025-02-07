run("Split Channels");
run("Duplicate...", "title=nuc");
waitForUser
rename("cyt");
waitForUser
rename("po");
selectWindow("po");
run("Duplicate...", "title=po-1")
run("Subtract Background...", "rolling=6");
waitForUser
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Median...", "radius=3");
setAutoThreshold("Otsu dark");
//run("Threshold...");
waitForUser
run("Convert to Mask");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=12");
waitForUser
run("Images to Stack", "use keep");
close("cyt")
close("nuc-1")
close("po-1")
selectWindow("cyt-1")
rename("all-cyt")
selectWindow("nuc")
rename("all-nuc")
selectWindow("po")
rename("all-po")
selectWindow("Stack");
//setTool("wand");
setSlice(2);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(3)
run("Create Selection");
run("Next Slice [>]");
run("Clear", "slice");
run("Stack to Images");
close("cyt-1")
close("po")
close("nuc")
selectWindow("nuc-1")
run("Convert to Mask");
selectWindow("po-1")
run("Convert to Mask");
selectWindow("cyt")
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("po-1");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
waitForUser;
close("Results")
selectWindow("nuc-1");
run("Create Selection");
run("Measure");
selectWindow("cyt");
run("Create Selection");
run("Measure");
waitForUser
close("Results")
selectWindow("cyt");
run("Select All");
run("Invert");
selectWindow("nuc-1");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("po-1");
run("Set Measurements...", "area min redirect=[EDM of nuc-1] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
waitForUser
close("Results")
imageCalculator("Subtract create", "EDM of nuc-1","cyt");
selectWindow("Result of EDM of nuc-1");
waitForUser
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
waitForUser
close("Results")
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
waitForUser
close("Stack");
close("po-1");
close("nuc-1");
close("Result of EDM of nuc-1");
close("EDM of nuc-1");
close("cyt")
selectWindow("all-po")
rename("po")
selectWindow("all-cyt")
rename("cyt")
selectWindow("all-nuc")
rename("nuc")

selectWindow("po");
run("Duplicate...", "title=po-1")
run("Subtract Background...", "rolling=6");
waitForUser
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=12");
waitForUser
run("Convert to Mask");
run("Images to Stack", "use keep");
close("cyt")
close("nuc-1")
close("po-1")
selectWindow("cyt-1")
rename("all-cyt")
selectWindow("nuc")
rename("all-nuc")
selectWindow("po")
rename("all-po")
selectWindow("Stack");
//setTool("wand");
setSlice(3);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(2)
run("Create Selection");
run("Next Slice [>]");
run("Next Slice [>]");
run("Clear", "slice");
run("Stack to Images");
close("cyt-1")
close("po")
close("nuc")
selectWindow("nuc-1")
run("Convert to Mask");
selectWindow("po-1")
run("Convert to Mask");
selectWindow("cyt")
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("po-1");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
waitForUser;
close("Results")
selectWindow("nuc-1");
run("Create Selection");
run("Measure");
selectWindow("cyt");
run("Create Selection");
run("Measure");
waitForUser
close("Results")
selectWindow("cyt");
run("Select All");
run("Invert");
selectWindow("nuc-1");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("po-1");
run("Set Measurements...", "area min redirect=[EDM of nuc-1] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
waitForUser
close("Results")
imageCalculator("Subtract create", "EDM of nuc-1","cyt");
selectWindow("Result of EDM of nuc-1");
waitForUser
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
waitForUser
close("Results")
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
waitForUser
close("Stack");
close("po-1");
close("nuc-1");
close("Result of EDM of nuc-1");
close("EDM of nuc-1");
close("cyt")
selectWindow("all-po")
rename("po")
selectWindow("all-cyt")
rename("cyt")
selectWindow("all-nuc")
rename("nuc")

selectWindow("po");
run("Duplicate...", "title=po-1")
run("Subtract Background...", "rolling=6");
waitForUser
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=12");
waitForUser
run("Convert to Mask");
run("Images to Stack", "use keep");
close("cyt")
close("nuc-1")
close("po-1")
selectWindow("cyt-1")
rename("all-cyt")
selectWindow("nuc")
rename("all-nuc")
selectWindow("po")
rename("all-po")
selectWindow("Stack");
//setTool("wand");
setSlice(3);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(2)
run("Create Selection");
run("Next Slice [>]");
run("Next Slice [>]");
run("Clear", "slice");
run("Stack to Images");
close("cyt-1")
close("po")
close("nuc")
selectWindow("nuc-1")
run("Convert to Mask");
selectWindow("po-1")
run("Convert to Mask");
selectWindow("cyt")
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("po-1");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
waitForUser;
close("Results")
selectWindow("nuc-1");
run("Create Selection");
run("Measure");
selectWindow("cyt");
run("Create Selection");
run("Measure");
waitForUser
close("Results")
selectWindow("cyt");
run("Select All");
run("Invert");
selectWindow("nuc-1");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("po-1");
run("Set Measurements...", "area min redirect=[EDM of nuc-1] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
waitForUser
close("Results")
imageCalculator("Subtract create", "EDM of nuc-1","cyt");
selectWindow("Result of EDM of nuc-1");
waitForUser
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
waitForUser
close("Results")
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
waitForUser
close("Stack");
close("po-1");
close("nuc-1");
close("Result of EDM of nuc-1");
close("EDM of nuc-1");
close("cyt")
selectWindow("all-po")
rename("po")
selectWindow("all-cyt")
rename("cyt")
selectWindow("all-nuc")
rename("nuc")

selectWindow("po");
run("Duplicate...", "title=po-1")
run("Subtract Background...", "rolling=6");
waitForUser
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=12");
waitForUser
run("Convert to Mask");
run("Images to Stack", "use keep");
close("cyt")
close("nuc-1")
close("po-1")
selectWindow("cyt-1")
rename("all-cyt")
selectWindow("nuc")
rename("all-nuc")
selectWindow("po")
rename("all-po")
selectWindow("Stack");
//setTool("wand");
setSlice(3);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(2)
run("Create Selection");
run("Next Slice [>]");
run("Next Slice [>]");
run("Clear", "slice");
run("Stack to Images");
close("cyt-1")
close("po")
close("nuc")
selectWindow("nuc-1")
run("Convert to Mask");
selectWindow("po-1")
run("Convert to Mask");
selectWindow("cyt")
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("po-1");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
waitForUser;
close("Results")
selectWindow("nuc-1");
run("Create Selection");
run("Measure");
selectWindow("cyt");
run("Create Selection");
run("Measure");
waitForUser
close("Results")
selectWindow("cyt");
run("Select All");
run("Invert");
selectWindow("nuc-1");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("po-1");
run("Set Measurements...", "area min redirect=[EDM of nuc-1] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
waitForUser
close("Results")
imageCalculator("Subtract create", "EDM of nuc-1","cyt");
selectWindow("Result of EDM of nuc-1");
waitForUser
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
waitForUser
close("Results")
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
waitForUser
close("Stack");
close("po-1");
close("nuc-1");
close("Result of EDM of nuc-1");
close("EDM of nuc-1");
close("cyt")
selectWindow("all-po")
rename("po")
selectWindow("all-cyt")
rename("cyt")
selectWindow("all-nuc")
rename("nuc")

selectWindow("po");
run("Duplicate...", "title=po-1")
run("Subtract Background...", "rolling=6");
waitForUser
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=12");
waitForUser
run("Convert to Mask");
run("Images to Stack", "use keep");
close("cyt")
close("nuc-1")
close("po-1")
selectWindow("cyt-1")
rename("all-cyt")
selectWindow("nuc")
rename("all-nuc")
selectWindow("po")
rename("all-po")
selectWindow("Stack");
//setTool("wand");
setSlice(3);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(2)
run("Create Selection");
run("Next Slice [>]");
run("Next Slice [>]");
run("Clear", "slice");
run("Stack to Images");
close("cyt-1")
close("po")
close("nuc")
selectWindow("nuc-1")
run("Convert to Mask");
selectWindow("po-1")
run("Convert to Mask");
selectWindow("cyt")
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("po-1");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
waitForUser;
close("Results")
selectWindow("nuc-1");
run("Create Selection");
run("Measure");
selectWindow("cyt");
run("Create Selection");
run("Measure");
waitForUser
close("Results")
selectWindow("cyt");
run("Select All");
run("Invert");
selectWindow("nuc-1");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("po-1");
run("Set Measurements...", "area min redirect=[EDM of nuc-1] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
waitForUser
close("Results")
imageCalculator("Subtract create", "EDM of nuc-1","cyt");
selectWindow("Result of EDM of nuc-1");
waitForUser
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
waitForUser
close("Results")
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
waitForUser
close("Stack");
close("po-1");
close("nuc-1");
close("Result of EDM of nuc-1");
close("EDM of nuc-1");
close("cyt")
selectWindow("all-po")
rename("po")
selectWindow("all-cyt")
rename("cyt")
selectWindow("all-nuc")
rename("nuc")

selectWindow("po");
run("Duplicate...", "title=po-1")
run("Subtract Background...", "rolling=6");
waitForUser
run("Watershed");
run("Convert to Mask");
selectWindow("nuc");
run("Duplicate...", "title=nuc-1");
selectWindow("cyt");
run("Duplicate...", "title=cyt-1");
selectWindow("cyt");
run("Median...", "radius=12");
waitForUser
run("Convert to Mask");
run("Images to Stack", "use keep");
close("cyt")
close("nuc-1")
close("po-1")
selectWindow("cyt-1")
rename("all-cyt")
selectWindow("nuc")
rename("all-nuc")
selectWindow("po")
rename("all-po")
selectWindow("Stack");
//setTool("wand");
setSlice(3);
run("Create Selection");
run("Clear Outside", "stack");
setSlice(2)
run("Create Selection");
run("Next Slice [>]");
run("Next Slice [>]");
run("Clear", "slice");
run("Stack to Images");
close("cyt-1")
close("po")
close("nuc")
selectWindow("nuc-1")
run("Convert to Mask");
selectWindow("po-1")
run("Convert to Mask");
selectWindow("cyt")
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
selectWindow("po-1");
run("Analyze Particles...", "size=0.01-Infinity show=Overlay display exclude clear");
waitForUser;
close("Results")
selectWindow("nuc-1");
run("Create Selection");
run("Measure");
selectWindow("cyt");
run("Create Selection");
run("Measure");
waitForUser
close("Results")
selectWindow("cyt");
run("Select All");
run("Invert");
selectWindow("nuc-1");
run("Select All");
run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");
selectWindow("po-1");
run("Set Measurements...", "area min redirect=[EDM of nuc-1] decimal=3");
run("Analyze Particles...", "size=0.01-Infinity show=Nothing display exclude clear");
waitForUser
close("Results")
imageCalculator("Subtract create", "EDM of nuc-1","cyt");
selectWindow("Result of EDM of nuc-1");
waitForUser
run("Clear Outside");
run("Set Measurements...", "area min redirect=None decimal=3");
run("Measure");
waitForUser
close("Results")
run("Images to Stack", "use keep");
selectWindow("Stack");
run("RGB Color");
waitForUser
close("Stack");
close("po-1");
close("nuc-1");
close("Result of EDM of nuc-1");
close("EDM of nuc-1");
close("cyt")
selectWindow("all-po")
rename("po")
selectWindow("all-cyt")
rename("cyt")
selectWindow("all-nuc")
rename("nuc")
