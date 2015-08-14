
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
        p(class="text-small", "The Consumer Assessment of Health Providers and Systems (CAHPS) survey is designed to measure
                 patient experience with various aspects of healthcare in the United States (i.e. Hospitals, Insurance Plans, Clinicians, etc.). Within
                 the CAHPS survey, questions are grouped into 'composites' to measure domains such as 'Getting Timely Care', 
                 'Overall Provider of Rating', and other domains. These composite scores are reported on a linear 0-100 scale.
                  This R shiny application allows the user to explore patient-level CAHPS data using various tools. For example,
                  if you were interested in a looking at the relationship between the 'Provider Communication' composite and the
                  'Getting Timely Care' composite, you could select these two measures using the box on the left to generate a scatterplot.
                  The different data exploration tools are organized as different tabs in this application (i.e. Scatterplots, Correlation Matrix).
                  Play around with the CAHPS data, and have fun! If you're interested, additional information about CAHPS can be
                  found ",
          a(href="https://www.cahps.ahrq.gov/",
            target="_blank", "here.")),
        hr(),
        plotOutput("scatter", height="600px", width="1000px")
      ),
      
      tabPanel("Density Overlay Plots",
        h2("Density Plot(s) of Patient-level CAHPS Measures"),
        p(class="text-small", "This tab generates the density distribution for different CAHPS measures. The user can select
          additional CAHPS measures using the box to the left to simultaneously view the density distribution for multiple CAHPS measures."),
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

 
                  
 