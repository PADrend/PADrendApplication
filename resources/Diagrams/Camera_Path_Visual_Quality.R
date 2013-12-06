#
# This R script reads text files with tab separated values created by the Test
# plug-in and generates a diagram comparing the visual quality.
#

# Diagram centered on a DIN A4 landscape page.
pdf("Camera_Path_Visual_Quality.pdf", title="Visual quality", paper="a4r", width=0, height=0, family="NimbusSan")

# Reduce margin.
par(mar=c(4, 4, 1, 1) + 0.1)

palette(c(	hsv(0, 0, 0), hsv(0, 0, 0.3), # black, gray
			hsv(4/6, 1, 0.75), hsv(4/6, 0.3, 0.75), #  blue, light blue
			hsv(3/6, 1, 0.75), hsv(3/6, 0.3, 0.75), # ...
			hsv(2/6, 1, 0.75), hsv(2/6, 0.3, 0.75), # ...
			hsv(1/6, 1, 0.75), hsv(1/6, 0.3, 0.75) # green, light green
))

# Specify input pairs of (file, description) as data.frame.
input <- data.frame(File=c("output_5M.tsv", "output_800k.tsv", "output_400k.tsv", "output_200k.tsv", "output_100k.tsv"), 
					Description=c("Budget 5 million triangles", "Budget 800,000 triangles", "Budget 400,000 triangles", "Budget 200,000 triangles", "Budget 100,000 triangles"))

# Read the input into one data frame with an index column.
num <- nrow(input)
data <- NULL
for(i in 1:num) {
	data <- rbind(data, data.frame(Index=i, read.delim(toString(input[i, "File"]))))
}

# Total number of pixels for conversion from number of pixels to ratio.
pixelsComplete <- 720 * 720
overallQuality <- NULL

xValues <- unique(data$Waypoint)
limits <- c(0, 100)

# Create an empty plot with axes.
plot(xValues, type="n", xlim=range(xValues), ylim=limits, xlab="Frame", ylab="Visual quality [%]", panel.first=grid())

# Create plots for the input data.
for(i in 1:num) {
	indexData <- subset(data,  subset= (Index == i))
	lines(by(indexData, indexData$Waypoint, function(x) {(1 - (mean(x$Value) / pixelsComplete)) * 100}), col=(i * 2 - 1))
	overallQuality <- c(overallQuality, (1 - (mean(indexData$Value) / pixelsComplete)) * 100)
}

legendText <- paste(as.vector(input$Description), lapply(overallQuality, function(value) sprintf("(overall %2.2f%%)", value)))
legend("bottomright", legendText, col=seq(1, 2 * num, by=2), lty=1, lwd=3, bg="white")

dev.off()
