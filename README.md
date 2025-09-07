# Brazilian E-commerce Performance Analysis

## Project Overview
Comprehensive analysis of 100,000+ e-commerce orders from a Brazilian marketplace (2016-2018) to identify revenue trends, customer behavior patterns, and geographic distribution insights.

## Key Findings
- **Geographic Concentration**: 40% of total revenue concentrated in São Paulo state
- **Strong Revenue Correlation**: Linear relationship between order volume and revenue (R² = 0.99)
- **Market Size**: $13.2M in total analyzed transactions
- **Customer Segmentation**: Identified distinct value segments with VIP customers averaging $500+ lifetime value
- **Growth Trends**: Quarter-over-quarter revenue growth analysis revealed seasonal patterns

## Technologies Used
- **PostgreSQL**: Multi-table joins, data cleaning, and complex aggregations
- **R**: Statistical modeling, regression analysis, and data validation
- **Tableau**: Interactive dashboard creation and data visualization

## Business Impact
- Identified top-performing product categories and geographic markets
- Developed customer segmentation model for targeted marketing
- Created executive KPI dashboard for strategic decision-making
- Revealed seasonal ordering patterns for inventory planning

## Technical Highlights
- Handled messy real-world data (fixed header row contamination issues)
- Implemented advanced SQL techniques (CTEs, window functions, LAG operations)
- Performed statistical validation using p-value testing (p < 0.0001)
- Built comprehensive customer lifetime value analysis

## Project Structure
```
├── README.md                 # Project documentation
├── queries.sql.txt          # PostgreSQL analysis queries
└── R_olist.R               # Statistical modeling and validation
```

## Key Analyses Performed
- **Revenue Analysis**: Monthly trends and seasonal patterns
- **Geographic Distribution**: State-by-state performance breakdown  
- **Customer Segmentation**: Lifetime value clustering (Low/Medium/High/VIP)
- **Product Profitability**: Category performance and pricing analysis
- **Growth Metrics**: Quarter-over-quarter business expansion tracking

## Sample Insights
- São Paulo generates 40% of revenue despite being one state among 27
- Average order value of $135 with strong consistency across time periods
- VIP customers (>$500 lifetime value) represent highest growth opportunity
- Seasonal peaks align with Brazilian holiday shopping patterns

## Dashboard Features
Interactive Tableau visualization includes:
- Real-time revenue tracking by geography
- Customer segment performance metrics
- Product category profitability analysis
- Executive KPI summary dashboard

---
*This analysis demonstrates proficiency in end-to-end data analytics: from raw data processing through statistical validation to business intelligence dashboard creation.*
