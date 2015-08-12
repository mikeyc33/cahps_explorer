
shinyUI(fluidPage(
  titlePanel("Shiny Statistical Exploration of Patient-level CAHPS data"),
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition="input.tabset=='Scatterplots'",
        selectInput(inputId="xvar", label="X-axis CAHPS Measure", choices=CAHPS_scores, selected="rate_md"),
        hr(),
        selectInput(inputId="yvar", label="Y-axis CAHPS Measure", choices=CAHPS_scores, selected="c_access"),
        hr(),
        selectInput(inputId="facet", label="Facet Wrap Variable", choices=wrap_vars, selected="None")
      ),
      
      conditionalPanel(
        condition="input.tabset=='Density Overlay Plots'",
        selectInput(inputId="density_var", label="CAHPS measure", choices=CAHPS_scores, selected="rate_md"),
        hr(),
        selectInput(inputId="overlay", label="Additional CAHPS Measures", choices=CAHPS_scores, selected=NULL, multiple=T)
      ),
      
      conditionalPanel(
        condition="input.tabset=='Correlation Matrix'",
        checkboxGroupInput(inputId="corr_vars", label="CAHPS Measures", choices=CAHPS_scores, selected=CAHPS_scores[1:4])
      ),
    
      conditionalPanel(
        condition="input.tabset=='Univariate Statistics'",
        selectInput(inputId="measure", label="CAHPS Measure", choices = CAHPS_scores, selected="rate_md"),
        hr(),
        selectInput(inputId="group", label="By Group", choices = wrap_vars[2:length(wrap_vars)], selected="ghs")
      ),
    
      conditionalPanel(
        condition="input.tabset=='Multivariate Linear Regression'",
        selectInput(inputId="outcome", label="Outcome", choices=CAHPS_scores, selected="rate_md"),
        hr(),
        checkboxGroupInput(inputId="predictors", label="Predictors", choices=predictors, selected=predictors[8:length(predictors)])
    ),
    
    width = 3
  ),
  
  mainPanel(
    tabsetPanel(id="tabset",
      tabPanel("Scatterplots",
        h2("Scatterplot of Patient-level CAHPS Measures"),
        p(class="text-small", "This tab creates scatterplot combinations to explore the relationship between different
          CAHPS measures. In addition, the scatterplots can be facetted by patient characeristics (i.e. patient age category) or different
          health plans by selecting the appropriate category under 'Facet Wrap Variable'."),
        hr(),
        plotOutput("scatter", height="600px", width="1000px")
      ),
      
      tabPanel("Density Overlay Plots",
        h2("Density Plot(s) of Patient-level CAHPS Measures"),
        p(class="text-small", "This tab generates the density distribution for different CAHPS measures. The user can select
          additional CAHPS measures in the 'Additional CAHPS Measures' section to simultaneously view the density distribution for multiple CAHPS measures."),
        hr(),
        plotOutput("density", height="600px", width="1000px")
      ),
      
      tabPanel("Correlation Matrix",
        h2("Correlation Matrix for Selected Patient-level CAHPS Measures"),
        p(class="text-small", "This tab generates a correlation matrix for different CAHPS measures. The user can add or remove CAHPS
          measures by using the check-box to the left."),
        hr(),
        plotOutput("corr_plot", height="600px", width="1000px")
      ),
      
      tabPanel("Univariate Statistics",
        h2("Summary Statistics for Patient-level CAHPS Measures"),
        p(class="text-small", "This tab generates univariate statistics for CAHPS measure by different patient characteristics. 
          The user can specify different chararacteristics by using the 'By Group' box. In addition, the p-value associated
          with a 1-way ANOVA is included at the bottom of the table."),
        hr(),
        tableOutput("univariate"),
        textOutput("anova_pval")
      ),
      
      tabPanel("Multivariate Linear Regression",
        h2("Multivariate Linear Regression for CAHPS Measures"),
        p(class="text-small", "This tab produces a multivariate linear regression model where the specified CAHPS measure is the outcome,
          and predictors include patient-level dummy variables plus other CAHPS measures. Users can change the outcome of interest by
          using the 'Outcome' box, and add (or remove) predictors by using the 'Predictors' check-box. The R-square and adjusted R-square for the model is located at the bottom of the table."),
        hr(),
        tableOutput("regression"),
        textOutput("rsquares")
      )
    ), #close of tabsetPanel
    width=9
  ) #close of mainPanel
  ) #close of sideBarLayout
)) #close of Shiny UI and fluidpage  

 
                  
 