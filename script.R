# Student Marks Analytics Script

# Load dataset
data <- read.csv("data/students.csv")

# Calculate Total & Percentage
data$Total <- data$Maths + data$Science + data$English
data$Percentage <- round(data$Total / 3, 2)

# Assign Grade
data$Grade <- ifelse(data$Percentage >= 85, "A+",
              ifelse(data$Percentage >= 70, "A",
              ifelse(data$Percentage >= 50, "B", "C")))

# Display results in console
print("--- Processed Data ---")
print(data)

# Save summary & plots
write.csv(data, "output/processed_students.csv", row.names = FALSE)

# Generate Bar Plot
png("output/grade_distribution.png", width = 800, height = 600)
grade_counts <- table(data$Grade)
barplot(grade_counts, 
        main="Grade Distribution", 
        xlab="Grades", 
        ylab="Number of Students", 
        col="skyblue",
        border="navy")
dev.off()

print("Processing Complete! Check 'output' folder for results.")
