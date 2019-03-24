context("color tests")

# preparations
events <- "event"
start <- "start"
end <- "end"
groups <- "group"
colors <- "color"
fontcolors <- "fontcolor"
tooltips <- "tooltip"
linewidth <- NULL
title <- NULL
showLabels <- NULL
show_labels <- TRUE
lineInterval <- NULL
background_lines <- 11
data <- data.frame(
  event = 1:4, start = c("2019-01-01", "2019-01-10"),
  end = c("2019-01-01", "2019-01-10"),
  FARBE = c("red", "green"),
  stringsAsFactors = FALSE
)
data <- vistime:::validate_input(data, start, end, events, groups, linewidth, title, showLabels, show_labels, lineInterval, background_lines)


test_that("color columns not existing", {
  result <- vistime:::set_colors(data, eventcolor_column = "NOTEXISTING", fontcolor_column = "NOTEXISTING")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == "black"))
  expect_equal(result$col, c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072"))
})

test_that("eventcolor column existing", {
  result <- vistime:::set_colors(data, eventcolor_column = "FARBE", fontcolor_column = "NOTEXISTING")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_equal(result$col, c("red", "green", "red", "green"))
})

test_that("fontcolor column existing", {
  result <- vistime:::set_colors(data, eventcolor_column = "NOTEXISTING", fontcolor_column = "FARBE")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == result$FARBE))
  expect_equal(result$fontcol, c("red", "green", "red", "green"))
})

