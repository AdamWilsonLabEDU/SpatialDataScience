# Final Project

## Description

The final project will consist of a poster-length report summarizing your analysis.  You can do this in either of two formats:

1. An academic poster
2. An informal 'infographic' with background information

The project will be uploaded to UBlearns as a PDF along with the underlying R source code.  The topic can be related to the student’s research interests or a separate topic.

### Requirements

1. The project must include data from at least two sources that were integrated/merged using R.
2. The underlying data must be publically accessible via the web and downloaded within the R/Rmd script.  If you want to use your own data, you must make it available on a website (e.g. [Figshare](figshare.org)) so that others are able to re-run your code.
2. The graphic should convey at least three (and preferably four) dimensions of information (e.g.  latitude, longitude, time, and one more)


Complete submissions will include:

1. Title (<25 words)
2. Introduction  [~ 200 words]
3. Materials and methods [~ 200 words]
4. Results [~200 words]
5. Conclusions [~200 words]
6. References


## Formatting

The final project should be organized as a [RMarkdown document](http://rmarkdown.rstudio.com) that includes all the steps necessary to run the analysis and produce the output (figures, tables,etc.).  For examples of similar documents, explore the [RPubs website](https://rpubs.com).    

If you prefer to generate the graphics in R and then import them to another graphical layout program (Powerpoint, Adobe Illustrator, InkScape, etc.) that is acceptable (though discouraged).  The core graphics must be produced using R.

### Figures
Figures (maps and other graphics) are a vital component of scientific communication and you should carefully plan your figures to convey the results of your analysis.  

### Source and Output Files

You will upload:

1) the source (`.R` and/or `.Rmd`) 	file
2) an html version
3) a PDF version of the formatted document.  

The HTML is for archival and sharing in the class projects.  Let me know if you would prefer your final project to not be posted on the course website.  The PDF version and your code (`.R` or `.Rmd` file) will be graded (see rubric below).   

You can create the PDF version in any of the following ways:

* Compile the `.Rmd` document to HTML (as explained [here](http://rmarkdown.rstudio.com/html_document_format.html)) and then open the html file in a browser (chrome, explorer, safari, etc.) and print it / save it as a pdf.  This is the prefered route as you also get the HTML version this way.
* Run the `.R` file exporting your graphics for assembly in another graphics program (e.g. PowerPoint, Illustrator, Inkscape). Then save two versions: HTML and pdf.
* Compile the `.Rmd` document directly to PDF as explained [here](http://rmarkdown.rstudio.com/pdf_document_format.html) 

### References
You should cite any relevant materials (including data sources and methods) in the text using a standard author-date citation format (e.g. Wilson, 2015) and then described in a References section.  You can either compile the references manually (e.g. cutting and pasting the citation into the references section) or use the automated system in RMarkdown explained [here](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html).   Other citation styles are acceptable as long as they are consistent, complete, and easy to understand.  

## Grading

To achieve a perfect score a final project would have the following characteristics: 

* **Organization:** The 'story' is very well organized, makes good use of graphics, and is easy to understand. Clear labels/headings demarcate separate sections. Excellent flow from one section to the next. The summary adequately describes approach and results.  Conclusions at the end present further questions and ways to investigate more. Tables and graphics carefully tuned and placed for desired purpose.
* **Curiosity:** Intense exploration and evidence of many trials and failures. The author looked at the data in many different ways before coming to the final result. The author has gone beyond what was asked: additional techniques from other sources used to help understand/explain findings. The explanation and presentation is creative.
* **Skepticism:** Author suggests multiple explanations for a given finding and uses multiple tools to explore surprising results. One or two results are presented as the most plausible, but the project allows for the possibility that results are wrong. The project is self-critical and flaws are identified: What was done well? What was done poorly? What may have been missed? How could it be done better next time? 
* **Grammar:**  All language is well constructed with varied structure and length. The author makes no errors in grammar, mechanics, and/or spelling.
* **Code:** The code associated with the project is well organized and easy to follow.   Demonstrates mastery of R graphics and functions.

See the project rubric (see link near top of project submission page in UBlearns) for more details and examples.  

## Project Phases

### Project proposal

The project proposal will be 1 page or less and outline the following:

1.  Introduction to problem/question
2.  Links to inspiring examples:  Include links to a few (~3-5) example graphics found on the internet that are somehow similar to what you want to do.
2.  Proposed data sources
3.  Proposed methods
4.  Expected results

### First Draft
The first draft of your project will be assessed by your peers in UBlearns.  You will pick two projects and evaluate them according to the rubric below.  The objectives of the peer evaluation are:

* Expose you to the work of your peers so you know what others are working on
* Provide an opportunity to share your knowledge to improve their project

The grading of the first draft will be limited to the Title (<25 words), Introduction  [~ 200 words], and Materials and methods [~ 200 words] sections.  You should have acquired (downloaded, etc) or at least identified all the data you plan to use and worked out most of the details of the methods (either in code or detailed descriptions), though you may not have any results or summary figures yet.  You only need to upload the narrative sections mentioned above (Title, Introduction, and Methods) in a PDF.  You do not need to upload any data or code.  If you have made figures already, please include them in your document, but they are not required.

### Second Draft
The more complete the second draft, the more feedback I'll be able to provide to ensure an excellent final project.  So it's in your interest to finish as much as possible.    In addition to the details from the first draft, I would like to see at least one figure illustrating the data you are working with.  If you include drafts of the results and discussion/conclusion I will also give you feedback on those sections.  

The second draft will be graded using the same criteria as the full project (see above), but I do not expect to see final versions of the discussion and conclusion.  If you have questions or comments, feel free to include them in the draft (e.g., "I'm planning to do X, but I'm not sure how to organize the data appropriately") or as a _comment_ in the UBLearns submission webpage.  

### Final Draft

The final draft will be uploaded to UBLearns at the end of the semester and posted on the course website.

**Remember to upload the HTML, PDF, and  `.r`/`.Rmd` files! **

### Resources

Sites with examples of visual display of quantitative information 

* [http://www.informationisbeautiful.net](http://www.informationisbeautiful.net)
* [http://flowingdata.com](http://flowingdata.com)
* [https://visual.ly/m/design-portfolio/](https://visual.ly/m/design-portfolio/) 
* [40 Brilliant and Complex Topics Explained Perfectly By Infographics](https://designschool.canva.com/blog/best-infographics/)
* [NY Times Graphics Department](https://twitter.com/nytgraphics)
* [Open Data through R](https://github.com/ropensci/opendata): This Task View contains information about using R to obtain, parse, manipulate, create, and share open data. Much open data is available on the web, and the WebTechnologies TaskView addresses how to obtain and parse web-based data. There is obvious overlap between the two TaskViews, so some packages are described on both. There is also a considerable amount of open data available as R packages on CRAN.


## Example Project Titles from Fall 2016

* Understanding the influence of environmental variables on the distribution of mosses -- a data driven analysis
* Food Security
* Soil Radiation
* Obesity
* Space-time clustering-based analysis on lighting distribution
* The role of recruitment on octocoral community dynamics
* Spatial accessibility of primary care in Erie County, NY
* Flint Michigan water crisis
* Relationship between the unemployment and the gross domestic production (GDP)
* Zimbabwean Bushmeat
* U.S. Unemployment rates
