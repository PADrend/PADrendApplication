#
# This R script reads text a text file with tab separated values consisting of
# the columns FileName and TotalSize. It creates a diagram showing the
# distribution of the file sizes.
#

fileName <- "File_Size_Distribution.pdf"

# Diagram centered on a DIN A4 landscape page.
pdf(fileName, title="File size distribution", paper="a4r", width=0, height=0, family="NimbusSan")

# Reduce margin.
par(mar=c(4, 4, 1, 1) + 0.1)

# Prevent usage of scientific notation.
options(scipen=10)

# Read input data.
data <- read.delim("file_sizes.tsv")

boxplot(data$TotalSize, log="x", xaxt="n", xlab="Total size", horizontal=TRUE, col="lightgray")
axis(1, at=1024^(0:4), labels=c("1 B", "1 KiB", "1 MiB", "1 GiB", "1 TiB"))

names <- c("Count", "Minimum", "Lower quartile", "Median", "Upper quartile", "Maximum")
stats <- c(NROW(data$TotalSize), paste(fivenum(data$TotalSize), "Byte"))
legend("bottomright", c(names, stats), ncol=2, title="Statistics")

dev.off()

embedFonts(fileName, options="-dPDFSETTINGS=/prepress")
