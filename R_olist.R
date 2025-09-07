library(readr)

# Load data - try both ways to see which works:
monthly_data <- read.csv("C:/Users/sansk/Downloads/month_olist_data")

# Simple Linear Regression
model <- lm(monthly_revenue ~ monthly_orders, data = monthly_data)
summary(model)

# Slope, intercept, R2
slope <- coef(model)[2]
intercept <- coef(model)[1]
r_squared <- summary(model)$r.squared

# View results
print(paste("Slope:", round(slope, 2)))
print(paste("R-squared:", round(r_squared, 3)))

#r2 = .99, extremely high
# 99% of revenue variation is explained by order count
# Revenue = $7,036 + $135 * Orders
# Each order generates almost exactly $135 in revenue


