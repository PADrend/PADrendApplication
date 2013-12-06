#
# This R script reads text files with tab separated values created by the Test
# plug-in and generates a diagram showing the number of triangles visibile from
# the cells on the camera path.
#

# Diagram centered on a DIN A4 landscape page.
pdf("Camera_Path_Visible_Triangles.pdf", title="Visible triangles", paper="a4r", width=0, height=0, family="NimbusSan")

# Reduce margin.
par(mar=c(4, 4, 1, 1) + 0.1)

palette(c(	hsv(0, 0, 0), # black
			hsv(8/12, 1, 0.75), # blue
			hsv(7/12, 1, 0.75), # ...
			hsv(6/12, 1, 0.75), # ...
			hsv(3/12, 1, 0.75), # ...
			hsv(2/12, 1, 0.75), # ...
			hsv(1/12, 1, 0.75), # green
			hsv(5/6, 1, 0.75), # magenta
			hsv(0, 1, 0.75) # red
))

# Specify input pairs of (file, description) as data.frame.
input <- data.frame(File=c("output_triangles.tsv", "output_vs_not_reduced.tsv", "output_vs_medium_reduced.tsv", "output_vs_reduced.tsv", "output_frustum_not_reduced.tsv", "output_frustum_medium_reduced.tsv", "output_frustum_reduced.tsv", "output_frustum_original.tsv", "output_occ.tsv"), 
					Description=c("Exact visibility", "Visibility subdivision (Pristine)", "Visibility subdivision (Medium)", "Visibility subdivision (Reduced)", "Frustum culling (Pristine)",  "Frustum culling (Medium)", "Frustum culling (Reduced)",  "Frustum culling (Original)", "Occlusion culling"))

# Read the input into one data frame with an index column.
num <- nrow(input)
data <- NULL
for(i in 1:num) {
	data <- rbind(data, data.frame(Index=i, read.delim(toString(input[i, "File"]))))
}

xValues <- unique(data$Waypoint)
limits <- c(1, max(data$Value))

# Create one plot with linear and one with logarithmic y axis.
logVal <- c("", "y")
legendPos <- c("topleft", "bottom")
for(p in 1:2) {
	# Create an empty plot with axes.
	plot(xValues, type="n", xlim=range(xValues), ylim=limits, log=logVal[[p]], xlab="Frame", ylab="Visible triangles", panel.first=grid())

	# Create plots for the input data.
	for(i in 1:num) {
		indexData <- subset(data,  subset= (Index == i))
		lines(indexData$Waypoint, indexData$Value, col=i, lwd=1.5)
	}

	legendText <- paste(as.vector(input$Description), lapply(by(data$Value, data$Index, mean), function(value) sprintf("(%.0f)", value)))
	legend(legendPos[[p]], rev(legendText), inset=c(0.085, 0), col=num:1, lty=1, lwd=3, bg="white")
}

dev.off()
