
shinyServer(function(input, output) {
  
 output$scatter <- renderPlot({
   x_var <- input$xvar
   y_var <- input$yvar
 
   x_label <- as.character(var_titles[var_titles$var==as.character(x_var),"var_title"])
   y_label <- as.character(var_titles[var_titles$var==as.character(y_var),"var_title"])
   
   if (input$facet=="None"){
    ggplot(df1, aes_string(x_var, y_var)) + 
    geom_point(colour="red", size=2.5) +
    geom_smooth(method=lm, lwd=1.5) +
    xlab(x_label) +
    ylab(y_label) +
    ggtitle(paste("Scatterplot of ", x_label, " vs. ", y_label, sep="")) +
    theme(axis.title.x=element_text(size=12,face="bold"),
          axis.title.y=element_text(size=12,face="bold"),
          plot.title=element_text(size=14,face="bold"))
   }
   
   else{
    facet <- input$facet
    facet_label <- as.character(var_titles[var_titles$var==as.character(facet),"var_title"])
   
    ggplot(df1, aes_string(x_var, y_var)) + 
    geom_point(colour="red", size=2.5) +
    geom_smooth(method=lm, lwd=1.5) +
    xlab(x_label) +
    ylab(y_label) +
    ggtitle(paste("Scatterplot of ", x_label, " vs. ", y_label, " by ", facet_label, sep="")) +
    theme(axis.title.x=element_text(size=12,face="bold"),
          axis.title.y=element_text(size=12,face="bold"),
          plot.title=element_text(size=14,face="bold"))+
    facet_wrap(as.formula(paste("~", facet)), nrow=3)
   }

 }) #end of scatterplot output
 
 output$density <- renderPlot({
   if (is.null(input$overlay)){
     x_var <- input$density_var
     x_label <- as.character(var_titles[var_titles$var==as.character(x_var),"var_title"])
     
     ggplot(df1, aes_string(x_var)) + 
     geom_density(lwd=1, fill = "lightcoral") +
     scale_x_continuous(limits=c(0,100)) +
     xlab(x_label) +
     ylab("Density") +
     ggtitle(paste("Density Plot of ", x_label, sep="")) +
     theme(axis.title.x=element_text(size=12,face="bold"),
           axis.title.y=element_text(size=12,face="bold"),
           plot.title=element_text(size=14,face="bold"))
   }
   else{
     x_var <- input$density_var
     keep_SSMs <- input$overlay
     df2 <- df1[,names(df1) %in% c("plan","patient",x_var, keep_SSMs)]

     df3 <- melt(df2, id=c("plan","patient"))
     df4 <- merge(df3, var_titles, by.x="variable", by.y="var", all.x=T)
 
     ggplot(df4, aes(value, fill = var_title)) +
     geom_density(lwd=1, alpha=0.25) +
     guides(fill=guide_legend(title="CAHPS Measure")) +
     scale_x_continuous(limits=c(0,100)) +
     xlab("CAHPS Outcome (0-100)") +
     ylab("Density") +
     ggtitle("Density Overlay Plot of Selected CAHPS Measures") +
     theme(axis.title.x=element_text(size=12,face="bold"),
           axis.title.y=element_text(size=12,face="bold"),
           plot.title=element_text(size=14,face="bold"),
           legend.position = c(0.15,.9))
   }
   
 }) #end of density plot output
 
 output$corr_plot <- renderPlot({
   df2 <- melt(cor(df1[input$corr_vars]))
   
   df3 <- merge(df2, var_titles, by.x="Var1", by.y="var", all.x=T) %>%
          mutate(Var1.Name = var_title) 
   
   df4 <- merge(select(df3, -var_title), var_titles, by.x="Var2", by.y="var", all.x=T) %>%
          mutate(Var2.Name = var_title) %>%
          select(Var1.Name, Var2.Name, value) 
   
   plot1 <- qplot(x=Var1.Name, y=Var2.Name, data=df4, fill=value, geom="tile") 
   
   plot2 <- plot1 +
            scale_fill_gradient2(low=RtoWrange(100), mid=WtoGrange(100), high="gray", guide=guide_legend(title="Correlation")) +
            theme(axis.text.x = element_text(angle=45, hjust = 1))  +
            xlab("Variable 1") +
            ylab("Variable 2") 
   
   plot2
 }) #end of Correlation Matrix plot
 
 output$univariate <- renderTable({
   sample <- by(df1[,input$measure], df1[,input$group], length)
   stats <- by(df1[,input$measure], df1[,input$group], summary)
   stats_comb <- cbind(ldply(sample)["V1"], ldply(stats))
   names(stats_comb) <- c("N", "Group","Min","Q1","Median","Mean","Q3","Max") 
   stats_comb <- select(stats_comb, Group, N, Min, Q1, Median, Mean, Q3, Max)
   names(stats_comb) <- c(as.character(var_titles[var_titles$var==input$group, "var_title"]),"N","Min","Q1","Median","Mean","Q3","Max")
   stats_comb
 }, include.rownames=F) #end of univariate output
 
 output$anova_pval <- renderText({
   model <- aov(df1[,input$measure]~ (df1[,input$group]))
   anova_pval <- summary(model)[[1]][["Pr(>F)"]]
   paste("One-way ANOVA p-value:", as.character(round(anova_pval[[1]],3)), sep="")
 })
 
 output$regression <- renderTable({
   formula <- paste(input$outcome, "~", paste(input$predictors, collapse="+"))
   model1 <- summary(lm(formula, data=df1))
   
   model2 <- data.frame(model1$coefficients) %>%
             mutate(Coefficient = Estimate,
                    SE = Std..Error,
                    p.val = Pr...t..,
                    predictor = row.names(model1$coefficients)) %>%
             select(predictor, Coefficient, SE, p.val)
   
   model3 <- merge(model2, var_titles, by.x="predictor", by.y="var", all.x=T)
   
   model4 <- model3 %>%
             mutate(predictor = ifelse(predictor!="(Intercept)", as.character(var_title), "Intercept"),
                    Coefficient = round(Coefficient, 1),
                    SE = round(SE, 2),
                    p.val = round(p.val, 3)) %>%
             select(predictor, Coefficient, SE, p.val)
   
   names(model4) <- c("Predictor","Coefficient Estimate", "SE of Coefficient", "p-val")
   
   model4
 }, include.rownames=F) #end of regression output
 
 output$rsquares <- renderText({
   formula <- paste(input$outcome, "~", paste(input$predictors, collapse="+"))
   model1 <- summary(lm(formula, data=df1))
   paste("R-square: ", round(model1$r.squared,5), ", Adjusted R-square: ", round(model1$adj.r.squared,5), sep="")
 })
})