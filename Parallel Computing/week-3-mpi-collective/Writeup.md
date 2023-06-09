# <center>Week 2 Assignments</center>

# Tasks

- [ ] Vector Normalization
  - So I'm still not getting great speedups with my vector normalizer but it does seem to be an improvement. The reason it looked like "spaghetti" was one of those bugs that resolves itself when you let your code sit for a while. I got rid of the else block entirely (since everyone does equal work) and put all collective functions directly in the code, only giving the root node special alone time for the things that only it can do. 

  |Cores| 100000| 200000| 300000 | 400000 | 500000|
  |-|-|-|-|-|-|
  |1|6.503127|12.985929|19.536019|26.063023|31.293385|
  |2|5.931910|11.799255|8.334471|23.467857|13.980030|
  |3|5.817193|5.096010|8.634525|13.261699|16.079679|
  |4|5.781921|10.776140|15.220199|20.032656|24.522412|



- [ ] Even/Odd Transposition Sort
  - New timing data shows a decrease in time with respect to an increase in processors when using updated merge code.

|Cores| 120000 | 240000| 360000| 480000| 600000|
|----|---------|--------|------|-------|-------|
|1| 0.021407 |0.033717 |0.042400 |0.048217 |0.057447 |
|2|0.011864 |0.021473 |0.025876 |0.022846 |0.032740 |
|3|0.008819 |0.007823 |0.011805 |0.016031 |0.020241 |
|4|0.006121 |0.006293 |0.009439 |0.016431 | 0.020622 |
