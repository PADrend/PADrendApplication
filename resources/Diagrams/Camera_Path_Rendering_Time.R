#
# This R script reads text files with tab separated values created by the Test
# plug-in and generates a diagram comparing the rendering times.
#

# Diagram centered on a DIN A4 landscape page.
pdf("Camera_Path_Rendering_Time.pdf", title="Rendering time", paper="a4r", width=0, height=0, family="NimbusSan")

# Reduce margin.
par(mar=c(4, 4, 1, 1) + 0.1)

palette(c(	hsv(0, 0, 0), hsv(0, 0, 0.3), # black, gray
			hsv(0, 1, 0.75), hsv(0, 0.3, 0.75), # red, light red
			hsv(5/6, 1, 0.75), hsv(5/6, 0.3, 0.75), #  magenta
			hsv(4/6, 1, 0.75), hsv(4/6, 0.3, 0.75), #  blue, light blue
			hsv(3/6, 1, 0.75), hsv(3/6, 0.3, 0.75), # ...
			hsv(2/6, 1, 0.75), hsv(2/6, 0.3, 0.75), # ...
			hsv(1/6, 1, 0.75), hsv(1/6, 0.3, 0.75) # green, light green
))

# Specify input pairs of (file, description) as data.frame.
input <- data.frame(File=c("output_std.tsv", "output_occ.tsv", "output_5M.tsv", "output_800k.tsv", "output_400k.tsv", "output_200k.tsv", "output_100k.tsv"), 
					Description=c("Frustum culling", "Occlusion culling", "Budget 5 million triangles", "Budget 800,000 triangles", "Budget 400,000 triangles", "Budget 200,000 triangles", "Budget 100,000 triangles"))

# Read the input into one data frame with an index column.
num <- nrow(input)
data <- NULL
for(i in 1:num) {
	data <- rbind(data, data.frame(Index=i, read.delim(toString(input[i, "File"]))))
}

# Convert microseconds to milliseconds
data$Value <- data$Value / 1000

xValues <- unique(data$Waypoint)
limits <- c(max(0.1, min(data$Value)), max(data$Value));

# Create one plot with linear and one with logarithmic y axis.
for(logVal in c("", "y")) {
	# Create an empty plot with axes.
	plot(xValues, type="n", xlim=range(xValues), ylim=limits, log=logVal, xlab="Frame", ylab="Rendering time [ms]")

	# Create plots for the input data.
	for(i in 1:num) {
		bpData <- boxplot(Value ~ Waypoint, data=data, subset= (Index == i), range=0, plot=FALSE)
		# Draw lines from minimum to maximum.
		segments(xValues, bpData$stats[1,], xValues, bpData$stats[5,], col=(i * 2))
		# Plot the main line last so that it is not painted over.
		lines(xValues, bpData$stats[3,], col=(i * 2 - 1))
	}

	legend("topleft", inset=c(0.15, 0), as.vector(input$Description), col=seq(1, 2 * num, by=2), lty=1, lwd=3)
}

dev.off()
