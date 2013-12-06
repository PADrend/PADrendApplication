#
# This R script reads text files with tab separated values created by the Test
# plug-in and generates a diagram comparing the rendering times.
#

fileName <- "Camera_Path_Rendering_Time_Small.pdf"

pdf(fileName, title="Rendering time", paper="special", width=8, height=6, family="NimbusSan")

# Reduce margin.
par(mar=c(4, 4, 1, 1) + 0.1)

palette(c(	hsv(0, 0, 0), # black
			hsv(4/6, 1, 0.75), #  blue
			hsv(3/6, 1, 0.75), # green
			hsv(2/6, 1, 0.75) # yellow
))

# Specify input pairs of (file, description) as data.frame.
input <- data.frame(File=c("output_occ.tsv", "output_no_limit.tsv", "output_800k.tsv", "output_200k.tsv"), 
					Description=c("Occlusion culling", "VS, no budget", "VS, budget 800k triangles", "VS, budget 200k triangles"))

# Read the input into one data frame with an index column.
num <- nrow(input)
data <- NULL
for(i in 1:num) {
	data <- rbind(data, data.frame(Index=i, read.delim(toString(input[i, "File"]))))
}

# Convert microseconds to milliseconds
data$Value <- data$Value / 1000

xValues <- unique(data$Waypoint)
limits <- c(0, 30)

# Create an empty plot with axes.
plot(xValues, type="n", xlim=range(xValues), ylim=limits, xlab="Frame", ylab="Rendering time [ms]", panel.first=grid())

# Create plots for the input data.
for(i in 1:num) {
	indexData <- subset(data,  subset= (Index == i))
	lines(xValues, by(indexData$Value, indexData$Waypoint, median), col=i, lwd=2)
	print(paste("Mean of ", input$Description[[i]], ": ", mean(indexData$Value), sep=""))
}

legend("topright", as.vector(input$Description), ncol=floor(num / 2), col=1:num, bg="white", lty=1, lwd=3)

dev.off()

embedFonts(fileName, options="-dPDFSETTINGS=/prepress")
