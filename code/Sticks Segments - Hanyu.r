##############################
# Segmentation Analysis in R #
##############################

## Sticks Kebob

# Load Packages (if needed) and set seed
set.seed(1)

# Import Data
seg <- read.csv(file.choose()) ## Choose M-0866X-Data.csv file

# D1 attitude items (5 = "don't know")
likert_D1 <- c("D1.1","D1.2","D1.3","D1.4")

# D4 importance items (6 = "don't know")
likert_D4 <- c("D4.1","D4.2","D4.3","D4.4",
               "D4.5","D4.6","D4.7","D4.8","D4.9")

# Choose base variables (edit this list to match what you actually want)
base_vars <- c(
  "D1.3","D1.4",                         # psychographic
  "D2.1","D2.2","D2.3","D2.4","D2.5",    # lunch behavior
  "D4.1","D4.2","D4.3","D4.4","D4.5",    # importance ratings
  "D4.6","D4.7","D4.8","D4.9"
)

# For D1: 5 = don't know
for (v in likert_D1) {
  seg[[v]][seg[[v]] == 5] <- NA
}

# For D4: 6 = don't know
for (v in likert_D4) {
  seg[[v]][seg[[v]] == 6] <- NA
}

# Keep only rows with complete data on the base variables
seg_complete <- seg[complete.cases(seg[, base_vars]), ]

# Check how many rows you keep
nrow(seg); nrow(seg_complete)

# Run hierarchical clustering with base variables on the cleaned data
X <- scale(seg_complete[, base_vars])
seg_hclust <- hclust(dist(X), method = "complete")
plot(seg_hclust)

# Elbow plot for first 10 segments
x <- 1:10
sort_height <- sort(seg_hclust$height, decreasing = TRUE)
y <- sort_height[1:10]
plot(x, y)
lines(x, y, col = "blue")

## Choose the K-Means with the number of segments you picked from the Elbow Plot
N <- 6

# Run k-means with N segments. Change "N" to the number you want. 
# Also change the list of variables to match the ones you used above for hierarchical clustering.
# Prepare the data matrix for k-means
set.seed(1)
seg_kmeans <- kmeans(X, centers = N, nstart = 25)
seg_kmeans$size

## Back to the regular code

# Add segment number back to original data
segment <- seg_kmeans$cluster
segmentation_result <- cbind(seg_complete, segment)

# Export data to a CSV file
write.csv(segmentation_result,
          file = file.choose(new = TRUE),
          row.names = FALSE)   # e.g., sticks_result.csv
