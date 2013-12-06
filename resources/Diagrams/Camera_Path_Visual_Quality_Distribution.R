#
# This R script reads text files with tab separated values created by the Test
# plug-in and generates a diagram comparing the distribution of the visual
# quality over the camera path.
#

fileName <- "Camera_Path_Visual_Quality_Distribution.pdf"

pdf(fileName, title="Visual quality", paper="special", width=8, height=6, family="NimbusSan")

# Reduce margin.
par(mar=c(4, 4, 1, 1) + 0.1)

# Do not use scientific notation.
options(scipen=10)

palette(c(	hsv(0, 0, 0), hsv(0, 0, 0.3), # black, gray
			hsv(4/6, 1, 0.75), hsv(4/6, 0.3, 0.75), #  blue, light blue
			hsv(3/6, 1, 0.75), hsv(3/6, 0.3, 0.75), # ...
			hsv(2/6, 1, 0.75), hsv(2/6, 0.3, 0.75), # ...
			hsv(1/6, 1, 0.75), hsv(1/6, 0.3, 0.75) # green, light green
))

# Specify input pairs of (file, description) as data.frame.
input <- data.frame(File=c("output_5M.tsv", "output_800k.tsv", "output_400k.tsv", "output_200k.tsv", "output_100k.tsv"), 
					Description=c(5e6, 8e5, 4e5, 2e5, 1e5))

# Read the input into one data frame with an index column.
num <- nrow(input)
data <- NULL
for(i in 1:num) {
	data <- rbind(data, data.frame(Index=i, read.delim(toString(input[i, "File"]))))
}

# Total number of pixels for conversion from number of pixels to ratio.
pixelsComplete <- 720 * 720
data$Value <- (1 - (data$Value / pixelsComplete)) * 100

boxplotData <- boxplot(data$Value ~ data$Index, names=format(input$Description, big.mark=","), range=0, plot=FALSE)
bxp(boxplotData, xlab="Budget [triangles]", ylab="Visual quality [%]", boxfill="lightgray")
points(by(data$Value, data$Index, mean), pch=4, cex=3, lwd=3)

dev.off()

embedFonts(fileName, options="-dPDFSETTINGS=/prepress")

# Statistics output to text file
output <- file(sub(".pdf", ".txt", fileName), open="w+t")

titles <- c("Minimum", "Lower quartile", "Median", "Upper quartile", "Maximum")
for(n in 1:NROW(boxplotData$names)) {
	cat(paste("#####", boxplotData$names[n], "#####\n"), file=output)
	for(s in 1:5) {
		cat(sprintf("%14s: %7.3f%%\n", titles[s], boxplotData$stat[s, n]), file=output)
	}
}
close(output)
