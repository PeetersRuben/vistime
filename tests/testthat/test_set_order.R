
 prepare_data <- function(dat){
  events <- "event"
  start <- "start"
  end <- "end"
  groups <- "group"
  colors <- "color"
  fontcolors <- "fontcolor"
  tooltips <- "tooltip"
  optimize_y <- TRUE
  linewidth <- NULL
  title <- NULL
  show_labels <- TRUE
  background_lines <- 11

  dat <- vistime:::validate_input(dat, start, end, events, groups, tooltips, optimize_y, linewidth, title, show_labels, background_lines)
  dat <- vistime:::set_colors(dat, colors, fontcolors)
  dat <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)
  return(dat)
}


dat <- data.frame(
  event = 1:3, start = c("2019-01-01", "2019-01-10", "2019-01-01"),
  end = c("2019-01-10", "2019-01-20", "2019-01-01")
)

dat <- prepare_data(dat)

test_that("ranges: no groups yield 1 subplot", {
  dat <- dat[dat$start != dat$end]
  expect_equal(1, unique(vistime:::set_order(dat)$subplot))
})

test_that("one subplot per group", {
  dat$group <- c(1,1,2)
  result <- vistime:::set_order(dat)
  expect_equal(result$group, result$subplot)
})

test_that("if range and event in same group, different subplots", {
  dat$group <- c(1, 2, 1)
  result <- vistime:::set_order(dat)

  expect_gt(length(result[result$group == 1, "subplot"]), 1) # Group 1 must have more than 1 subplot
  expect_equal(unique(result$subplot[result$group == 1]), 1) # Group 1 must have a single subplot
})

test_that("subplot order is same a input order", {
  d = read.csv(stringsAsFactors = FALSE,text = "event,start,duration,group
        compile datasets,0,2,descriptive analysis
        route networks,2,2,visualisation")
  start_date = as.Date("2018-05-01")
  d$start = start_date + d$start * 7
  d$end = d$start + d$duration * 7
  d$target_subplot <- c(1,2)

  dat <- prepare_data(d)
  expect_equal(vistime:::set_order(dat)$subplot, d$target_subplot)
})
